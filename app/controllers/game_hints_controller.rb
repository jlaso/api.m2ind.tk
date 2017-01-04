require 'mastermind_game_cli'

class GameHintsController < ApplicationController

  # GET /game_hints
  def index
    begin
      raise 'game_token is mandatory' unless params[:game_token]
      game = Game.find_by_token(params[:game_token])
      raise 'game with game_token specified does not exist' unless game
      hints = []
      game.game_hints.each do |h|
        hints << h.hint
      end
      render json: {
        :success => true,
        :hints => hints,
        :hints_pos => get_hints_pos(game),
        :num_hints => hints.length,
        :max_num_hints => game.max_num_hints,
        :hints_left => game.max_num_hints - hints.length
      }
    rescue Exception => e
      render json: {
          :success => false,
          :error => e.message
      }, status: :internal_server_error
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
      raise "hints are limited to #{game.max_num_hints}" if game.game_hints.length >= game.max_num_hints
      hint = get_hint(game)
      raise 'No hint available for now' unless hint

      @game_hint = GameHint.create(:game_id => game.id, :game_token => game_token, :hint => hint)

      if @game_hint.save
        render json: {
            :success => true,
            :hint => @game_hint.hint,
            :hint_pos => game.sequence.index(hint),
            :num_hints => game.game_hints.length + 1,
            :hints_left => game.max_num_hints - game.game_hints.length - 1
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
  def get_hint(game)
    sequence = game.sequence
    hints = game.game_hints
    tries = game.game_tries
    candidates = []
    tries.each do |t|
      matches = MastermindGameCli::Checker.get_matches(sequence, t.try)
      matches.each do |match|
        candidates << match unless candidates.include? match
      end
    end
    hints.each do |h|
      hint = h.hint.to_s
      candidates.delete(hint) if candidates.include? hint
    end
    candidates[0].nil? ? nil : candidates.shuffle[0]
  end

  def get_hints_pos(game)
    sequence = game.sequence
    result = []
    hints = game.game_hints
    hints.each do |h|
      hint = h.hint.to_s
      result << {
          :index => sequence.index(hint),
          :hint => hint
      }
    end
    result
  end

end
