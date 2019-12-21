require 'rails_helper'

RSpec.describe "As a merchant employee or merchant admin" do
  describe "when I visit my merchant dashboard" do
    it "I see the name and full address of the merchant I work for" do
      bike_shop = create(:merchant)
      merchant_employee = create(:user, role: 1, merchant: bike_shop)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)

      visit merchant_path
      # save_and_open_page
      expect(page).to have_content(bike_shop.name)
      expect(page).to have_content(bike_shop.address)
      expect(page).to have_content(bike_shop.city)
      expect(page).to have_content(bike_shop.state)
      expect(page).to have_content(bike_shop.zip)
    end
  end

  it "I see the name and full address of the merchant I work for" do
    bike_shop = create(:merchant)
    merchant_admin = create(:user, role: 2, merchant: bike_shop)


    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

    visit merchant_path

    expect(page).to have_content(bike_shop.name)
    expect(page).to have_content(bike_shop.address)
    expect(page).to have_content(bike_shop.city)
    expect(page).to have_content(bike_shop.state)
    expect(page).to have_content(bike_shop.zip)
  end

  it "I see a link to view my own items and when I click that link, my URI route should be '/merchant/items'" do

  end
end
