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
      visit "profile/orders"
      expect(page).to have_content(@user.orders.first.name)
    end

    it "route to order show page and have order details" do
      visit "profile/orders"
      click_on "#{@order.id}"
      expect(current_path).to eq("/profile/orders/#{@order.id}")
      #visit "/profile/orders/#{@order.id}"

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
  end
end
