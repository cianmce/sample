require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { 
      user: {
        name:  "",
        email: "foo@invalid",
        password:              "foo",
        password_confirmation: "bar" 
      } 
    }

    assert_template 'users/edit'
    assert_select 'div#error_explanation>div.alert.alert-danger', "The form contains 4 errors."
    assert_select 'div#error_explanation>ul>li', count: 4
    assert_select 'div#error_explanation>ul>li', "Name can't be blank"
    assert_select 'div#error_explanation>ul>li', "Password is too short (minimum is 6 characters)"
    assert_select 'div#error_explanation>ul>li', "Password confirmation doesn't match Password"
    assert_select 'div#error_explanation>ul>li', "Email is invalid"
    assert_select 'div.field_with_errors', count: 8
  end

  test "successful edit" do
    log_in_as(@user)
    patch user_path(@user), params: { 
      user: { 
        name:  "NewName",
        email: "new_email@gmail.com",
        password:              "password",
        password_confirmation: "password" 
      }
    }
    follow_redirect!
    assert_template 'users/show'
    assert_equal flash[:success], "Successful update!"

    @user.reload
    assert_select '.user_info>h1', 'NewName'
    assert_select '.user_info>span', 'new_email@gmail.com'
    assert_equal @user.name, 'NewName'
    assert_equal @user.email, 'new_email@gmail.com'


    get root_path
    assert flash.empty?
  end

  test "successful edit without password change" do
    log_in_as(@user)
    patch user_path(@user), params: { 
      user: { 
        name:  "NewName",
        email: "new_email@gmail.com",
        password:              "",
        password_confirmation: "" 
      }
    }
    follow_redirect!
    assert_template 'users/show'
    assert_equal flash[:success], "Successful update!"

    @user.reload
    assert_select '.user_info>h1', 'NewName'
    assert_select '.user_info>span', 'new_email@gmail.com'
    assert_equal @user.name, 'NewName'
    assert_equal @user.email, 'new_email@gmail.com'


    get root_path
    assert flash.empty?
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
end
