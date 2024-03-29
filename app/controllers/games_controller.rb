require 'mastermind_game_cli'

class GamesController < ApplicationController
  before_filter :restrict_access, only: [:index]

  # GET /games
  def index
    @games = Game.all

    render json: @games
  end

  # POST /games
  def create

    require_relative '../../lib/game_app'

    num_pos = params[:num_pos].nil? ? 5 : params[:num_pos].to_i
    num_pos = 9 if num_pos > 9
    num_pos = 4 if num_pos < 4
    sequence = MastermindGameCli::Sequence.new(num_pos)
    @game = Game.new({
        :token => Game.generate_unique_secure_token,
        :ip => request.remote_ip,
        :num_pos => num_pos,
        :sequence => sequence.value,
        :repeated => false #params[:repeated].nil? ? false : params[:repeated]
    })

    if @game.save
      render json: {
          :success => true,
          :token => @game.token,
          :num_pos => @game.num_pos,
          :repeated => @game.repeated?,
        # for the moment don't include the sequence to guess into the response
        #  :sequence => @game.sequence,
          :created => @game.created_at,
          :version => GameApp::VERSION
      }, status: :created
    else
      render json: {
          :success => false,
          :error => @game.errors
      }, status: :unprocessable_entity
    end
  end

  private
    def restrict_access
      api_key = ApiKey.find_by_access_token(params[:access_token])
      head :unauthorized unless api_key
    end
end
