require 'rails_helper'

RSpec.describe 'As an Admin', type: :feature do
  before(:each) do
    @admin = User.create(name: 'admin', address: 'admin_address', city: 'admin_city', state: 'admin_state', zip: 12345, email: 'admin_email', password: 'p', password_confirmation: 'p', role: 3)
    @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210, enabled?: false)

    visit('/')
    click_on('Login')
    email = @admin.email
    password = @admin.password
    fill_in :email, with: email
    fill_in :password, with: password
    click_on('Submit')
  end

  it 'On /admin/merchants I see all merchants names as links, their city, state, and enable and disabled buttons' do
    visit('/admin/merchants')

    within "#merchant-#{@bike_shop.id}" do
      expect(page).to have_link(@bike_shop.name)
      expect(page).to have_content(@bike_shop.city)
      expect(page).to have_content(@bike_shop.state)
      expect(page).to have_button('Disable')
    end

    within "#merchant-#{@dog_shop.id}" do
      expect(page).to have_link(@dog_shop.name)
      expect(page).to have_content(@dog_shop.city)
      expect(page).to have_content(@dog_shop.state)
      expect(page).to have_button('Enable')
    end
  end
end
