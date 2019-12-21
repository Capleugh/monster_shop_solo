
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
      user = User.create(name: 'user', address: 'address', city: 'city', state: 'state', zip: 12345, email: 'user', password: 'p', role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit '/'

      within '.topnav' do
        click_on('My Profile')
        expect(current_path).to eq("/profile")

        click_on('Log Out')
        expect(current_path).to eq('/')

        click_on('Home')
        expect(current_path).to eq('/')

        click_on('All Merchants')
        expect(current_path).to eq('/merchants')

        click_on('All Items')
        expect(current_path).to eq('/items')

        click_on('Cart:')
        expect(current_path).to eq('/cart')

        expect(page).to_not have_link('Register')
        expect(page).to_not have_link('Login')

        expect(page).to have_content("Logged in as #{user.name}")
      end
    end

  describe "As a merchant" do
    it 'I see user links and  a link to merchant dashboard at /merchant' do
      bike_shop = create(:merchant)
      merchant_employee = User.create(name: 'user', address: 'address', city: 'city', state: 'state', zip: 12345, email: 'user', password: 'p', role: 1, merchant: bike_shop)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)

      visit '/'

      within '.topnav' do
        click_on('My Profile')
        expect(current_path).to eq("/profile")

        click_on('Log Out')
        expect(current_path).to eq('/')

        click_on('Home')
        expect(current_path).to eq('/')

        click_on('All Merchants')
        expect(current_path).to eq('/merchants')

        click_on('All Items')
        expect(current_path).to eq('/items')

        click_on('Cart:')
        expect(current_path).to eq('/cart')

        click_on('Merchant Dashboard')
        expect(current_path).to eq(merchant_path)

        expect(page).to_not have_link('Register')
        expect(page).to_not have_link('Login')

        expect(page).to have_content("Logged in as #{merchant_employee.name}")
      end
    end
  end

    it 'merchant admin see user links and  a link to merchant dashboard at /merchant' do
      bike_shop = create(:merchant)
      merchant_admin = User.create(name: 'user', address: 'address', city: 'city', state: 'state', zip: 12345, email: 'user', password: 'p', role: 1, merchant: bike_shop)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

      visit '/'

      within '.topnav' do
        click_on('My Profile')
        expect(current_path).to eq("/profile")

        click_on('Log Out')
        expect(current_path).to eq('/')

        click_on('Home')
        expect(current_path).to eq('/')

        click_on('All Merchants')
        expect(current_path).to eq('/merchants')

        click_on('All Items')
        expect(current_path).to eq('/items')

        click_on('Cart:')
        expect(current_path).to eq('/cart')

        click_on('Merchant Dashboard')
        expect(current_path).to eq(merchant_path)

        expect(page).to_not have_link('Register')
        expect(page).to_not have_link('Login')

        expect(page).to have_content("Logged in as #{merchant_admin.name}")
      end
    end

    describe "as an admin" do
      it 'I see user links, link to admin dashboard and link to see all users. No link to cart.' do
        admin = User.create(name: 'user', address: 'address', city: 'city', state: 'state', zip: 12345, email: 'user', password: 'p', role: 3)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

        visit '/'

        within '.topnav' do
          click_on('My Profile')
          expect(current_path).to eq("/profile")

          click_on('Log Out')
          expect(current_path).to eq('/')

          click_on('Home')
          expect(current_path).to eq('/')

          click_on('All Merchants')
          expect(current_path).to eq('/admin/merchants')

          click_on('All Items')
          expect(current_path).to eq('/items')

          click_on('Admin Dashboard')
          expect(current_path).to eq(admin_path)

          click_on('All Users')
          expect(current_path).to eq('/admin/users')

          expect(page).to_not have_link('Register')
          expect(page).to_not have_link('Login')
          expect(page).to_not have_link('Cart:')

          expect(page).to have_content("Logged in as #{admin.name}")
        end
      end
    end

    describe "As a visitor" do
      it "when I try to access any path that begins with /merchant, /admin, or /profile as a visitor, I see a 404 error" do

        visit(merchant_path)
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit(admin_path)
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit('/profile')
        expect(page).to have_content("The page you were looking for doesn't exist.")
      end
    end

    describe 'As a Regular User' do
      it 'when I try to access any path that begins with /merchant or /admin, I see a 404 error' do

        user = User.create(name: 'user', address: 'address', city: 'city', state: 'state', zip: 12345, email: 'user', password: 'p', role: 0)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

        visit(merchant_path)
        expect(page).to have_content("The page you were looking for doesn't exist.")

        visit(admin_path)
        expect(page).to have_content("The page you were looking for doesn't exist.")
      end
    end

    describe 'As a Merchant Employee User' do
      it 'when I try to access any path that begins with /merchant or /admin, I see a 404 error' do

        merchant_employee = User.create(name: 'user', address: 'address', city: 'city', state: 'state', zip: 12345, email: 'user', password: 'p', role: 1)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)

        visit(admin_path)
        expect(page).to have_content("The page you were looking for doesn't exist.")
      end
    end

    describe 'As a Merchant Admin User' do
      it 'when I try to access any path that begins with /merchant or /admin, I see a 404 error' do

        merchant_admin = User.create(name: 'user', address: 'address', city: 'city', state: 'state', zip: 12345, email: 'user', password: 'p', role: 2)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

        visit(admin_path)
        expect(page).to have_content("The page you were looking for doesn't exist.")
      end

      describe "As an Admin User" do
        it 'does not allow an Admin User to navigate to any path that begins with /cart or /merchant' do
          admin = User.create(name: 'admin', address: 'admin address', city: 'admin city', state: 'admin state', zip: 12345, email: 'admin_email', password: 'p', role: 3)

          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

          visit '/cart'
          expect(page).to have_content("The page you were looking for doesn't exist.")

          visit(merchant_path)
          expect(page).to have_content("The page you were looking for doesn't exist.")
        end
      end
    end
  end
end
