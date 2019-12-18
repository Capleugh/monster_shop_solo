require 'rails_helper'

RSpec.describe "As a registered user" do
  describe "I can edit my information" do
    it "by filling out a form with my changes" do
      user = create(:user, role: 0)

      original_address = "1 Lane"
      original_city = "Den 1"
      original_state = "CO 1"

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit '/profile'

      expect(page).to have_content("Name: #{user.name}")
      expect(page).to have_content("Address: #{original_address}")
      expect(page).to have_content("City: #{original_city}")
      expect(page).to have_content("State: #{original_state}")
      expect(page).to have_content("Zip: #{user.zip}")
      expect(page).to have_content("Email: #{user.email}")

      click_link 'Edit My Info'

      expect(current_path).to eq('/profile/edit')

      expect(find_field('Name').value).to eq(user.name)
      expect(find_field('Address').value).to eq(user.address)
      expect(find_field('City').value).to eq(user.city)
      expect(find_field('State').value).to eq(user.state)
      expect(find_field('Zip').value).to eq(user.zip)
      expect(find_field('Email').value).to eq(user.email)
      
      new_address = "456 South St"
      new_city = "Boulder"
      new_state = "AZ"

      fill_in :address, with: new_address
      fill_in :city, with: new_city
      fill_in :state, with: new_state

      click_button 'Submit'

      expect(current_path).to eq(profile_path)

      expect(page).to have_content("Your information has been updated.")

      expect(page).to have_content("Name: #{user.name}")
      expect(page).to have_content("Address: #{new_address}")
      expect(page).to have_content("City: #{new_city}")
      expect(page).to have_content("State: #{new_state}")
      expect(page).to have_content("Zip: #{user.zip}")
      expect(page).to have_content("Email: #{user.email}")

      expect(page).to_not have_content(original_address)
      expect(page).to_not have_content(original_city)
      expect(page).to_not have_content(original_state)
    end
  end
end
