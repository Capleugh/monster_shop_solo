class Coupon < ApplicationRecord
  belongs_to :merchant
  belongs_to :order, optional: true

  validates :name, uniqueness: true, presence: true
  validates :code, uniqueness: true, presence: true

  validates_numericality_of :percent, less_than_or_equal_to: 1, greater_than: 0
end
