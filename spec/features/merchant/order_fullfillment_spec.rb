require 'rails_helper'

RSpec.describe "As a merchant employee I can change the item order's status" do
  describe "when I visit my merchant dashboard and click on an order" do
    before :each do
      @merchant = create(:merchant)
      @user = create(:user, role: 1, merchant_id: @merchant.id)
      @order = create(:order, user: @user)
      @item_1 = create(:item, merchant: @merchant, inventory: 5)
      @item_2 = create(:item, merchant: @merchant, inventory: 3)
      @item_3 = create(:item)
      @item_order_1 = @order.item_orders.create(item: @item_1, quantity: 2, price: @item_1.price)
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

    it "I see a button or link to 'fulfill' if not already fulfilled" do
      @item_order_1.update(status: 'fulfilled')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit "/merchant/orders/#{@order.id}"
      #sad
      within "#item-#{@item_1.id}" do
        expect(page).to have_link(@item_1.name)
        expect(page).to have_content("Price: $#{@item_1.price}")
        expect(page).to have_content("Quantity: 2")
        expect(page).to have_css("img[src*='#{@item_1.image}']")
        expect(page).to_not have_button("Fulfill")
      end

      #happy
      within "#item-#{@item_2.id}" do
        expect(page).to have_link(@item_2.name)
        expect(page).to have_content("Price: $#{@item_2.price}")
        expect(page).to have_content("Quantity: 3")
        expect(page).to have_css("img[src*='#{@item_2.image}']")
        expect(page).to have_button("Fulfill")
      end
    end

    it "when the last merchant to fulfill all items in the order the order status changes from pending to packaged" do
      #next line is accounting for the fact that all the items hae to be fulfilled and item 3 belongs to a different merchant
      ItemOrder.where(item_id: @item_3.id).first.update(status: 'fulfilled')

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit merchant_path

      within "#pending-orders" do
        expect(page).to have_link("Order Number: #{@order.id}")
      end

      visit "/merchant/orders/#{@order.id}"

      within "#item-#{@item_1.id}" do
        click_button("Fulfill")
      end

      visit merchant_path

      within "#pending-orders" do
        expect(page).to have_link("Order Number: #{@order.id}")
      end

      visit "/merchant/orders/#{@order.id}"

      within "#item-#{@item_2.id}" do
        click_button("Fulfill")
      end

      visit merchant_path

      within "#pending-orders" do
        expect(page).to_not have_link("Order Number: #{@order.id}")
      end

      expect(Order.find(@order.id).status).to eq("packaged")
    end

    it "I cannot see a button to 'fulfill' if inventory is too low" do
      @item_2.update(inventory: 1)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit "/merchant/orders/#{@order.id}"

      #happy
      within "#item-#{@item_1.id}" do
        expect(page).to have_link(@item_1.name)
        expect(page).to have_content("Price: $#{@item_1.price}")
        expect(page).to have_content("Quantity: 2")
        expect(page).to have_css("img[src*='#{@item_1.image}']")
        expect(page).to have_button("Fulfill")
      end

      #sad
      within "#item-#{@item_2.id}" do
        expect(page).to have_link(@item_2.name)
        expect(page).to have_content("Price: $#{@item_2.price}")
        expect(page).to have_content("Quantity: 3")
        expect(page).to have_css("img[src*='#{@item_2.image}']")
        expect(page).to_not have_button("Fulfill")
      end
    end

    it "I cannot see a button to 'fulfill' if inventory is too low OR the item_order is already fulfilled" do
      expect(Item.find(@item_1.id).inventory).to eq(5)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit "/merchant/orders/#{@order.id}"

      within "#item-#{@item_1.id}" do
        click_button("Fulfill")
      end

      expect(current_path).to eq(merchant_order_path(@order.id))
      expect(page).to have_content("#{@item_1.name} has been fulfilled!")

      within "#item-#{@item_1.id}" do
        expect(page).to_not have_button("Fulfill")
        expect(page).to have_content("Already Fulfilled")
      end

      expect(Item.find(@item_1.id).inventory).to eq(3)
    end

    it "I cannot see a button to 'fulfill' if inventory is too low -- new notice saying so" do
      @item_1.update(inventory: 1)
      expect(Item.find(@item_1.id).inventory).to eq(1)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/merchant/orders/#{@order.id}"

      within "#item-#{@item_1.id}" do
        expect(page).to_not have_button("Fulfill")
        expect(page).to have_content("Inadequate Inventory Level")
      end

      expect(Item.find(@item_1.id).inventory).to eq(1)
    end
  end
end
