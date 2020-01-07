require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should validate_presence_of :status }
  end

  describe "relationships" do
    it {should have_many :item_orders}
    it {should have_many(:items).through(:item_orders)}
    it {should belong_to :user}
  end

  describe 'instance methods' do
    before :each do
      @user = User.create(name: 'user', address: 'user_address', city: 'user_city', state: 'user_state', zip: 12345, email: 'user_email_test', password: 'pp', password_confirmation: 'pp', role: 0)

      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @user.orders.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      @order_1 = Order.last
      @item_order_1 = @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @item_order_2 = @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)


      @user_1 = create(:user, role: 0)
      @user_2 = create(:user, role: 0)
      @user_3 = create(:user, role: 0)

      @order_2 = create(:order, created_at: Date.today, user: @user_1, status: 3)
      @order_3 = create(:order, created_at: Date.today, user: @user_2, status: 1)
      @order_4 = create(:order, created_at: Date.today, user: @user_3, status: 2)
      @order_5 = create(:order, created_at: Date.today, user: @user_1, status: 0)
    end

    it 'grandtotal' do
      expect(@order_1.grandtotal).to eq(230)
    end

    it 'total_items' do
      expect(@order_1.total_items).to eq(5)
    end

    it 'update order status when all item_orders fulfilled' do
      cart = Cart.new(Hash.new(0))
      cart.add_item(@pull_toy.id)
      cart.add_item(@pull_toy.id)
      cart.add_item(@pull_toy.id)
      cart.add_item(@tire.id)
      cart.add_item(@tire.id)
      Item.decrease_item_inventory(cart)
      expect(Item.find(@pull_toy.id).inventory).to eq(29)
      expect(Item.find(@tire.id).inventory).to eq(10)
      expect(Order.find(@order_1.id).status).to eq('pending')
      @item_order_1.update(status: 'fulfilled')
      @item_order_2.update(status: 'fulfilled')
      Order.update_order_status_to_packaged
      expect(Order.find(@order_1.id).status).to eq('packaged')
    end

    it 'orders should display in order of status enums on admin dashboard' do
      expect(Order.order(:status)).to eq([@order_5, @order_1, @order_3, @order_4, @order_2])
    end
  end
end
