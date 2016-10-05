require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test "password resets" do
    get login_path
    assert_select "a[href=?]", new_password_reset_path, text: '(forgot password?)'
    get new_password_reset_path

    # Invalid email
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    
    # Valid email
    assert_template 'password_resets/new'
    post password_resets_path, params: { 
      password_reset: { 
        email:    @user.email
      } 
    }

    assert_redirected_to root_url
    assert_not flash.empty?
    assert_match @user.email, flash[:info]
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)

    # Wrong email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url

    # Inactive user
    activated_at = user.activated_at
    user.update_attribute(:activated_at, nil)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    assert_not flash.empty?
    user.update_attribute(:activated_at, activated_at)

    # Expired token
    reset_sent_at = user.reset_sent_at
    user.update_attribute(:reset_sent_at, 3.hours.ago)

    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to new_password_reset_url
    assert_not flash.empty?
    user.update_attribute(:reset_sent_at, reset_sent_at)

    # Right email, wrong token
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url

    # Right email, right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email

    # Not the same password & confirmation
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "barquux" } }
    assert_select 'div#error_explanation'

    # Invalid password & confirmation
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foo",
                            password_confirmation: "foo" } }
    assert_select 'div#error_explanation'

    # Empty password
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "",
                            password_confirmation: "" } }
    assert_select 'div#error_explanation'

    # Valid password & confirmation
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user

    # Only use reset link once
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }
    assert is_logged_in?
    assert_not flash[:danger].empty?
    assert_redirected_to root_url
    user.reload
    assert_nil user.reset_digest

  end

end
