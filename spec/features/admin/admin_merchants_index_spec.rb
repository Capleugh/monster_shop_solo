require 'rails_helper'

RSpec.describe "As an admin" do
  describe "when I visit the merchant index page" do
    it "when I click on a merchant's name, my URI path should be '/admin/merchants/id' and I will be able to see everything that a merchant can see" do
      admin = User.create(name: 'admin', address: 'admin address', city: 'admin city', state: 'admin state', zip: 12345, email: 'admin_email', password: 'p', role: 3)
      bike_shop = create(:merchant)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit admin_merchants_path
      expect(current_path).to eq(admin_merchants_path)

      click_link "#{bike_shop.name}"

      expect(current_path).to eq("/admin/merchants/#{bike_shop.id}")
      expect(page).to have_content(bike_shop.name)
      expect(page).to have_content(bike_shop.address)
      expect(page).to have_content(bike_shop.city)
      expect(page).to have_content(bike_shop.state)
      expect(page).to have_content(bike_shop.zip)
      expect(page).to have_link("All #{bike_shop.name} Items" )
      expect(page).to have_link("Update Merchant")
      expect(page).to have_link("Delete Merchant")
    end

    it "I see a 'disable' button next to any merchants who are not yet disabled and when I click that button, I see a flash message that the merchant's account is now disabled" do
      admin = User.create(name: 'admin', address: 'admin address', city: 'admin city', state: 'admin state', zip: 12345, email: 'admin_email', password: 'p', role: 3)
      meg_shop = create(:merchant, enabled?: false)
      bike_shop = create(:merchant)
      mike_shop = create(:merchant)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit admin_merchants_path

      within "#merchant-#{meg_shop.id}" do
        expect(page).to_not have_button("Disable")
      end

      within "#merchant-#{bike_shop.id}" do
        click_button "Disable"
      end

      expect(current_path).to eq(admin_merchants_path)
      expect(page).to have_content("#{bike_shop.name} is now disabled.")

      within "#merchant-#{bike_shop.id}" do
        expect(page).to_not have_button("Disable")
      end

      within "#merchant-#{mike_shop.id}" do
        click_button "Disable"
      end

      expect(current_path).to eq(admin_merchants_path)
      expect(page).to have_content("#{mike_shop.name} is now disabled.")

      within "#merchant-#{mike_shop.id}" do
        expect(page).to_not have_button("Disable")
      end
    end

    it "when I click on the 'disable' button, all of that merchant's items should be deactivated" do
      admin = User.create(name: 'admin', address: 'admin address', city: 'admin city', state: 'admin state', zip: 12345, email: 'admin_email', password: 'p', role: 3)
      meg_shop = create(:merchant)

      item_1 = create(:item, merchant: meg_shop)
      item_2 = create(:item, merchant: meg_shop)


      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)



      visit "/admin/merchants/#{meg_shop.id}/items"

      within "#item-#{item_1.id}" do
        expect(page).to have_content("Active")
      end

      within "#item-#{item_2.id}" do
        expect(page).to have_content("Active")
      end


      visit admin_merchants_path

      within "#merchant-#{meg_shop.id}" do
        click_button "Disable"
      end

      expect(current_path).to eq(admin_merchants_path)


      visit "/admin/merchants/#{meg_shop.id}/items"

      within "#item-#{item_1.id}" do
        expect(page).to have_content("Inactive")
      end

      within "#item-#{item_2.id}" do
        expect(page).to have_content("Inactive")
      end
    end

    it "when I click the 'Enable' button next to any merchants whose accounts are disabled, I see that the merchant's account is enabled accompanied by a flash message that says as much" do
      admin = User.create(name: 'admin', address: 'admin address', city: 'admin city', state: 'admin state', zip: 12345, email: 'admin_email', password: 'p', role: 3)
      mike_shop = create(:merchant)
      meg_shop = create(:merchant, enabled?: false)
      bike_shop = create(:merchant, enabled?: false)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit admin_merchants_path

      within "#merchant-#{mike_shop.id}" do
        expect(page).to_not have_button("Enable")
      end

      within "#merchant-#{meg_shop.id}" do
        expect(page).to_not have_button("Disable")

        click_button "Enable"
      end

      expect(current_path).to eq(admin_merchants_path)
      expect(page).to have_content("#{meg_shop.name} is now enabled.")

      within "#merchant-#{meg_shop.id}" do
        expect(page).to_not have_button("Enable")
      end


      within "#merchant-#{bike_shop.id}" do
        expect(page).to_not have_button("Disable")

        click_button "Enable"
      end

      expect(current_path).to eq(admin_merchants_path)
      expect(page).to have_content("#{bike_shop.name} is now enabled.")

      within "#merchant-#{bike_shop.id}" do
        expect(page).to_not have_button("Enable")
      end
    end

    it "when I click the 'Enable' button next to a merchant, all of that merchant's items are activated" do
      admin = User.create(name: 'admin', address: 'admin address', city: 'admin city', state: 'admin state', zip: 12345, email: 'admin_email', password: 'p', role: 3)
      meg_shop = create(:merchant, enabled?: false)

      item_1 = create(:item, active?: false, merchant: meg_shop)
      item_2 = create(:item, active?: false, merchant: meg_shop)


      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)


      visit "/admin/merchants/#{meg_shop.id}/items"

      within "#item-#{item_1.id}" do
        expect(page).to have_content("Inactive")
      end

      within "#item-#{item_2.id}" do
        expect(page).to have_content("Inactive")
      end

      visit admin_merchants_path

      within "#merchant-#{meg_shop.id}" do
        click_button "Enable"
      end

      expect(current_path).to eq(admin_merchants_path)

      visit "/admin/merchants/#{meg_shop.id}/items"

      within "#item-#{item_1.id}" do
        expect(page).to have_content("Active")
      end

      within "#item-#{item_2.id}" do
        expect(page).to have_content("Active")
      end
    end
  end
end
