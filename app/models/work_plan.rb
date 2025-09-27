class WorkPlan < ApplicationRecord
  belongs_to :user, inverse_of: :work_plans
  belongs_to :created_by, class_name: "User", optional: true, inverse_of: :created_work_plans

  before_validation :normalize_period

  validates :period, presence: true, uniqueness: { scope: :user_id }
  validates :planned_working_days,
            numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :planned_working_hours,
            numericality: { greater_than_or_equal_to: 0, only_integer: true },
            allow_nil: true

  scope :for_period, ->(date) { where(period: date.to_date.beginning_of_month) }
  scope :for_month, lambda { |year, month|
    date = Date.new(year, month, 1)
    where(period: date)
  }

  private

  def normalize_period
    return if period.blank?

    self.period = period.to_date.beginning_of_month
  end
end
