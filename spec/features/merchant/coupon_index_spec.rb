require 'rails_helper'

RSpec.describe "As a merchant employee or admin"  do
  describe "when I visit my coupons index page" do
    it "the name of my coupon is a link to that coupon's show page" do
      bike_shop = create(:merchant)
      merchant_admin = create(:user, role: 2, merchant: bike_shop)
      coupon_1 = bike_shop.coupons.create(name: "25% weekend promo", code: "WKD25", percent: 0.25)
      coupon_2 = bike_shop.coupons.create(name: "50% labor day promo", code: "LABOR50", percent: 0.5)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

      visit merchant_coupons_path

      within "#coupon-#{coupon_1.id}" do
        click_link "#{coupon_1.name}"
      end

      expect(current_path).to eq("/merchant/coupons/#{coupon_1.id}")

      visit merchant_coupons_path
      
      within "#coupon-#{coupon_2.id}" do
        click_link "#{coupon_2.name}"
      end

      expect(current_path).to eq("/merchant/coupons/#{coupon_2.id}")
    end
  end
end
