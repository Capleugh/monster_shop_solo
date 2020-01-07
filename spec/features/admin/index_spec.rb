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
    # @bike_shop.toggle :enabled?
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
#   User Story 52, Admin Merchant Index Page
# As an admin user
# When I visit the merchant's index page at "/admin/merchants"
# I see all merchants in the system
# Next to each merchant's name I see their city and state
# The merchant's name is a link to their Merchant Dashboard at routes such as "/admin/merchants/5"
# I see a "disable" button next to any merchants who are not yet disabled
# I see an "enable" button next to any merchants whose accounts are disabled
end
