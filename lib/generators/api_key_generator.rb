require 'expirable_token'

class ApiKeyGenerator < Rails::Generators::Base
  def create_api_key
    seconds_year = 31_536_000
    time = Time.now.to_i + 10 * seconds_year
    token = ExpirableToken.new('api.m2ind.tk', [], time)
    ApiKey.create(:access_token => URI::decode(token.encode))
    puts token.encode
  end
end