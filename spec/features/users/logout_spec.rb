require 'rails_helper'

RSpec.describe 'Logging in', type: :feature do
  describe 'As a regular User' do
    it 'can login with valid credentials' do
      mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
      user_1 = create(:user, role: 0)

      visit '/'
      click_link('Login')
      fill_in :email, with: user_1.email
      fill_in :password, with: 'password1'
      click_on('Submit')
      visit "/items/#{paper.id}"
      click_on "Add To Cart"
      expect(page).to have_content("Cart: 1")

      within 'nav' do
        click_on('Log Out')
      end
      expect(current_path).to eq('/')
      expect(page).to have_content("Goodbye, you are now logged out.")
      expect(page).to have_content("Cart: 0")
    end
  end
end
