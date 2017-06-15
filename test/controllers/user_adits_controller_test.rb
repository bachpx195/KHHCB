require 'test_helper'

class UserAditsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_adit = user_adits(:one)
  end

  test "should get index" do
    get user_adits_url
    assert_response :success
  end

  test "should get new" do
    get new_user_adit_url
    assert_response :success
  end

  test "should create user_adit" do
    assert_difference('UserAdit.count') do
      post user_adits_url, params: { user_adit: { cource: @user_adit.cource, type: @user_adit.type, user: @user_adit.user } }
    end

    assert_redirected_to user_adit_url(UserAdit.last)
  end

  test "should show user_adit" do
    get user_adit_url(@user_adit)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_adit_url(@user_adit)
    assert_response :success
  end

  test "should update user_adit" do
    patch user_adit_url(@user_adit), params: { user_adit: { cource: @user_adit.cource, type: @user_adit.type, user: @user_adit.user } }
    assert_redirected_to user_adit_url(@user_adit)
  end

  test "should destroy user_adit" do
    assert_difference('UserAdit.count', -1) do
      delete user_adit_url(@user_adit)
    end

    assert_redirected_to user_adits_url
  end
end
