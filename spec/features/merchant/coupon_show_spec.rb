require 'rails_helper'

RSpec.describe "As a merchant employee or admin"  do
  describe "when I visit a coupons show page" do
    xit "I see all of that coupon's info and a button to edit a coupon" do
      bike_shop = create(:merchant)
      merchant_admin = create(:user, role: 2, merchant: bike_shop)
      coupon_1 = bike_shop.coupons.create(name: "25% weekend promo", code: "WKD25", percent: 0.25)
      coupon_2 = bike_shop.coupons.create(name: "50% labor day promo", code: "LABOR50", percent: 0.5)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

      visit "/merchant/coupons/#{coupon_1.id}"


      expect(page).to have_button("Edit Coupon")
    end
  end
end
