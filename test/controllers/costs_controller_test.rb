require 'test_helper'

class CostsControllerTest < ActionDispatch::IntegrationTest
  test "should get process" do
    get costs_process_url
    assert_response :success
  end

end
