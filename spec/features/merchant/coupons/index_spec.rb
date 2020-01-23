require 'rails_helper'

RSpec.describe "As a merchant employee or admin"  do
  describe "when I visit my coupons index page" do
    it "the name of my coupon is a link to that coupon's show page" do
      bike_shop = create(:merchant)
      merchant_employee = create(:user, role: 1, merchant: bike_shop)
      coupon_1 = bike_shop.coupons.create(name: "25% weekend promo", code: "WKD25", percent: 0.25)
      coupon_2 = bike_shop.coupons.create(name: "50% labor day promo", code: "LABOR50", percent: 0.5)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)

      visit merchant_user_coupons_path

      within "#coupon-#{coupon_1.id}" do
        click_link "#{coupon_1.name}"
      end

      expect(current_path).to eq("/merchant/coupons/#{coupon_1.id}")

      visit merchant_user_coupons_path

      within "#coupon-#{coupon_2.id}" do
        click_link "#{coupon_2.name}"
      end

      expect(current_path).to eq("/merchant/coupons/#{coupon_2.id}")
    end

    it "the name of my coupon is a link to that coupon's show page" do
      bike_shop = create(:merchant)
      merchant_admin = create(:user, role: 2, merchant: bike_shop)
      coupon_1 = bike_shop.coupons.create(name: "25% weekend promo", code: "WKD25", percent: 0.25)
      coupon_2 = bike_shop.coupons.create(name: "50% labor day promo", code: "LABOR50", percent: 0.5)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

      visit merchant_user_coupons_path

      within "#coupon-#{coupon_1.id}" do
        click_link "#{coupon_1.name}"
      end

      expect(current_path).to eq("/merchant/coupons/#{coupon_1.id}")

      visit merchant_user_coupons_path

      within "#coupon-#{coupon_2.id}" do
        click_link "#{coupon_2.name}"
      end

      expect(current_path).to eq("/merchant/coupons/#{coupon_2.id}")
    end

    it "I see a button to add a new coupon" do
      bike_shop = create(:merchant)
      merchant_employee = create(:user, role: 1, merchant: bike_shop)
      coupon_1 = bike_shop.coupons.create(name: "25% weekend promo", code: "WKD25", percent: 0.25)
      coupon_2 = bike_shop.coupons.create(name: "50% labor day promo", code: "LABOR50", percent: 0.5)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)

      visit merchant_user_coupons_path

      expect(page).to have_link("Add Coupon")
    end

    it "I see a button to add a new coupon" do
      bike_shop = create(:merchant)
      merchant_admin = create(:user, role: 2, merchant: bike_shop)
      coupon_1 = bike_shop.coupons.create(name: "25% weekend promo", code: "WKD25", percent: 0.25)
      coupon_2 = bike_shop.coupons.create(name: "50% labor day promo", code: "LABOR50", percent: 0.5)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

      visit merchant_user_coupons_path

      expect(page).to have_link("Add Coupon")
    end

    it "I see a link to edit my coupons next to each coupon name" do
      bike_shop = create(:merchant)
      merchant = create(:user, role: 1, merchant: bike_shop)
      coupon_1 = bike_shop.coupons.create(name: "25% weekend promo", code: "WKD25", percent: 0.25)
      coupon_2 = bike_shop.coupons.create(name: "50% labor day promo", code: "LABOR50", percent: 0.5)

     allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

     visit merchant_user_coupons_path

     within "#coupon-#{coupon_1.id}" do
       click_link "Edit"
     end

     expect(current_path).to eq("/merchant/coupons/#{coupon_1.id}/edit")

     expect(find_field('Name').value).to eq('25% weekend promo')
     expect(find_field('Code').value).to eq('WKD25')
     expect(find_field('Percent').value).to eq('0.25')

     name = '70% we gotta get rid of it promo'
     code = 'BURDEN70'
     percent = '0.70'

     fill_in 'Name', with: name
     fill_in 'Code', with: code
     fill_in 'Percent', with: percent

     click_button 'Submit'

     expect(current_path).to eq(merchant_user_coupons_path)
     expect(page).to have_content("Coupon has been updated!")



     within "#coupon-#{coupon_2.id}" do
       click_link "Edit"
     end

     expect(current_path).to eq("/merchant/coupons/#{coupon_2.id}/edit")

     expect(find_field('Name').value).to eq('50% labor day promo')
     expect(find_field('Code').value).to eq('LABOR50')
     expect(find_field('Percent').value).to eq('0.5')

     name = '50% we gotta get rid of it promo'
     code = 'BURDEN50'
     percent = '0.5'

     fill_in 'Name', with: name
     fill_in 'Code', with: code
     fill_in 'Percent', with: percent

     click_button 'Submit'

     expect(current_path).to eq(merchant_user_coupons_path)
     expect(page).to have_content("Coupon has been updated!")
    end
  end
end
