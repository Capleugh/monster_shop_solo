require 'rails_helper'

RSpec.describe "As an admin" do
  it "when I click on the 'disable' button, all of that merchant's items should be deactivated" do
    admin = User.create(name: 'admin', address: 'admin address', city: 'admin city', state: 'admin state', zip: 12345, email: 'admin_email', password: 'p', role: 3)
    meg_shop = create(:merchant, enabled?: false)
    bike_shop = create(:merchant)
    mike_shop = create(:merchant)
    item_1 = create(:item, merchant: meg_shop)
    item_2 = create(:item, merchant: meg_shop)
    item_3 = create(:item, merchant: bike_shop)
    item_4 = create(:item, merchant: bike_shop)
    item_5 = create(:item, merchant: mike_shop)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit "/admin/merchants/#{bike_shop.id}/items"

    within "#item-#{item_3.id}" do
      expect(page).to have_content("Active")
      expect(page).to_not have_button("Activate")

    end

    within "#item-#{item_4.id}" do
      expect(page).to have_content("Active")
      expect(page).to_not have_button("Activate")
    end



    visit admin_merchants_path

    within "#merchant-#{bike_shop.id}" do
      click_button "Disable"
    end

    expect(current_path).to eq(admin_merchants_path)



    visit "/admin/merchants/#{bike_shop.id}/items"

    within "#item-#{item_3.id}" do
      expect(page).to have_content("Inactive")
      expect(page).to_not have_button("Deactivate")
    end

    within "#item-#{item_4.id}" do
      expect(page).to have_content("Inactive")
      expect(page).to_not have_button("Deactivate")
    end
  end
end
