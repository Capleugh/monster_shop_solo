RSpec.describe("Order Show Page") do
  describe "show page contains order details" do
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

    it "routes to order show page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit "/profile/orders"
      expect(page).to have_content(@user.orders.first.id)
    end

    it "route to order show page and have order details" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit "/profile/orders"
      click_on "#{@order.id}"
      expect(current_path).to eq("/profile/orders/#{@order.id}")

      expect(page).to have_content("#{@order.id}")
      expect(page).to have_content("#{@order.created_at}")
      expect(page).to have_content("#{@order.updated_at}")
      expect(page).to have_content("#{@order.status}")

      within "#item-#{@item_1.id}" do
        expect(page).to have_content("#{@item_1.name}")
        expect(page).to have_content("#{@item_1.description}")
        expect(page).to have_content("10")
        expect(page).to have_content("#{@item_1.price}")
        expect(page).to have_content(@item_1.price * 10)
        expect(page).to have_css("img[src*='#{@item_1.image}']")
      end

      within "#item-#{@item_2.id}" do
        expect(page).to have_content("#{@item_2.name}")
        expect(page).to have_content("#{@item_2.description}")
        expect(page).to have_content("10")
        expect(page).to have_content("#{@item_2.price}")
        expect(page).to have_content(@item_2.price * 10)
        expect(page).to have_css("img[src*='#{@item_2.image}']")
      end

      within "#item-#{@item_3.id}" do
        expect(page).to have_content("#{@item_3.name}")
        expect(page).to have_content("#{@item_3.description}")
        expect(page).to have_content("10")
        expect(page).to have_content("#{@item_3.price}")
        expect(page).to have_content(@item_3.price * 10)
        expect(page).to have_css("img[src*='#{@item_3.image}']")
      end

      expect(page).to have_content((@item_3.price * 10) + (@item_2.price * 10) + (@item_1.price * 10))
      expect(page).to have_content("30")
    end
    #
    # As a registered user
    # When I visit an order's show page
    # I see a button or link to cancel the order only if the order is still pending
    # When I click the cancel button for an order, the following happens:
    #
    # Each row in the "order items" table is given a status of "unfulfilled"
    # The order itself is given a status of "cancelled"
    # Any item quantities in the order that were previously fulfilled have their quantities returned to their respective merchant's inventory for that item.
    # I am returned to my profile page
    # I see a flash message telling me the order is now cancelled
    # And I see that this order now has an updated status of "cancelled"
    xit "User cancels an order" do
      visit "/profile/orders/#{@order.id}"
      click_on "Cancel Order"

    end

  end
end
