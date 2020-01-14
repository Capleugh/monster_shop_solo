require 'rails_helper'

describe Coupon, type: :model do
  describe "validations" do
    it { should validate_uniqueness_of :name }
    it { should validate_uniqueness_of :code }

    it { should validate_numericality_of(:percent).is_less_than_or_equal_to(1) }
    it { should validate_numericality_of(:percent).is_greater_than(0) }
  end

  describe "relationships" do
    it { should belong_to :merchant }
    it { should belong_to(:order).optional }
  end
end
