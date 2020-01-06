RSpec.describe("Cancel and existing order from order show page") do
  describe "cancel order" do
    before :each do
      @order = create(:order)
      @user = User.last
      @item_1 = create(:item, inventory: 20)
      @item_2 = create(:item, inventory: 25)
      @item_3 = create(:item, inventory: 30)
      @item_order_1 = @order.item_orders.create(item: @item_1, quantity: 2, price: @item_1.price)
      @order.item_orders.create(item: @item_2, quantity: 1, price: @item_2.price)
      @order.item_orders.create(item: @item_3, quantity: 3, price: @item_3.price)
    end

    it "cancel order and verify status changed on order page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      expect(@item_1.inventory).to eq(20)
      expect(@item_2.inventory).to eq(25)
      expect(@item_3.inventory).to eq(30)
      cart = Cart.new(Hash.new(0))
      cart.add_item(@item_1.id)
      cart.add_item(@item_1.id)
      cart.add_item(@item_2.id)
      cart.add_item(@item_3.id)
      cart.add_item(@item_3.id)
      cart.add_item(@item_3.id)
      Item.decrease_item_inventory(cart)
      visit "/profile/orders/#{@order.id}"
      expect(Item.find(@item_1.id).inventory).to eq(18)
      expect(Item.find(@item_2.id).inventory).to eq(24)
      expect(Item.find(@item_3.id).inventory).to eq(27)
      @item_order_1.update(status: 'fulfilled')
      expect(ItemOrder.find(@item_order_1.id).status).to eq('fulfilled')
      click_on "Cancel Order"
      expect(current_path).to eq("/profile")
      expect(page).to have_content("#{@order.id} has been cancelled.")
      visit "/profile/orders"
      expect(page).to have_content("Order Status: cancelled")
      expect(Item.find(@item_1.id).inventory).to eq(20)
      expect(Item.find(@item_2.id).inventory).to eq(25)
      expect(Item.find(@item_3.id).inventory).to eq(30)
      expect(ItemOrder.find(@item_order_1.id).status).to eq('unfulfilled')
    end

    it "cannot cancel order because order status isn't pending" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      @order.update(status: 0)
      expect(Order.find(@order.id).status).to eq('packaged')
      visit "/profile/orders/#{@order.id}"
      click_on "Cancel Order"
      expect(current_path).to eq("/profile/orders/#{@order.id}")
      expect(page).to have_content("Unable to cancel order.")
    end
  end
end
