require 'rails_helper'

describe ItemOrder, type: :model do
  describe "validations" do
    it { should validate_presence_of :order_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :price }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :status}
  end

  describe "relationships" do
    it {should belong_to :item}
    it {should belong_to :order}
  end

  describe 'instance methods' do
    it 'subtotal' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      user = User.create(name: 'user', address: 'user_address', city: 'user_city', state: 'user_state', zip: 12345, email: 'user_email_test', password: 'pp', password_confirmation: 'pp', role: 0)
      user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order_1 = Order.last
      item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2)

      expect(item_order_1.subtotal).to eq(200)
    end

    it 'self.change_items_status_to_unfilled' do
      order = create(:order)
      item_1 = create(:item)
      item_2 = create(:item)
      item_3 = create(:item)
      item_order_1 = order.item_orders.create(item: item_1, quantity: 5, price: item_1.price)
      item_order_2 = order.item_orders.create(item: item_2, quantity: 5, price: item_2.price)
      item_order_3 = order.item_orders.create(item: item_3, quantity: 5, price: item_3.price)

      expect(item_order_1.status).to eq("unfulfilled")
      expect(item_order_2.status).to eq("unfulfilled")
      expect(item_order_3.status).to eq("unfulfilled")

      item_order_1.update(status: 1)
      item_order_2.update(status: 1)
      item_order_3.update(status: 1)

      expect(item_order_1.status).to eq("fulfilled")
      expect(item_order_2.status).to eq("fulfilled")
      expect(item_order_3.status).to eq("fulfilled")

      ItemOrder.change_status_to_unfulfilled

      expect(ItemOrder.find(item_order_1.id).status).to eq("unfulfilled")
      expect(ItemOrder.find(item_order_2.id).status).to eq("unfulfilled")
      expect(ItemOrder.find(item_order_3.id).status).to eq("unfulfilled")
    end


    it 'self.change_items_status_to_fulfilled(item_id, order_id)' do
      order = create(:order)
      item_1 = create(:item)
      item_2 = create(:item)
      item_3 = create(:item)
      item_order_1 = order.item_orders.create(item: item_1, quantity: 5, price: item_1.price)

      expect(item_order_1.status).to eq("unfulfilled")

      ItemOrder.change_item_order_status_to_fulfilled(item_1.id, order.id)

      expect(ItemOrder.find(item_order_1.id).status).to eq("fulfilled")    
    end
  end
end
