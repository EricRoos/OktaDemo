require 'test_helper'

class OktaControllerTest < ActionDispatch::IntegrationTest
  test "should get callback" do
    get okta_callback_url
    assert_response :success
  end

end
