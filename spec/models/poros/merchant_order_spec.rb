require 'rails_helper'
require './app/models/poros/merchant_show'

RSpec.describe MerchantShow do
  describe "PORO methods" do
    before(:each) do
      @merchant = create(:merchant)
      @user = create(:user, role: 1, merchant_id: @merchant.id)
      @order = create(:order, user: @user)
      @item_1 = create(:item, merchant: @merchant, inventory: 5)
      @item_2 = create(:item, merchant: @merchant, inventory: 3)
      @item_3 = create(:item)
      @item_order_1 = @order.item_orders.create(item: @item_1, quantity: 2, price: @item_1.price)
      @order.item_orders.create(item: @item_2, quantity: 3, price: @item_2.price)
      @order.item_orders.create(item: @item_3, quantity: 4, price: @item_3.price)
      @order = Order.last
      @merchant_show = MerchantShow.new(@order, @user)
    end

    it "find_items" do
      expect(@merchant_show.find_items).to eq([@item_1, @item_2])
    end

    it "find_quantity(item_id)" do
      expect(@merchant_show.find_quantity(@item_1.id)).to eq(2)
      expect(@merchant_show.find_quantity(@item_2.id)).to eq(3)
    end

    it "find_customer" do
      expect(@merchant_show.find_customer).to eq(@user)
    end

    it "able_to_fulfill(item_id)" do
      expect(@merchant_show.able_to_fulfill(@item_1.id)).to eq(true)
      expect(@merchant_show.able_to_fulfill(@item_2.id)).to eq(true)
      @item_order_1.update(status: 'fulfilled')
      expect(@merchant_show.able_to_fulfill(@item_1.id)).to eq(false)
      @item_2.update(inventory: 1)
      expect(@merchant_show.able_to_fulfill(@item_2.id)).to eq(false)
    end

    it "inventory_check(item_id)" do
      expect(@merchant_show.inventory_check(@item_1.id)).to eq(true)
      @item_2.update(inventory: 1)
      expect(@merchant_show.able_to_fulfill(@item_2.id)).to eq(false)
    end

    it "find_item_order_status(item_id)" do
      expect(@merchant_show.find_item_order_status(@item_1.id)).to eq(true)
      @item_order_1.update(status: 'fulfilled')
      expect(@merchant_show.able_to_fulfill(@item_1.id)).to eq(false)
    end
  end
end
