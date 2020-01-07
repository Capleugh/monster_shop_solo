require 'rails_helper'

RSpec.describe "As a merchant employee I can cahnge the item order's status" do
  describe "when I visit my merchant dashboard and click on an order" do
    before :each do
      @merchant = create(:merchant)
      @user = create(:user, role: 1, merchant_id: @merchant)
      @order = create(:order, user: @user)
      @item_1 = create(:item, merchant: @merchant)
      @item_2 = create(:item, merchant: @merchant)
      @item_3 = create(:item)
      @order.item_orders.create(item: @item_1, quantity: 10, price: @item_1.price)
      @order.item_orders.create(item: @item_2, quantity: 10, price: @item_2.price)
      @order.item_orders.create(item: @item_3, quantity: 10, price: @item_3.price)
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

    end

    it "I do not see any items in the order being purchased from other merchants" do

    end

    it "i see: name (as link), image, price, and quanity" do

    end
  end
end
