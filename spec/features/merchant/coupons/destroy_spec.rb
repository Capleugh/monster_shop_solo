require 'rails_helper'

RSpec.describe "As a merchant" do
  describe "when I visit a coupon's show page" do
    it "I see a button to delete a coupon" do
      bike_shop = create(:merchant)
      merchant = create(:user, role: 1, merchant: bike_shop)
      coupon_1 = bike_shop.coupons.create(name: "25% weekend promo", code: "WKD25", percent: 0.25)
      coupon_2 = bike_shop.coupons.create(name: "50% labor day promo", code: "LABOR50", percent: 0.5)

     allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

      visit "/merchant/coupons/#{coupon_1.id}"

      click_button "Delete"

      expect(current_path).to eq(merchant_coupons_path)
      expect(page).to have_content("Coupon has been deleted.")
      bike_shop.reload
      visit merchant_coupons_path

      expect(page).to_not have_content(coupon_1.name)
      expect(page).to have_content(coupon_2.name)
    end
  end
    # come back and test for the event that a coupon has been used in an order

  describe "when I visit a the coupons index page" do
    it "I see a button to delete a coupon next to each coupon name" do
      bike_shop = create(:merchant)
      merchant = create(:user, role: 1, merchant: bike_shop)
      coupon_1 = bike_shop.coupons.create(name: "25% weekend promo", code: "WKD25", percent: 0.25)
      coupon_2 = bike_shop.coupons.create(name: "50% labor day promo", code: "LABOR50", percent: 0.5)

     allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

      visit merchant_coupons_path

      within "#coupon-#{coupon_1.id}" do
        click_button "Delete"
      end

      expect(current_path).to eq(merchant_coupons_path)
      expect(page).to have_content("Coupon has been deleted.")

      bike_shop.reload
      visit merchant_coupons_path

      expect(page).to_not have_content(coupon_1.name)
      expect(page).to have_content(coupon_2.name)

      within "#coupon-#{coupon_2.id}" do
        click_button "Delete"
      end

      expect(current_path).to eq(merchant_coupons_path)
      expect(page).to have_content("Coupon has been deleted.")

      bike_shop.reload
      visit merchant_coupons_path

      expect(page).to_not have_content(coupon_1.name)
      expect(page).to_not have_content(coupon_2.name)
    end
  end
end
