class ScoresController < ApplicationController

  # GET /scores
  def index
    @scores = Score.order(:tries).first(10)

    render json: @scores
  end

end
