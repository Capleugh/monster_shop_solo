require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :inventory }
    it { should validate_numericality_of(:inventory).is_greater_than_or_equal_to(0)}
    it { should validate_inclusion_of(:active?).in_array([true,false]) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      user = User.create(name: 'user', address: 'user_address', city: 'user_city', state: 'user_state', zip: 12345, email: 'user_email_test', password: 'pp', password_confirmation: 'pp', role: 0)
      user.orders.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order = Order.last
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end

    it "finds all active pets" do
      @bike_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      result = Item.find_active_items
      expect(result.count).to eq(1)
    end

    it "finds top five items and bottom five items sold by quantity" do
      item_1 = create(:item)
      item_2 = create(:item)
      item_3 = create(:item)
      item_4 = create(:item)
      item_5 = create(:item)
      item_6 = create(:item)
      item_7 = create(:item)
      item_8 = create(:item)
      item_9 = create(:item)
      item_10 = create(:item)
      order_1 = create(:order)
      order_2 = create(:order)
      order_3 = create(:order)
      cart_1 = {item_1 => 10, item_2 => 9, item_3 => 8, item_6 => 5}
      cart_2 = {item_4 => 7, item_5 => 6, item_6 => 5}
      cart_3 = {item_7 => 4, item_8 => 3, item_9 => 2, item_10 => 1, item_6 => 5}

      cart_1.each do |item,quantity|
        order_1.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      cart_2.each do |item,quantity|
        order_2.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      cart_3.each do |item,quantity|
        order_3.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end

      result = Item.top_five_items.first
      expect(result).to eq(item_6)

      result = Item.top_five_items.last
      expect(result).to eq(item_4)

      result = Item.bottom_five_items.first
      expect(result).to eq(item_10)

      result = Item.bottom_five_items.last
      expect(result).to eq(item_5)

      item_6.update!(active?: false)
      result = Item.top_five_items.include?(item_6)
      expect(result).to eq(false)

      item_10.update!(active?: false)
      result = Item.bottom_five_items.include?(item_10)
      expect(result).to eq(false)
    end

    it "decrease_item_inventory(quantity)" do
      item_1 = create(:item, inventory: 15)
      item_1.decrease_item_inventory(10)

      expect(item_1.inventory).to eq(5)
    end

    it "increase_item_inventory(quantity)" do
      order = create(:order)
      item_1 = create(:item, inventory: 8)
      item_2 = create(:item, inventory: 4)

      item_1.increase_item_inventory(2)
      item_2.increase_item_inventory(6)

      expect(item_1.inventory).to eq(10)
      expect(item_2.inventory).to eq(10)
    end

    it "quantity_ordered(order)" do
      order = create(:order)
      item_1 = create(:item, inventory: 8)
      item_2 = create(:item, inventory: 4)
      item_order_1 = order.item_orders.create(item: item_1, quantity: 5, price: item_1.price)
      item_order_2 = order.item_orders.create(item: item_2, quantity: 1, price: item_2.price)

      expect(item_1.quantity_ordered(order)).to eq(5)
      expect(item_2.quantity_ordered(order)).to eq(1)
    end

    it "deactivate_all_items" do
      dog_shop = create(:merchant)
      item_1 = create(:item, merchant: dog_shop)
      item_2 = create(:item, merchant: dog_shop)
      item_3 = create(:item, merchant: dog_shop)

      Item.deactivate_all_items

      expect(Item.find(item_1.id).active?).to eq(false)
      expect(Item.find(item_2.id).active?).to eq(false)
      expect(Item.find(item_3.id).active?).to eq(false)


      mike_shop = create(:merchant)
      item_4 = create(:item, merchant: mike_shop)
      item_5 = create(:item, merchant: mike_shop)

      expect(Item.find(item_4.id).active?).to eq(true)
      expect(Item.find(item_5.id).active?).to eq(true)
    end

    it "activate_all_items" do
      dog_shop = create(:merchant, enabled?: false)
      item_1 = create(:item, active?: false, merchant: dog_shop)
      item_2 = create(:item, active?: false, merchant: dog_shop)
      item_3 = create(:item, active?: false, merchant: dog_shop)

      Item.activate_all_items

      expect(Item.find(item_1.id).active?).to eq(true)
      expect(Item.find(item_2.id).active?).to eq(true)
      expect(Item.find(item_3.id).active?).to eq(true)
    end
  end
end
