require 'test_helper'

class LoginControllerTest < ActionDispatch::IntegrationTest
  test "should get metamask" do
    get login_metamask_url
    assert_response :success
  end

end
