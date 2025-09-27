require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "users index excludes deleted employees" do
    sign_in users(:two)

    get users_path
    assert_response :success

    assert_select ".index-content-name span", text: /Test Employee/
    assert_select ".index-content-name span", text: /Deleted Employee/, count: 0
  end

  test "admin root shows management menu" do
    sign_in users(:two)

    get admin_path
    assert_response :success

    assert_select ".admin-users-menu__title", text: "管理画面"
    assert_select "a.admin-users-menu__link", text: /規定勤務日数を設定する/
    assert_select "a.admin-users-menu__link", text: /ユーザー管理/
  end

  test "admin users index includes deleted users" do
    sign_in users(:two)

    get admin_users_path
    assert_response :success

    assert_select "table.admin-users-table tbody tr", minimum: 1
    assert_select "table.admin-users-table", text: /Test Employee/
    assert_select "table.admin-users-table", text: /Deleted Employee/
    assert_select "table.admin-users-table", text: /無効/
  end

  test "admin can deactivate active user" do
    sign_in users(:two)

    year = 2025
    month = 1

    patch toggle_status_admin_user_path(users(:one)), params: {
      user: { is_deleted: true },
      year: year,
      month: month
    }

    assert_redirected_to admin_users_path(year: year, month: month)
    assert users(:one).reload.is_deleted?
  end

  test "admin can activate deleted user" do
    sign_in users(:two)

    year = 2025
    month = 1

    patch toggle_status_admin_user_path(users(:deleted_employee)), params: {
      user: { is_deleted: false },
      year: year,
      month: month
    }

    assert_redirected_to admin_users_path(year: year, month: month)
    assert_not users(:deleted_employee).reload.is_deleted?
  end
end
