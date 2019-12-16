require 'rails_helper'

RSpec.describe "User registration form" do
  it "creates a new user when all fields are complete and passwords match" do
    visit '/'

    within(:css, 'nav') do
      click_on "Register"
    end

    expect(current_path).to eq('/users/register')

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

    expect(page).to have_content("Welcome Alison Vermeil, you are now registered and logged in.")

    user = User.last

    expect(user.name).to eq("Alison Vermeil")
    expect(user.address).to eq("123 Main St")
    expect(user.city).to eq("Denver")
    expect(user.state).to eq("CO")
    expect(user.zip).to eq(80516)
    expect(user.email).to eq("alison123@gmail.com")
  end

  it "does not create a new user when all fields are complete and passwords do not match" do
    visit '/'

    within ".topnav" do
      click_on "Register"
    end

    expect(current_path).to eq('/users/register')

    fill_in :name, with: "Alison Vermeil"
    fill_in :address, with: "123 Main St"
    fill_in :city, with: "Denver"
    fill_in :state, with: "CO"
    fill_in :zip, with: 80516
    fill_in :email, with: "alison123@gmail.com"
    fill_in :password, with: "password123"
    fill_in :password_confirmation, with: "sadface"

    click_button "Create User"

    expect(page).to have_content("Password confirmation doesn't match Password")
    expect(page).to have_button("Create User")
    expect(page).to_not have_content("Welcome Alison Vermeil, you are now registered and logged in.")
  end

  it "keeps a user logged in after registering" do
    visit '/'

    within(:css, 'nav') do
      click_on "Register"
    end

    expect(current_path).to eq('/users/register')

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

    expect(page).to have_content("Hello, Alison Vermeil!")
  end
end