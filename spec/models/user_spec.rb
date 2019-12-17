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
  end

  describe 'roles' do
    it 'can be created as a regular user' do

    end
    xit 'can be created as a merchant employee' do

    end
    xit 'can be created as a merchant admin' do

    end
    xit 'can be created as an admin' do

    end
  end
end
