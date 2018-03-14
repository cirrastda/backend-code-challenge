require 'test_helper'

class CostsControllerTest < ActionDispatch::IntegrationTest

  test "get cost without origin" do
    get '/cost?destination=Local1&weight=5'
    assert_response :success
    res = response.body
    assert_equal "Origin not set", res
  end

  test "get cost without destiny" do
    get '/cost?origin=Local1&weight=5'
    assert_response :success
    res = response.body
    assert_equal "Destination not set", res
  end

  test "get cost without weigth" do
    get '/cost?origin=Local1&destination=Local2'
    assert_response :success
    res = response.body
    assert_equal "Weight not set", res
  end

  test "get cost with weigth less than 1" do
    get '/cost?origin=Local1&destination=Local2&weight=0'
    assert_response :success
    res = response.body
    assert_equal "Weight must be between 1 e 50", res
  end

  test "get cost with weigth greater than 50" do
    get '/cost?origin=Local1&destination=Local2&weight=51'
    assert_response :success
    res = response.body
    assert_equal "Weight must be between 1 e 50", res
  end

  test "get cost no path found" do
    get '/cost?origin=Local3&destination=Local4&weight=5'
    assert_response :success
    res = response.body
    assert_equal "No Path Found between Origin and Destination", res
  end

  test "get cost smaller distance with 1 route" do
    get '/cost?origin=Local2&destination=Local3&weight=5'
    assert_response :success
    res = response.body
    assert_equal "6.0", res
  end

  test "get cost smaller distance with 2 routes" do
    get '/cost?origin=Local1&destination=Local3&weight=5'
    assert_response :success
    res = response.body
    assert_equal "13.5", res
  end

end
