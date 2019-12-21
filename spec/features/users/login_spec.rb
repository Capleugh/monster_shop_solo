require 'rails_helper'

RSpec.describe 'Logging in', type: :feature do
  before :each do
    @user = create(:user, role: 0)
  end

  describe 'As a regular User' do
    it 'can login with valid credentials' do

      visit '/'

      click_link('Login')

      expect(current_path).to eq('/login')

      fill_in :email, with: @user.email
      fill_in :password, with: 'password'
      click_on('Submit')

      expect(current_path).to eq('/profile')
      expect(page).to have_content("Welcome back, #{@user.name} you are now logged in!")
      expect(page).to have_content("Hello, #{@user.name}!")
    end

    it "I cannot log in with invalid email and the flash message associated with this failure is intentionally vague" do

      visit '/login'

      fill_in :email, with: 'unregistered email'
      fill_in :password, with: 'password'
      click_on('Submit')

      expect(current_path).to eq('/login')
      expect(page).to have_link('Login')
      expect(page).to have_content('Sorry, your credentials are bad.')
      # is the conditional in the session controller appropriate?
    end

    it "I cannot log in with invalid password and the flash message associated with this failure is intentionally vague" do

      visit '/login'

      fill_in :email, with: @user.email
      fill_in :password, with: 'password1'
      click_on('Submit')

      expect(current_path).to eq('/login')
      expect(page).to have_link('Login')
      expect(page).to have_content('Sorry, your credentials are bad.')
    end


    describe "if I am already logged in and visit the login path" do
      it "I am redirected to my profile page" do

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

        visit '/login'

        expect(current_path).to eq('/profile')
        expect(page).to have_content("You are already logged in.")
        expect(page).to have_content("Hello, #{@user.name}!")
      end
    end
  end

  describe 'As a Merchant Employee User' do
    before :each do
      bike_shop = create(:merchant)
      @merchant_employee = create(:user, role: 1, merchant: bike_shop)
    end

    it 'can login with valid credentials' do

      visit '/'

      click_link('Login')

      expect(current_path).to eq('/login')

      fill_in :email, with: @merchant_employee.email
      fill_in :password, with: 'password'
      click_on('Submit')

      expect(current_path).to eq(merchant_path)
      expect(page).to have_content("Welcome back, #{@merchant_employee.name} you are now logged in!")
      expect(page).to have_content("Hello, #{@merchant_employee.name}! Welcome to your Merchant Dashboard!")
    end

    it "I cannot log in with invalid password and the flash message associated with this failure is intentionally vague" do

      visit '/login'

      fill_in :email, with: @merchant_employee.email
      fill_in :password, with: 'password1'
      click_on('Submit')

      expect(current_path).to eq('/login')
      expect(page).to have_link('Login')
      expect(page).to have_content('Sorry, your credentials are bad.')
    end

    describe "if I am already logged in and visit the login path" do
      it "I am redirected to my merchant dashboard page" do

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)

        visit '/login'

        expect(current_path).to eq(merchant_path)
        expect(page).to have_content("You are already logged in.")
        expect(page).to have_content("Hello, #{@merchant_employee.name}! Welcome to your Merchant Dashboard!")
      end
    end
  end

  describe 'As a Merchant Admin User' do
    before :each do
      bike_shop = create(:merchant)
      @merchant_admin = create(:user, role: 2, merchant: bike_shop)
    end

    it 'can login with valid credentials' do

      visit '/'

      click_link('Login')

      expect(current_path).to eq('/login')

      fill_in :email, with: @merchant_admin.email
      fill_in :password, with: 'password'
      click_on('Submit')

      expect(current_path).to eq(merchant_path)
      expect(page).to have_content("Welcome back, #{@merchant_admin.name} you are now logged in!")
      expect(page).to have_content("Hello, #{@merchant_admin.name}! Welcome to your Merchant Dashboard!")
    end

    it "I cannot log in with invalid password and the flash message associated with this failure is intentionally vague" do

      visit '/login'

      fill_in :email, with: @merchant_admin.email
      fill_in :password, with: 'password1'
      click_on('Submit')

      expect(current_path).to eq('/login')
      expect(page).to have_link('Login')
      expect(page).to have_content('Sorry, your credentials are bad.')
    end

    describe "if I am already logged in and visit the login path" do
      it "I am redirected to my merchant dashboard page" do

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_admin)

        visit '/login'
        

        expect(current_path).to eq(merchant_path)
        expect(page).to have_content("You are already logged in.")
        expect(page).to have_content("Hello, #{@merchant_admin.name}! Welcome to your Merchant Dashboard!")
      end
    end
  end

  describe 'As an Admin User' do
    before :each do
      @admin = create(:user, role: 3)
    end

    it 'can login with valid credentials' do

      visit '/'

      click_link('Login')

      expect(current_path).to eq('/login')

      fill_in :email, with: @admin.email
      fill_in :password, with: 'password'
      click_on('Submit')

      expect(current_path).to eq(admin_path)
      expect(page).to have_content("Welcome back, #{@admin.name} you are now logged in!")
      expect(page).to have_content("Hello, #{@admin.name}! Welcome to your Admin Dashboard!")
    end

    it "I cannot log in with invalid password and the flash message associated with this failure is intentionally vague" do

      visit '/login'

      fill_in :email, with: @admin.email
      fill_in :password, with: 'password1'
      click_on('Submit')

      expect(current_path).to eq('/login')
      expect(page).to have_link('Login')
      expect(page).to have_content('Sorry, your credentials are bad.')
    end

    describe "if I am already logged in and visit the login path" do
      it "I am redirected to my admin dashboard page" do

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

        visit '/login'

        expect(current_path).to eq(admin_path)
        expect(page).to have_content("You are already logged in.")
        expect(page).to have_content("Hello, #{@admin.name}! Welcome to your Admin Dashboard!")
      end
    end
  end
end
