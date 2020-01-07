require 'rails_helper'

RSpec.describe 'As A User', type: :feature do
  before(:each) do
    @order = create(:order)
    @user = User.last
    @item_1 = create(:item)
    @item_2 = create(:item)
    @item_3 = create(:item)
    @order.item_orders.create(item: @item_1, quantity: 10, price: @item_1.price)
    @order.item_orders.create(item: @item_2, quantity: 10, price: @item_2.price)
    @order.item_orders.create(item: @item_3, quantity: 10, price: @item_3.price)
  end

  it 'When I visit  profile order page I see every order made ' do
    visit '/login'
    fill_in :email, with: @user.email
    fill_in :password, with: 'password'
    click_on 'Submit'

    visit "/items/#{@item_1.id}"
    click_on('Add To Cart')
    visit "/items/#{@item_1.id}"
    click_on('Add To Cart')
    visit "/items/#{@item_1.id}"
    click_on('Add To Cart')
    visit "/items/#{@item_2.id}"
    click_on('Add To Cart')

    visit '/cart'
    click_on('Checkout')

    fill_in :name, with: @user.name
    fill_in :address, with: @user.address
    fill_in :city, with: @user.city
    fill_in :state, with: @user.state
    fill_in :zip, with: @user.zip
    click_on('Create Order')

    within "#order-#{@order.id}" do
      expect(page).to have_content(@order.created_at)
      expect(page).to have_content(@order.updated_at)
      expect(page).to have_content(@order.status)
      expect(page).to have_content(@order.items.count)
      expect(page).to have_content(ActionController::Base.helpers.number_to_currency(@order.grandtotal))
    end
  end
end
