require "test_helper"

module Admin
  class WorkPlansControllerTest < ActionDispatch::IntegrationTest
    setup do
      @admin = users(:two)
      @employee = users(:one)
    end

    test "非管理者はリダイレクトされる" do
      travel_to Time.new(2024, 9, 5, 10, 0, 0, "+09:00") do
        sign_in @employee

        get admin_work_plans_path

        assert_redirected_to index_path(year: 2024, month: 9)
      end
    end

    test "管理者は画面を表示できる" do
      sign_in @admin

      get admin_work_plans_path(year: 2024, month: 9)

      assert_response :success
      assert_select "h1", text: "規定勤務日数の設定"
    end

    test "管理者は規定勤務日数を登録できる" do
      sign_in @admin

      target_period = Date.new(2024, 10, 1)

      assert_difference -> { WorkPlan.where(user: @employee, period: target_period).count }, 1 do
        post admin_work_plans_path, params: {
          year: target_period.year,
          month: target_period.month,
          work_plans: {
            "#{@employee.id}" => {
              user_id: @employee.id,
              planned_working_days: 15,
              planned_working_hours: 120,
              notes: "テスト"
            }
          }
        }
      end

      assert_redirected_to admin_work_plans_path(year: target_period.year, month: target_period.month)
      follow_redirect!
      assert_includes response.body, "保存しました。"

      plan = WorkPlan.find_by!(user: @employee, period: target_period)
      assert_equal 15, plan.planned_working_days
      assert_equal 120, plan.planned_working_hours
      assert_equal "テスト", plan.notes
      assert_equal @admin, plan.created_by
    end

    test "規定勤務時間を空欄のまま登録できる" do
      sign_in @admin

      target_period = Date.new(2024, 11, 1)

      post admin_work_plans_path, params: {
        year: target_period.year,
        month: target_period.month,
        work_plans: {
          "#{@employee.id}" => {
            user_id: @employee.id,
            planned_working_days: 12,
            planned_working_hours: "",
            notes: ""
          }
        }
      }

      assert_redirected_to admin_work_plans_path(year: target_period.year, month: target_period.month)
      follow_redirect!
      assert_includes response.body, "保存しました。"

      plan = WorkPlan.find_by!(user: @employee, period: target_period)
      assert_equal 12, plan.planned_working_days
      assert_nil plan.planned_working_hours
    end

    test "既存データを更新できる" do
      sign_in @admin

      existing_plan = work_plans(:one)
      assert_no_difference -> { WorkPlan.count } do
        post admin_work_plans_path, params: {
          year: existing_plan.period.year,
          month: existing_plan.period.month,
          work_plans: {
            "#{existing_plan.user_id}" => {
              user_id: existing_plan.user_id,
              planned_working_days: 25,
              planned_working_hours: "",
              notes: "更新後"
            }
          }
        }
      end

      assert_redirected_to admin_work_plans_path(year: existing_plan.period.year, month: existing_plan.period.month)
      existing_plan.reload
      assert_equal 25, existing_plan.planned_working_days
      assert_nil existing_plan.planned_working_hours
      assert_equal "更新後", existing_plan.notes
      assert_equal users(:two), existing_plan.created_by

      follow_redirect!
      assert_includes response.body, "保存しました。"
    end
  end
end
