class ScoresController < ApplicationController

  # GET /scores
  def index
    @scores = Score.order(:tries).first(10)

    # @TODO: order by the right rate formula (tries, num_pos, repeated, seconds)

    render json: @scores
  end


  # PATCH/PUT /scores/1
  def update

    begin
      raise 'game_token is mandatory' unless params[:game_token]
      raise 'user is mandatory' unless params[:user]
      game_token = params[:game_token]
      score_id = params[:id]
      user = params[:user]
      @score = Score.find(score_id)
      raise 'score game not found' unless @score
      raise 'data mismatch' if @score.game_token != game_token

      if @score.update({:user => user})
        render json: {
            :success => true
        }
      else
        render json: @score.errors, status: :unprocessable_entity
      end
    rescue Exception => e
      render json: {
          :success => false,
          :error => e.message
      }, status: :internal_server_error
    end
  end

end
