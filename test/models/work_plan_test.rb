require "test_helper"

class WorkPlanTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
  end

  test "normalizes period to first day of month" do
    plan = WorkPlan.create!(
      user: @user,
      period: Date.new(2024, 10, 15),
      planned_working_days: 15
    )

    assert_equal Date.new(2024, 10, 1), plan.period
  end

  test "enforces uniqueness per user and period" do
    duplicate = WorkPlan.new(
      user: @user,
      period: Date.new(2024, 9, 15),
      planned_working_days: 10
    )

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:period], "has already been taken"
  end

  test "for_period scope finds by month" do
    period = Date.new(2024, 9, 15)
    plan = WorkPlan.for_period(period).find_by(user: @user)

    assert_equal work_plans(:one), plan
  end
end
