require 'rails_helper'

RSpec.describe User do
  describe "validations" do
    it {should validate_presence_of :name}
    it {should validate_presence_of :address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip}
    it {should validate_presence_of :email}
    it {should validate_uniqueness_of :email}
    it {should validate_presence_of :password}

  describe "relationships" do
    it {should have_many :orders}
    it {should belong_to(:merchant).optional}
  end

  end

  describe 'roles' do
    it 'can be created as a regular user' do
     user = create(:user, role: 0)

     expect(user.role).to eq('default')
     expect(user.default?).to be_truthy
    end

    it 'can be created as a merchant employee' do
      user = create(:user, role: 1)

      expect(user.role).to eq('merchant_employee')
      expect(user.merchant_employee?).to be_truthy
    end

    it 'can be created as a merchant admin' do
      user = create(:user, role: 2)

      expect(user.role).to eq('merchant_admin')
      expect(user.merchant_admin?).to be_truthy
    end

    it 'can be created as an admin' do
      user = create(:user, role: 3)

      expect(user.role).to eq('admin')
      expect(user.admin?).to be_truthy
    end
  end

  describe 'methods' do
    it 'can get a count of total orders' do
      user = create(:user)

      order_1 = create(:order, user: user, status: 1)
      order_2 = create(:order, user: user, status: 2)
      order_3 = create(:order, user: user, status: 0)

      expect(user.user_order_count).to eq(3)
    end
  end
end
