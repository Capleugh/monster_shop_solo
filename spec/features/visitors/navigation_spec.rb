require 'rails_helper'

RSpec.describe 'User types can navigate appropriately', type: :feature do

  it 'can navigate through the navbar and cart increments' do
    merchant = Merchant.create!(name: 'merchant', address: 'merchant_address', city: 'merchant_city', state: 'merchant_state', zip: 12345)
    item = merchant.items.create!(name: 'item', description: 'description', price: 10, image: 'https://upload.wikimedia.org/wikipedia/commons/0/06/Item_Industrietechnik_und_Maschinenbau_logo.svg', inventory: 20, merchant_id: merchant.id)

    visit '/'
    click_on 'Home'
    expect(current_path).to eq('/')
    click_on 'All Items'
    expect(current_path).to eq('/items')
    click_on 'All Merchants'
    expect(current_path).to eq('/merchants')
    click_on 'Cart:'
    expect(current_path).to eq('/cart')
    click_on 'Login'
    expect(current_path).to eq('/login')
    click_on 'Register'
    expect(current_path).to eq('/users/register')

    click_on 'All Items'
    click_on 'item'
    click_on 'Add To Cart'
    click_on 'item'
    click_on 'Add To Cart'

    expect(page).to have_content('Cart: 2')
  end
end
