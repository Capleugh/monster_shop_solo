require 'rails_helper'

RSpec.describe 'As an Admin', type: :feature do
  before(:each) do
    bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

    @user_1 = User.create(name: 'user', address: 'user_address', city: 'user_city', state: 'user_state', zip: 12345, email: 'user_email', password: 'p', password_confirmation: 'p', role: 0)
    @user_2 = User.create(name: 'user', address: 'user_address', city: 'user_city', state: 'user_state', zip: 12345, email: 'user_2_email', password: 'p', password_confirmation: 'p', role: 0)

    @merchant_employee_1 = User.create(name: 'merchant_employee', address: 'merchant_employee_address', city: 'merchant_employee_city', state: 'merchant_employee_state', zip: 12345, email: 'merchant_employee_email', password: 'p', password_confirmation: 'p', role: 1, merchant: bike_shop)
    @merchant_employee_2 = User.create(name: 'merchant_employee_2', address: 'merchant_employee_address', city: 'merchant_employee_city', state: 'merchant_employee_state', zip: 12345, email: 'merchant_employee_email_2', password: 'p', password_confirmation: 'p', role: 1, merchant: dog_shop)

    @admin = User.create(name: 'admin', address: 'admin_address', city: 'admin_city', state: 'admin_state', zip: 12345, email: 'admin_email', password: 'p', password_confirmation: 'p', role: 3)

    email = @admin.email
    password = @admin.password

    visit('/')
    fill_in :email, with: email
    fill_in :password, with: password
    click_on('Submit')
    visit('/admin/users')
    save_and_open_page
  end

  it 'visit /admin/users you can see all user names which is a link to their page, date registered, and user type ' do
    
  end

#   User Story 53, Admin User Index Page
# As an admin user
# When I click the "Users" link in the nav (only visible to admins)
# Then my current URI route is "/admin/users"
# Only admin users can reach this path.
# I see all users in the system
# Each user's name is a link to a show page for that user ("/admin/users/5")
# Next to each user's name is the date they registered
# Next to each user's name I see what type of user they are
end
