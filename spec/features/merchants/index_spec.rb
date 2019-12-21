require 'rails_helper'

RSpec.describe 'merchant index page', type: :feature do
  describe 'As a user' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
      @dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
    end

    it 'I can see a list of merchants in the system' do
      visit '/merchants'

      expect(page).to have_link("Brian's Bike Shop")
      expect(page).to have_link("Meg's Dog Shop")
    end

    it 'I can see a link to create a new merchant' do
      visit '/merchants'

      expect(page).to have_link("New Merchant")

      click_on "New Merchant"

      expect(current_path).to eq("/merchants/new")
    end
  end

  describe"As an admin" do
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
  end
end
