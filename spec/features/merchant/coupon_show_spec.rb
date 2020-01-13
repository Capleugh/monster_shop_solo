require 'rails_helper'

RSpec.describe "As a merchant employee"  do
  describe "when I visit a coupons show page" do
    it "I see all of that coupon's info and a button to edit a coupon" do
      bike_shop = create(:merchant)
      merchant_employee = create(:user, role: 1, merchant: bike_shop)
      coupon_1 = bike_shop.coupons.create(name: "25% weekend promo", code: "WKD25", percent: 0.25)
      coupon_2 = bike_shop.coupons.create(name: "50% labor day promo", code: "LABOR50", percent: 0.5)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)

      visit "/merchant/coupons/#{coupon_1.id}"

      expect(page).to have_content(coupon_1.name)
      expect(page).to have_content(coupon_1.code)
      expect(page).to have_content(coupon_1.percent)

      click_link "Edit"
      expect(current_path).to eq("/merchant/coupons/#{coupon_1.id}/edit")
    end
  end
end
