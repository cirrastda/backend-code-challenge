require 'test_helper'

class DistancesControllerTest < ActionDispatch::IntegrationTest

  test "get distance new ok" do
	  begin 
	    assert_not(Rails.application.routes.recognize_path(
	        'distance'))
	  rescue ActionController::RoutingError => error
	    assert error.message.start_with? "No route matches"
	  end

  end


  test "post distance new ok" do
    post '/distance', params: 'Local3 Local4 10'
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal "ok", res["status"]
  end

  test "post distance update ok" do
    post '/distance', params: 'Local1 Local2 10'
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal "ok", res["status"]
  end

  test "post distance wrong params" do
    post '/distance', params: 'Local3 Local4'
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal "erro", res["status"]
    assert_equal "Invalid Format. Must be <ORIGIN> <DESTINATION> <DISTANCE>", res["mensagem"]
  end

  test "post distance less than 1" do
    post '/distance', params: 'Local3 Local4 0'
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal "erro", res["status"]
    assert_equal "Distance must be a number between 1 and 100000", res["mensagem"]
  end

  test "post distance greater than 100000" do
    post '/distance', params: 'Local3 Local4 999999'
    assert_response :success
    res = JSON.parse(response.body)
    assert_equal "erro", res["status"]
    assert_equal "Distance must be a number between 1 and 100000", res["mensagem"]
  end
end
