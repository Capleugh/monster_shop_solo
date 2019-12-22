require 'rails_helper'

RSpec.describe "As a user" do
  describe "on my profile page" do
    it "I see all my info except my password and a link to edit my info" do
      user = create(:user, role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit(profile_path)

      expect(page).to have_content("Name: #{user.name}")
      expect(page).to have_content("Address: #{user.address}")
      expect(page).to have_content("City: #{user.city}")
      expect(page).to have_content("State: #{user.state}")
      expect(page).to have_content("Zip: #{user.zip}")
      expect(page).to have_content("Email: #{user.email}")
      expect(page).to_not have_content(user.password)

      click_on 'Edit My Info'
    end
  end
end
