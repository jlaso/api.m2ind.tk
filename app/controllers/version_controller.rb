require_relative '../../lib/version'

class VersionController < ApplicationController

  # GET /version
  def index
    render json: {
        :version => APP_VERSION,
        :more_info => 'https://github.com/jlaso/api.m2ind.tk'
    }
  end

end
