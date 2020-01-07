require 'rails_helper'

RSpec.describe "As a merchant employee I can cahnge the item order's status" do
  describe "when I visit my merchant dashboard and click on an order" do
    before :each do
      @merchant = create(:merchant)
      @user = create(:user, role: 1, merchant_id: @merchant.id)
      @order = create(:order, user: @user)
      @item_1 = create(:item, merchant: @merchant)
      @item_2 = create(:item, merchant: @merchant)
      @item_3 = create(:item)
      @order.item_orders.create(item: @item_1, quantity: 2, price: @item_1.price)
      @order.item_orders.create(item: @item_2, quantity: 3, price: @item_2.price)
      @order.item_orders.create(item: @item_3, quantity: 4, price: @item_3.price)
    end
    it "I see the recipients name and address that was used to create this order" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit "/merchant/orders/#{@order.id}"
      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.address)
      expect(page).to have_content(@user.city)
      expect(page).to have_content(@user.state)
      expect(page).to have_content(@user.zip)
    end

    it "I only see the items in the order that are being purchased from my merchant" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit "/merchant/orders/#{@order.id}"
      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@item_2.name)
      expect(page).to_not have_content(@item_3.name)
    end

    it "i see: name (as link), image, price, and quanity" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit "/merchant/orders/#{@order.id}"
      save_and_open_page
      within "#item-#{@item_1.id}" do
        expect(page).to have_link(@item_1.name)
        expect(page).to have_content("Price: $#{@item_1.price}")
        expect(page).to have_content("Quantity: 2")
        expect(page).to have_css("img[src*='#{@item_1.image}']")
      end

      within "#item-#{@item_2.id}" do
        expect(page).to have_link(@item_2.name)
        expect(page).to have_content("Price: $#{@item_2.price}")
        expect(page).to have_content("Quantity: 3")
        expect(page).to have_css("img[src*='#{@item_2.image}']")
      end
    end
  end
end
