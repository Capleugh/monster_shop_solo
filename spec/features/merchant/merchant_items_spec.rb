require 'rails_helper'

# User Story 42, Merchant deactivates an item
#
# As a merchant
# When I visit my items page
# I see a link or button to deactivate the item next to each item that is active
# And I click on the "deactivate" button or link for an item
# I am returned to my items page
# I see a flash message indicating this item is no longer for sale
# I see the item is now inactive

RSpec.describe "As a merchant" do
  describe "when I visit my items page" do
    before :each do
      @merchant = create(:merchant)
      @item_1 = create(:item, merchant: @merchant)
      @item_2 = create(:item, merchant: @merchant)
      # item_3 = create(:item)
      # item_4 = create(:item)
      # item_5 = create(:item)
      # item_6 = create(:item)

      @merchant_employee = create(:user, role: 1, merchant: @merchant)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
    end

    it "I see only my items info" do
      merchant_2 = create(:merchant)
      merchant_2_item_1 = create(:item, description: "Item 2 description", image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588")

      visit merchant_items_path

      within "#item-#{@item_1.id}" do
        expect(page).to have_link(@item_1.name)
        expect(page).to have_content(@item_1.description)
        expect(page).to have_content("Price: $#{@item_1.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@item_1.inventory}")
        expect(page).to have_link(@merchant.name)
        expect(page).to have_css("img[src*='#{@item_1.image}']")
      end

      within "#item-#{@item_2.id}" do
        expect(page).to have_link(@item_2.name)
        expect(page).to have_content(@item_2.description)
        expect(page).to have_content("Price: $#{@item_2.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@item_2.inventory}")
        expect(page).to have_link(@merchant.name)
        expect(page).to have_css("img[src*='#{@item_2.image}']")
      end

      expect(page).to_not have_css("#item-#{merchant_2_item_1.id}")
      expect(page).to_not have_link(merchant_2_item_1.name)
      expect(page).to_not have_content(merchant_2_item_1.description)
      expect(page).to_not have_content("Price: $#{merchant_2_item_1.price}")
      expect(page).to_not have_content("Inventory: #{merchant_2_item_1.inventory}")
      expect(page).to_not have_link(merchant_2.name)
      expect(page).to_not have_css("img[src*='#{merchant_2_item_1.image}']")

      within "#item-#{@item_1.id}" do
        click_on('img')
      end

      expect(current_path).to eq("/merchant/items/#{@item_1.id}")
    end

    it "the item name and image both link to my merchant item show page" do
      visit merchant_items_path

      within "#item-#{@item_1.id}" do
        click_on('img')
      end

      expect(current_path).to eq("/merchant/items/#{@item_1.id}")

      visit merchant_items_path

      within "#item-#{@item_1.id}" do
        click_on(@item_1.name)
      end

      expect(current_path).to eq("/merchant/items/#{@item_1.id}")

    end


    xit "I can click a button to deactivate the item if it is active" do
      #make an item that is not active
      visit merchant_items_path #????

      within "#item-#{@item_1.id}" do
        expect(page).to have_content("Active")
        click_button "Deactivate"
      end

      #expect the current page to still be the merchant_items
      #expect page to have flash message "___ item is no longer for sale"
      #
      within "#item-#{@item_1.id}" do
        expect(page).to have_content("Inactive")
        expect(page).to_not have_button("Deactivate")
      end
    end

    xit "I do not see a button next to items that are inactive" do

    end
  end
end
