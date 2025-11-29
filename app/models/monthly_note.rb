class MonthlyNote < ApplicationRecord
  validates :month, presence: true, uniqueness: true
  validates :month, format: { with: /\A\d{4}-(0[1-9]|1[0-2])\z/, message: "はYYYY-MM形式である必要があります" }
end
