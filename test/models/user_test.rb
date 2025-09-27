require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "role defaults to employee" do
    user = User.create!(
      name: "Test User",
      email: "employee@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    assert_equal "employee", user.role
    assert user.employee?
  end

  test "role must be admin or employee" do
    user = User.new(
      name: "Another User",
      email: "invalid-role@example.com",
      password: "password123",
      password_confirmation: "password123",
      role: "manager"
    )

    assert_not user.valid?
    assert_includes user.errors[:role], "is not included in the list"
  end

  test "active scope excludes deleted users" do
    user = users(:one)
    user.update!(is_deleted: true)

    assert_not_includes User.active, user
    assert_includes User.deleted, user
  end

  test "deleted users cannot authenticate" do
    user = users(:one)
    user.update!(is_deleted: true)

    assert_not user.active_for_authentication?
    assert_equal :deleted_account, user.inactive_message
  end
end
