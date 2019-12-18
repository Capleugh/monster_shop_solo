require 'rails_helper'

RSpec.describe 'Log Out', type: :feature do
  describe 'As a regular User' do
    it 'can login with valid credentials' do
      mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
      user = create(:user, role: 0)
      
      visit '/'
      click_link('Login')
      fill_in :email, with: user.email
      fill_in :password, with: "password#{user.name.split.last.to_i}"
      click_on('Submit')
      expect(current_path).to eq('/profile')
      expect(page).to have_content("Welcome back, #{user.name} you are now logged in!")
      expect(page).to have_content("Hello, #{user.name}!")
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
