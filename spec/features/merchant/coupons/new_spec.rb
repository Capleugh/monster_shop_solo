require 'rails_helper'

RSpec.describe "As a merchant employee or admin"  do
  it "when I click 'Add Coupon' button, I am taken to a form where I can fill in a new coupon's name, code, and percentage" do
    bike_shop = create(:merchant)
    merchant_employee = create(:user, role: 1, merchant: bike_shop)
    coupon_1 = bike_shop.coupons.create(name: "25% weekend promo", code: "WKD25", percent: 0.25)
    coupon_2 = bike_shop.coupons.create(name: "50% labor day promo", code: "LABOR50", percent: 0.5)
    name = "Amaze wow 5% off"
    code = "AMAZE5"
    percent = 0.05

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)

    visit merchant_coupons_path

    click_link "Add Coupon"

    expect(current_path).to eq(new_merchant_coupon_path)

    fill_in 'Name', with: name
    fill_in 'Code', with: code
    fill_in 'Percent', with: percent

    click_button "Submit"

    new_coupon = Coupon.last

    expect(current_path).to eq("/merchant/coupons")
    expect(page).to have_content("Coupon has been added!")
    expect(new_coupon.name).to eq(name)
    expect(new_coupon.code).to eq(code)
    expect(new_coupon.percent).to eq(percent)
  end

  it "when I click 'Add Coupon' button, I am taken to a form where I can fill in a new coupon's name, code, and percentage" do
    bike_shop = create(:merchant)
    merchant_admin = create(:user, role: 2, merchant: bike_shop)
    coupon_1 = bike_shop.coupons.create(name: "25% weekend promo", code: "WKD25", percent: 0.25)
    coupon_2 = bike_shop.coupons.create(name: "50% labor day promo", code: "LABOR50", percent: 0.5)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

    visit merchant_coupons_path

    click_link "Add Coupon"

    expect(current_path).to eq(new_merchant_coupon_path)

    name = "Amaze wow 5% off"
    code = "AMAZE5"
    percent = 0.05

    fill_in 'Name', with: name
    fill_in 'Code', with: code
    fill_in 'Percent', with: percent

    click_button "Submit"

    new_coupon = Coupon.last

    expect(current_path).to eq("/merchant/coupons")
    expect(page).to have_content("Coupon has been added!")
    expect(new_coupon.name).to eq(name)
    expect(new_coupon.code).to eq(code)
    expect(new_coupon.percent).to eq(percent)
  end

  it "when I leave the entire form blank, I receive a lengthy error flash message and the form is rendered again" do
    bike_shop = create(:merchant)
    merchant_admin = create(:user, role: 2, merchant: bike_shop)
    coupon_1 = bike_shop.coupons.create(name: "25% weekend promo", code: "WKD25", percent: 0.25)
    coupon_2 = bike_shop.coupons.create(name: "50% labor day promo", code: "LABOR50", percent: 0.5)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

    visit merchant_coupons_path

    click_link "Add Coupon"

    expect(current_path).to eq(new_merchant_coupon_path)

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

  it "when I enter a name and code which have already been taken, I receive an error telling me as much" do
    bike_shop = create(:merchant)
    merchant_admin = create(:user, role: 2, merchant: bike_shop)
    coupon_1 = bike_shop.coupons.create(name: "25% weekend promo", code: "WKD25", percent: 0.25)
    coupon_2 = bike_shop.coupons.create(name: "50% labor day promo", code: "LABOR50", percent: 0.5)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

    visit merchant_coupons_path

    click_link "Add Coupon"

    expect(current_path).to eq(new_merchant_coupon_path)

    name = '25% weekend promo'
    code = 'WKD25'
    percent = '.25'

    fill_in 'Name', with: name
    fill_in 'Code', with: code
    fill_in 'Percent', with: percent

    click_button 'Submit'

    expect(page).to have_content("Name has already been taken and Code has already been taken")

    expect(find_field('Name').value).to eq(name)
    expect(find_field('Code').value).to eq(code)
    expect(find_field('Percent').value).to eq(percent)
    expect(page).to have_button('Submit')
  end

  it "I must enter a percentage greater than 0 and less than 1" do
    bike_shop = create(:merchant)
    merchant_admin = create(:user, role: 2, merchant: bike_shop)
    coupon_1 = bike_shop.coupons.create(name: "25% weekend promo", code: "WKD25", percent: 0.25)
    coupon_2 = bike_shop.coupons.create(name: "50% labor day promo", code: "LABOR50", percent: 0.5)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

    visit merchant_coupons_path

    click_link "Add Coupon"

    expect(current_path).to eq(new_merchant_coupon_path)

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





    visit merchant_coupons_path

    click_link "Add Coupon"

    expect(current_path).to eq(new_merchant_coupon_path)

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
