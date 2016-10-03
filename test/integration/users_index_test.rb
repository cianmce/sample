require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    page_num = 1
    page_of_users = User.where
      .not(activated_at: nil)
      .paginate(page: page_num)
    while page_of_users.length > 0
      get users_path, params: { page: page_num}
      assert_template 'users/index'
      assert_select 'div.pagination'
      page_of_users.each do |user|
        assert_select 'a[href=?]', user_path(user), text: user.name
        unless user == @admin
          assert_select 'a[href=?]', user_path(user), text: 'delete'
        end
      end
      page_num += 1
      page_of_users = User.where
        .not(activated_at: nil)
        .paginate(page: page_num)
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end
