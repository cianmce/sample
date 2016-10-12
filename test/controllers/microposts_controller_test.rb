require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @correct_user = users(:michael)
    @wrong_user   = users(:archer)
    @micropost    = microposts(:orange)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong micropost" do
    log_in_as(@wrong_user)
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to root_url
  end

  test "should delete micropost for correct user" do
    log_in_as(@correct_user)
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(@micropost)
    end
    # assert_redirected_to root_url
  end
end
