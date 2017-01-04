class VersionController < ApplicationController

  # GET /version
  def index

    require_relative '../../lib/game_app'

    render json: {
        :version => GameApp::VERSION,
        :more_info => 'https://github.com/jlaso/api.m2ind.tk'
    }
  end

end
