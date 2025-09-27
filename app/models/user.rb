class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ROLES = {
    employee: "employee",
    admin: "admin"
  }.freeze

  # アソシエーション
  has_many :timestamps, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :work_plans, dependent: :destroy
  has_many :created_work_plans, class_name: "WorkPlan", foreign_key: :created_by_id, inverse_of: :created_by

  # バリデーション
  validates :name, presence: true
  validates :role, inclusion: { in: ROLES.values }

  scope :active, -> { where(is_deleted: false) }
  scope :deleted, -> { where(is_deleted: true) }

  def active_for_authentication?
    super && !is_deleted?
  end

  def inactive_message
    is_deleted? ? :deleted_account : super
  end

  before_validation :set_default_role, on: :create

  def admin?
    role == ROLES[:admin]
  end

  def employee?
    role == ROLES[:employee]
  end

  private

  def set_default_role
    self.role ||= ROLES[:employee]
  end
end
