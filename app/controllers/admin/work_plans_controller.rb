module Admin
  class WorkPlansController < ApplicationController
    before_action :require_admin!

    def index
      @period = current_period
      @year = @period.year
      @month = @period.month
      @users = User.active.order(:id)
      @work_plans = WorkPlan.for_period(@period).index_by(&:user_id)
      @prev_period = (@period - 1.month).beginning_of_month
      @next_period = (@period + 1.month).beginning_of_month
    end

    def create
      @period = current_period

      ActiveRecord::Base.transaction do
        sanitized_work_plans.each do |attributes|
          next if attributes.blank?

          plan = WorkPlan.find_or_initialize_by(user_id: attributes[:user_id], period: @period)
          if plan.new_record? && attributes[:planned_working_days].nil?
            next
          end

          plan.assign_attributes(attributes.except(:user_id))
          plan.created_by ||= current_user
          plan.save!
        end
      end

      redirect_to admin_work_plans_path(year: @period.year, month: @period.month), notice: "保存しました。"
    rescue ActiveRecord::RecordInvalid => e
      @year = @period.year
      @month = @period.month
      @users = User.active.order(:id)
      @work_plans = WorkPlan.for_period(@period).index_by(&:user_id)
      @prev_period = (@period - 1.month).beginning_of_month
      @next_period = (@period + 1.month).beginning_of_month
      flash.now[:alert] = "更新に失敗しました: #{e.record.errors.full_messages.first}"
      render :index, status: :unprocessable_entity
    end

    private

    def current_period
      year = params[:year].presence&.to_i || Date.today.year
      month = params[:month].presence&.to_i || Date.today.month

      Date.new(year, month, 1)
    rescue ArgumentError
      Date.today.beginning_of_month
    end

    def sanitized_work_plans
      raw = params[:work_plans]
      return [] unless raw.present?

      raw = raw.to_unsafe_h if raw.respond_to?(:to_unsafe_h)

      raw.map do |_key, value|
        permitted = ActionController::Parameters.new(value).permit(:user_id, :planned_working_days, :planned_working_hours, :notes)
        next if permitted[:user_id].blank?

        attrs = permitted.to_h.symbolize_keys
        attrs[:user_id] = attrs[:user_id].to_i
        attrs[:planned_working_days] = attrs[:planned_working_days].present? ? attrs[:planned_working_days].to_i : nil
        attrs[:planned_working_hours] = attrs[:planned_working_hours].present? ? attrs[:planned_working_hours].to_i : nil
        attrs[:notes] = attrs[:notes].presence

        attrs
      end.compact
    end
  end
end
