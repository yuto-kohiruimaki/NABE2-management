class Timestamp < ApplicationRecord
  belongs_to :user
  
  # バリデーション
  validates :user_id, presence: true
  validates :work_date, presence: true
  
  # スコープ
  scope :by_date, ->(date) { where(work_date: date) }
  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :recent, -> { order(work_date: :desc) }
  
  # 作業時間を計算するメソッド
  def working_hours
    return 0 if start_time.blank? || finish_time.blank?
    ((finish_time - start_time) / 1.hour).round(2)
  end
  
  # 休日かどうかを判定
  def holiday?
    day_off == true
  end
end
