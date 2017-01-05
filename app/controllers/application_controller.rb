class ApplicationController < ActionController::API

  before_filter :set_cache_headers

  private

  def set_cache_headers
    if Rails.env.development?
      response.headers['Access-Control-Allow-Origin'] = '*'
    end
    response.headers['Access-Control-Allow-Credentials'] = true
    response.headers['Cache-Control'] = 'no-cache, no-store'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = 'Fri, 01 Jan 1990 00:00:00 GMT'
  end

end
