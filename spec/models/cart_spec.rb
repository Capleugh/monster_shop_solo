require 'rails_helper'

RSpec.describe Cart do
  describe "methods" do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    end

    it 'add_item(item)' do
      cart = Cart.new(Hash.new(0))
      result = cart.add_item(@paper)
      expect(result).to eq(1)
    end

    it 'total_items' do

    end

    it 'items' do

    end

    it 'subtotal(item)' do

    end

    it 'total' do

    end

    it 'add_quantity(item_id)' do

    end

    it 'subtract_quantity(item_id)' do

    end

    it 'limit_reached?(item_id)' do

    end

    it 'quantity_zero?(item_id)' do

    end
  end
end
