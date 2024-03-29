require 'mastermind_game_cli'

class GameTriesController < ApplicationController

  # GET /game_tries
  def index
    if !params[:game_token].nil?
      @game_tries = GameTry.where(game_token: params[:game_token])
      if !params[:check_try].nil?
        check_try = params[:check_try]
        result = []
        for game_try in @game_tries do
          r = MastermindGameCli::Checker.check(check_try, game_try.try)
          m = MastermindGameCli::Checker.get_matches(check_try, game_try.try)
          result.push(
              :try => game_try.try,
              :result => (r == game_try.result),
              :matches => (game_try.result.count('1') == m.length)
          )
        end
        render json: result
      else
        render json: @game_tries
      end
    else
      api_key = ApiKey.find_by_access_token(params[:access_token])
      if api_key
        @game_tries = GameTry.all
        render json: @game_tries
      else
        head :unauthorized
      end
    end
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
      result = MastermindGameCli::Checker.check(game.sequence, guess)
      finished = (result == '1' * game.num_pos)
      seconds = Time.now.to_i - game.created_at.to_i
      num_tries_used_so_far = game.game_tries.length + 1 # counting the current one
      score_id = finished ? save_score(game, seconds, num_tries_used_so_far) : nil

      @game_try = GameTry.new(
          :game_id => game.id,
          :game_token => game_token,
          :try => guess,
          :result => result,
          :accepted => true,
          :seconds => seconds,
      )

      if @game_try.save
        render json: {
            :try => guess,
            :success => true,
            :result => result,
            :you_win => finished,
            :score => score_id,
            :try_num => num_tries_used_so_far
        }, status: :ok
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
  def save_score(game, seconds, num_tries)
    score = Score.new(
        :game_id => game.id,
        :game_token => game.token,
        :user => 'unknown',
        :tries => num_tries,
        :seconds => seconds,
        :num_pos => game.num_pos,
        :repeated => game.repeated?
    )
    score.save
    score.id
  end
end
