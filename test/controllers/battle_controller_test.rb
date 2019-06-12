require 'test_helper'

class BattleControllerTest < ActionDispatch::IntegrationTest
  test "should get result" do
    get battle_result_url
    assert_response :success
  end

end
