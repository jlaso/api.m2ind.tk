require 'test_helper'

class GameTriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @game_try = game_tries(:one)
  end

  test "should get index" do
    get game_tries_url, as: :json
    assert_response :success
  end

  test "should create game_try" do
    assert_difference('GameTry.count') do
      post game_tries_url, params: { game_try: { accepted: @game_try.accepted, game_token: @game_try.game_token, result: @game_try.result, seconds: @game_try.seconds, try: @game_try.try } }, as: :json
    end

    assert_response 201
  end

  test "should show game_try" do
    get game_try_url(@game_try), as: :json
    assert_response :success
  end

  test "should update game_try" do
    patch game_try_url(@game_try), params: { game_try: { accepted: @game_try.accepted, game_token: @game_try.game_token, result: @game_try.result, seconds: @game_try.seconds, try: @game_try.try } }, as: :json
    assert_response 200
  end

  test "should destroy game_try" do
    assert_difference('GameTry.count', -1) do
      delete game_try_url(@game_try), as: :json
    end

    assert_response 204
  end
end
