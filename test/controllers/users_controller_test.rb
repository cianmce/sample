require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
  end
  
  test "should get new" do
    get signup_path
    assert_response :success
    assert_select "title", full_title("Sign up")
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@admin)
    needs_login
  end

  test "should redirect edit patch when not logged in" do
    patch user_path(@admin), params: { 
      user: { 
        name:  @admin.name,
        email: "new_email@gmail.com",
        password:              "",
        password_confirmation: "" 
      }
    }
    needs_login
  end

  test "should redirect edit when not correct user" do
    log_in_as @non_admin
    get edit_user_path(@admin)
    wrong_user
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@non_admin)
    assert_not @non_admin.admin?
    patch user_path(@non_admin), params: {
      user: { 
        password:              'password',
        password_confirmation: 'password',
        admin: true
      } 
    }
    assert_not @non_admin.reload.admin?
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@admin)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as @non_admin
    assert_no_difference 'User.count' do
      delete user_path(@admin)
    end
    assert_redirected_to root_url
  end

  test "should redirect destroy when delete self as admin" do
    log_in_as(@admin)
    assert_no_difference 'User.count' do
      delete user_path(@admin)
    end
    assert_redirected_to root_url
    assert_not flash.empty?
  end
end
