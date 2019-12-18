
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')
    end

    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

    end

    it 'can navigate through the navbar and cart increments' do
      merchant = Merchant.create!(name: 'merchant', address: 'merchant_address', city: 'merchant_city', state: 'merchant_state', zip: 12345)
      item = merchant.items.create!(name: 'item', description: 'description', price: 10, image: 'https://upload.wikimedia.org/wikipedia/commons/0/06/Item_Industrietechnik_und_Maschinenbau_logo.svg', inventory: 20, merchant_id: merchant.id)

      visit '/'
      click_on 'Home'
      expect(current_path).to eq('/')
      click_on 'All Items'
      expect(current_path).to eq('/items')
      click_on 'All Merchants'
      expect(current_path).to eq('/merchants')
      click_on 'Cart:'
      expect(current_path).to eq('/cart')
      click_on 'Login'
      expect(current_path).to eq('/login')
      click_on 'Register'
      expect(current_path).to eq('/users/register')

      click_on 'All Items'
      click_on 'item'
      click_on 'Add To Cart'
      click_on 'item'
      click_on 'Add To Cart'

      expect(page).to have_content('Cart: 2')
    end
  end

  describe 'As a Regular User' do
    it 'I see visitor links, a /profile and /logout link. No register and login link, as well as my name' do
      user = User.create(name: 'user', address: 'address', city: 'city', state: 'state', zip: 12345, email: 'user', password: 'p')

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit '/'

      within '.topnav' do
        expect(page).to have_link('My Profile')
        click_on('My Profile')
        expect(current_path).to eq("/profile")

        expect(page).to have_link('Log Out')
        click_on('Log Out')
        expect(current_path).to eq('/')

        expect(page).to have_link('Home')
        click_on('Home')
        expect(current_path).to eq('/')

        expect(page).to have_link('All Merchants')
        click_on('All Merchants')
        expect(current_path).to eq('/merchants')

        expect(page).to have_link('All Items')
        click_on('All Items')
        expect(current_path).to eq('/items')

        expect(page).to have_link('Cart:')
        click_on('Cart:')
        expect(current_path).to eq('/cart')

        expect(page).to_not have_link('Register')
        expect(page).to_not have_link('Login')
      end
      expect(page).to have_content("Logged in as #{user.name}")
    end
  end
end
