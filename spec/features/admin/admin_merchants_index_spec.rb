require 'rails_helper'

RSpec.describe "As an admin" do
  describe "when I visit the merchant index page" do
    it "when I click on a merchant's name, my URI path should be '/admin/merchants/id' and I will be able to see everything that a merchant can see" do
      admin = User.create(name: 'admin', address: 'admin address', city: 'admin city', state: 'admin state', zip: 12345, email: 'admin_email', password: 'p', role: 3)
      bike_shop = create(:merchant)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit admin_merchants_path
      expect(current_path).to eq(admin_merchants_path)

      click_link "#{bike_shop.name}"

      expect(current_path).to eq("/admin/merchants/#{bike_shop.id}")
      expect(page).to have_content(bike_shop.name)
      expect(page).to have_content(bike_shop.address)
      expect(page).to have_content(bike_shop.city)
      expect(page).to have_content(bike_shop.state)
      expect(page).to have_content(bike_shop.zip)
      expect(page).to have_link("All #{bike_shop.name} Items" )
      expect(page).to have_link("Update Merchant")
      expect(page).to have_link("Delete Merchant")
    end

    it "I see a 'disable' button next to any merchants who are not yet disabled and when I click that button, I see a flash message that the merchant's account is now disabled" do
      admin = User.create(name: 'admin', address: 'admin address', city: 'admin city', state: 'admin state', zip: 12345, email: 'admin_email', password: 'p', role: 3)
      bike_shop = create(:merchant)
      mike_shop = create(:merchant)
      meg_shop = create(:merchant, enabled?: false)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit admin_merchants_path

      within "#merchant-#{meg_shop.id}" do
        expect(page).to_not have_button("Disable")
      end

      within "#merchant-#{bike_shop.id}" do
        click_button "Disable"
        expect(current_path).to eq(admin_merchants_path)
      end

      expect(page).to have_content("#{bike_shop.name} is now disabled.")

      within "#merchant-#{mike_shop.id}" do
        click_button "Disable"
        expect(current_path).to eq(admin_merchants_path)
      end

      expect(page).to have_content("#{mike_shop.name} is now disabled.")
    end
  end
end
