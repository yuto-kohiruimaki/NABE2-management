class Post < ApplicationRecord
  belongs_to :user
  
  # バリデーション
  validates :user_id, presence: true
  validates :post_date, presence: true
  validates :place, presence: true
  validates :name, presence: true
  
  # スコープ
  scope :by_date, ->(date) { where(post_date: date) }
  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :by_place, ->(place) { where(place: place) }
  scope :recent, -> { order(post_date: :desc) }
  scope :by_month, ->(year, month) { 
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month
    where(post_date: start_date..end_date)
  }
end
