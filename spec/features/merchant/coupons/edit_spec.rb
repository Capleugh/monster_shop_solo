require 'rails_helper'

RSpec.describe "As a merchant"  do
  describe "when I visit a coupon edit form" do
    it "I see a form (prepoulated with my original info) to edit my coupon" do
      bike_shop = create(:merchant)
      merchant = create(:user, role: 1, merchant: bike_shop)
      coupon_1 = bike_shop.coupons.create(name: "25% weekend promo", code: "WKD25", percent: 0.25)


      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)


      visit "/merchant/coupons/#{coupon_1.id}/edit"

      expect(find_field('Name').value).to eq('25% weekend promo')
      expect(find_field('Code').value).to eq('WKD25')
      expect(find_field('Percent').value).to eq('0.25')


      name = '30% weekend promo'
      code = 'WKD30'
      percent = '0.30'

      fill_in 'Name', with: name
      fill_in 'Code', with: code
      fill_in 'Percent', with: percent

      click_button 'Submit'

      expect(current_path).to eq(merchant_user_coupons_path)
      expect(page).to have_content("Coupon has been updated!")
    end

    it "text fields cannot be left blank" do
      bike_shop = create(:merchant)
      merchant = create(:user, role: 1, merchant: bike_shop)
      coupon_1 = bike_shop.coupons.create(name: "25% weekend promo", code: "WKD25", percent: 0.25)


      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)


      visit "/merchant/coupons/#{coupon_1.id}/edit"

      expect(find_field('Name').value).to eq('25% weekend promo')
      expect(find_field('Code').value).to eq('WKD25')
      expect(find_field('Percent').value).to eq('0.25')


      name = ''
      code = ''
      percent = ''

      fill_in 'Name', with: name
      fill_in 'Code', with: code
      fill_in 'Percent', with: percent

      click_button 'Submit'

      expect(page).to have_content("Name can't be blank, Code can't be blank, and Percent is not a number")

      expect(find_field('Name').value).to eq(name)
      expect(find_field('Code').value).to eq(code)
      expect(find_field('Percent').value).to eq(percent)
      expect(page).to have_button('Submit')
    end

    it "I must enter a percentage greater than 0 and less than 1" do
      bike_shop = create(:merchant)
      merchant = create(:user, role: 1, merchant: bike_shop)
      coupon_1 = bike_shop.coupons.create(name: "25% weekend promo", code: "WKD25", percent: 0.25)
      coupon_2 = bike_shop.coupons.create(name: "50% labor day promo", code: "LABOR50", percent: 0.5)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

      visit "/merchant/coupons/#{coupon_1.id}/edit"

      expect(find_field('Name').value).to eq('25% weekend promo')
      expect(find_field('Code').value).to eq('WKD25')
      expect(find_field('Percent').value).to eq('0.25')

      name = '35% weekend promo'
      code = 'WKD30'
      percent = '1.01'

      fill_in 'Name', with: name
      fill_in 'Code', with: code
      fill_in 'Percent', with: percent

      click_button 'Submit'

      expect(page).to have_content("Percent must be less than or equal to 1")

      expect(find_field('Name').value).to eq(name)
      expect(find_field('Code').value).to eq(code)
      expect(find_field('Percent').value).to eq(percent)
      expect(page).to have_button('Submit')





      visit "/merchant/coupons/#{coupon_1.id}/edit"

      expect(find_field('Name').value).to eq('25% weekend promo')
      expect(find_field('Code').value).to eq('WKD25')
      expect(find_field('Percent').value).to eq('0.25')

      name = '35% weekend promo'
      code = 'WKD30'
      percent = '-.01'

      fill_in 'Name', with: name
      fill_in 'Code', with: code
      fill_in 'Percent', with: percent

      click_button 'Submit'

      expect(page).to have_content("Percent must be greater than 0")

      expect(find_field('Name').value).to eq(name)
      expect(find_field('Code').value).to eq(code)
      expect(find_field('Percent').value).to eq(percent)
      expect(page).to have_button('Submit')
    end
  end
end
