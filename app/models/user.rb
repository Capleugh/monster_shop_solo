class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true
  validates_presence_of :password, require: true

  validates_presence_of :name, :address, :city, :state, :zip
  has_many :orders


  has_many :orders
  belongs_to :merchant, optional: true

  has_secure_password

  enum role: ['default', 'merchant_employee', 'merchant_admin', 'admin']

  def user_order_count
    self.orders.count
  end
end
