class ScoresController < ApplicationController

  # GET /scores
  def index

    if params[:fix_points]
      for score in Score.all do
        score.points = 0
        score.save
      end
    end

    @scores = Score.order(points: :desc).first(10)

    # @TODO: order by the right rate formula (tries, num_pos, repeated, seconds)

    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Credentials'] = true
    render json: @scores
  end

  # GET /scores/{game_token}
  def show
    @score = Score.find_by_game_token(params[:id])
    if @score
      render json: {
          :user => @score.user,
          :tries => @score.tries,
          :point => @score.points,
          :seconds => @score.seconds,
          :num_pos => @score.num_pos,
          :repeated => @score.repeated
      }
    else
      render json: nil
    end
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
      raise 'user already set' if @score.user != 'unknown'

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
