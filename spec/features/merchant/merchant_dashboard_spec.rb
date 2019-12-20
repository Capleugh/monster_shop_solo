require 'rails_helper'

RSpec.describe "As a merchant employee or merchant admin" do
  describe "when I visit my merchant dashboard" do
    xit "I see the name and full address of the merchant I work for" do
      merchant_employee = create(:user, role: 1)
      bike_shop = create(:merchant)

      bike_shop.merchant_employees << merchant_employee

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)

      visit merchants_path

      expect(page).to have_content(bike_shop.name)
      expect(page).to have_content(bike_shop.address)
      expect(page).to have_content(bike_shop.city)
      expect(page).to have_content(bike_shop.state)
      expect(page).to have_content(bike_shop.zip)
    end
  end

  describe "when I visit my merchant dashboard" do
    xit "I see the name and full address of the merchant I work for" do
      merchant_admin = create(:user, role: 2)
      bike_shop = create(:merchant)


      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

      visit merchants_path

      expect(page).to have_content(bike_shop.name)
      expect(page).to have_content(bike_shop.address)
      expect(page).to have_content(bike_shop.city)
      expect(page).to have_content(bike_shop.state)
      expect(page).to have_content(bike_shop.zip)
    end
  end
end
