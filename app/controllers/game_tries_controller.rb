require 'mastermind_game_cli'

class GameTriesController < ApplicationController
  before_action :set_game_try, only: [:show, :update, :destroy]
  before_filter :restrict_access, only: [:index]

  # GET /game_tries
  def index
    @game_tries = GameTry.all

    render json: @game_tries
  end

  # GET /game_tries/1
  def show
    render json: @game_try
  end

  # POST /game_tries
  def create
    begin
      raise 'game_token is mandatory' unless params[:game_token]
      game_token = params[:game_token]
      raise 'game already finished' if Score.find_by_game_token(game_token)
      game = Game.find_by_token(game_token)
      raise 'game with game_token specified does not exist' unless game
      raise 'try is mandatory' unless params[:try]
      guess = params[:try]
      raise "Bad try, I expect a combination of #{game.num_pos} digits" unless guess.length.equal? game.num_pos
      raise 'Bad try, I expect only digits' unless MastermindGameCli::Checker.only_digits? guess
      raise 'Bad try, I expect a combination without repetitions' if !game.repeated? and MastermindGameCli::Checker.repeated? guess
      raise 'Bad try, you already tried that one' if GameTry.where(game_token: game_token, try: guess).take
      tries = GameTry.where(game_token: game_token)
      result = MastermindGameCli::Checker.check(game.sequence, guess)
      finished = (result == '1' * game.num_pos)
      seconds = Time.now.to_i - game.created_at.to_i
      score_id = finished ? save_score(game, seconds, tries) : nil

      @game_try = GameTry.new({
                                  :game_token => game_token,
                                  :try => guess,
                                  :result => result,
                                  :accepted => true,
                                  :seconds => seconds
                              })

      if @game_try.save
        render json: {
            :try => guess,
            :success => true,
            :result => result,
            :you_win => finished,
            :score => score_id,
            :hint => finished ? nil : get_hint(game.sequence, guess, tries),
            :try_num => tries.length # because the new one is already included in the where (live ?)
        }, status: :ok
        #render json: @game_try, status: :created, location: @game_try
      else
        render json: @game_try.errors, status: :unprocessable_entity
      end
    rescue Exception => e
      render json: {
          :success => false,
          :error => e.message
      }, status: :internal_server_error
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_game_try
    @game_try = GameTry.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def game_try_params
    params.require(:game_try).permit(:game_token, :try, :result, :seconds, :accepted)
  end

  def restrict_access
    api_key = ApiKey.find_by_access_token(params[:access_token])
    head :unauthorized unless api_key
  end

  def get_hint(sequence, guess, tries)
    candidates = []
    matches = MastermindGameCli::Checker.get_matches(sequence, guess)
    matches.each do |match|
      candidates << match unless candidates.include? match
    end
    tries.each do |t|
      matches = MastermindGameCli::Checker.get_matches(sequence, t.try)
      matches.each do |match|
        candidates << match unless candidates.include? match
      end
    end
    candidates[0].nil? ? nil : candidates.shuffle[0]
  end

  def save_score(game, seconds, tries)
    score = Score.new({
                          :game_token => game.token,
                          :user => 'unknown',
                          :tries => 1 + tries.length,
                          :seconds => seconds,
                          :num_pos => game.num_pos,
                          :repeated => game.repeated?
                      })
    score.save
    score.id
  end
end
