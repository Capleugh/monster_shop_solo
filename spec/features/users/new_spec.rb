require 'rails_helper'

RSpec.describe "User registration form" do
  it "creates a new user" do
    visit '/'

    within(:css, 'nav') do
      click_on "Register"
    end

    expect(current_path).to eq('/register')

    fill_in :name, with: "Alison Vermeil"
    fill_in :address, with: "123 Main St"
    fill_in :city, with: "Denver"
    fill_in :state, with: "CO"
    fill_in :zip, with: 80516
    fill_in :email, with: "alison123@gmail.com"
    fill_in :password, with: "password123"
    fill_in :password_confirmation, with: "password123"

    click_button "Create User"

    expect(current_path).to eq('/profile')

    expect(page).to have_content("You are now registered and logged in.")
  end
end
