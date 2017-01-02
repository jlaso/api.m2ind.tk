require 'mastermind_game_cli'

class GameHintsController < ApplicationController

  # GET /game_hints
  def index
    if !params[:game_token].nil?
      @game_hints = GameTry.where(game_token: params[:game_token])
      render json: @game_hints
    else
      api_key = ApiKey.find_by_access_token(params[:access_token])
      if api_key
        @game_hints = GameTry.all
        render json: @game_hints
      else
        head :unauthorized
      end
    end
  end

  # GET /game_hints/1
  def show
    render json: @game_hint
  end

  # POST /game_hints
  def create
    begin
      raise 'game_token is mandatory' unless params[:game_token]
      game_token = params[:game_token]
      raise 'game already finished' if Score.find_by_game_token(game_token)
      game = Game.find_by_token(game_token)
      raise 'game with game_token specified does not exist' unless game
      hints = GameHint.where(game_token: game_token)
      num_hints_used_so_far = hints.length + 1  # counting the current one

      @game_hint = GameHint.new({
                                  :game_id => game.id,
                                  :game_token => game_token,
                                  :hint => finished ? nil : get_hint(game.sequence, hints)
                              })

      if @game_hint.save
        render json: {
            :success => true,
            :hint => @game_hint.hint,
            :hint_num => num_hints_used_so_far
        }, status: :ok
      else
        render json: @game_hint.errors, status: :unprocessable_entity
      end
    rescue Exception => e
      render json: {
          :success => false,
          :error => e.message
      }, status: :internal_server_error
    end
  end

  private
  def get_hint(sequence, tries)
    candidates = []
    tries.each do |t|
      matches = MastermindGameCli::Checker.get_matches(sequence, t.try)
      matches.each do |match|
        candidates << match unless candidates.include? match
      end
    end
    candidates[0].nil? ? nil : candidates.shuffle[0]
  end

end
