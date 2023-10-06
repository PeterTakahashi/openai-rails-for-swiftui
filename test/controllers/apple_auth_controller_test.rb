require 'test_helper'

class AppleAuthControllerTest < ActionDispatch::IntegrationTest
  test 'should get create' do
    get apple_auth_create_url
    assert_response :success
  end
end
