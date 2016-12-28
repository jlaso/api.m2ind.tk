class ScoresController < ApplicationController

  # GET /scores
  def index
    @scores = Score.order(:tries).first(10)

    # @TODO: order by the right rate formula (tries, num_pos, repeated, seconds)

    render json: @scores
  end

end
