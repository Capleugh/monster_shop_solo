RSpec.describe("Cancel and existing order from order show page") do
  describe "cancel order" do
    before :each do
      @order = create(:order)
      @user = User.last
      @item_1 = create(:item)
      @item_2 = create(:item)
      @item_3 = create(:item)
      @order.item_orders.create(item: @item_1, quantity: 10, price: @item_1.price)
      @order.item_orders.create(item: @item_2, quantity: 10, price: @item_2.price)
      @order.item_orders.create(item: @item_3, quantity: 10, price: @item_3.price)
    end

    it "cancel order and verify status changed on order page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit "/profile/orders/#{@order.id}"
      click_on "Cancel Order"
      expect(current_path).to eq("/profile")
      expect(page).to have_content("#{@order.id} has been cancelled.")
      visit "/profile/orders"
      expect(page).to have_content("Order Status: cancelled")
    end
  end
end
