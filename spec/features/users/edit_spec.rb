require 'rails_helper'

RSpec.describe "As a registered user" do
  describe "I can edit my information" do
    before :each do
      @user = create(:user, role: 0)

      @original_address = "1 Lane"
      @original_city = "Den 1"
      @original_state = "CO 1"

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it "by filling out a form with my changes" do

      visit '/profile'

      expect(page).to have_content("Name: #{@user.name}")
      expect(page).to have_content("Address: #{@user.address}")
      expect(page).to have_content("City: #{@user.city}")
      expect(page).to have_content("State: #{@user.state}")
      expect(page).to have_content("Zip: #{@user.zip}")
      expect(page).to have_content("Email: #{@user.email}")

      click_link 'Edit My Info'

      expect(current_path).to eq('/profile/edit')

      expect(find_field('Name').value).to eq(@user.name)
      expect(find_field('Address').value).to eq(@user.address)
      expect(find_field('City').value).to eq(@user.city)
      expect(find_field('State').value).to eq(@user.state)
      expect(find_field('Zip').value).to eq(@user.zip.to_s)
      expect(find_field('Email').value).to eq(@user.email)
      expect(find_field('Password').value).to eq(nil)

      new_address = "456 South St"
      new_city = "Boulder"
      new_state = "AZ"

      fill_in :address, with: new_address
      fill_in :city, with: new_city
      fill_in :state, with: new_state
      fill_in :password, with: "password"

      click_button 'Submit'

      expect(current_path).to eq(profile_path)

      expect(page).to have_content("Your information has been updated.")

      expect(page).to have_content("Name: #{@user.name}")
      expect(page).to have_content("Address: #{new_address}")
      expect(page).to have_content("City: #{new_city}")
      expect(page).to have_content("State: #{new_state}")
      expect(page).to have_content("Zip: #{@user.zip.to_s}")
      expect(page).to have_content("Email: #{@user.email}")

      expect(page).to_not have_content(@original_address)
      expect(page).to_not have_content(@original_city)
      expect(page).to_not have_content(@original_state)
    end

    it "displays an error message if I fail to enter the correct password" do
      visit '/profile'

      click_link 'Edit My Info'

      new_address = "456 South St"
      new_city = "Boulder"
      new_state = "AZ"

      fill_in :address, with: new_address
      fill_in :city, with: new_city
      fill_in :state, with: new_state
      fill_in :password, with: "notmypassword"

      click_button('Submit')

      expect(page).to have_button('Submit')

      expect(page).to have_content("Password is incorrect. Please try again.")
    end

    it "displays an error message if I fail to fill out all fields" do

      visit '/profile'

      click_link 'Edit My Info'

      fill_in :address, with: nil
      fill_in :password, with: "password"

      click_button 'Submit'

      expect(page).to have_button('Submit')

      expect(page).to have_content("Address can't be blank.")
    end

    it "it displays an error message if I change my email to one that is already in use" do
      user_2 = create(:user, role: 1)

      visit profile_path

      click_link 'Edit My Info'

      fill_in :email, with: user_2.email
      fill_in :password, with: "password"
      click_button 'Submit'

      expect(page).to have_button('Submit')
      expect(page).to have_content("Email has already been taken.")
    end
  end

  describe "I can edit my password" do
    before :each do
      @user = create(:user, role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it "by filling out the edit password form correctly" do

      visit profile_path

      click_link "Edit My Password"

      expect(current_path).to eq('/profile/edit')

      fill_in :password, with: "newpassword"
      fill_in :password_confirmation, with: "newpassword"

      click_button 'Submit'

      expect(current_path). to eq(profile_path)
      expect(page).to have_content("Your password has been updated.")
    end

    it "displays an error message if my new password and new password confirmation do not match" do
      visit profile_path

      click_link "Edit My Password"

      expect(current_path).to eq('/profile/edit')

      fill_in :password, with: "newpassword"
      fill_in :password_confirmation, with: "notthesamepassword"

      click_button 'Submit'

      expect(page).to have_button('Submit')
      expect(page).to have_content('Passwords do not match. Please try again.')
    end
  end
end
