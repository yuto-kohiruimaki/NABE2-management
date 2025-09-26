class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # アソシエーション
  has_many :timestamps, dependent: :destroy
  has_many :posts, dependent: :destroy
  
  # バリデーション
  validates :name, presence: true
end
