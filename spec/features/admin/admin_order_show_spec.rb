require 'rails_helper'

RSpec.describe 'As an Admin', type: :feature do
  before(:each) do
    @admin = User.create(name: 'admin', address: 'admin_address', city: 'admin_city', state: 'admin_state', zip: 12345, email: 'admin_email', password: 'p', password_confirmation: 'p', role: 3)
    @order = create(:order)
    @user = User.last
    @item_1 = create(:item, inventory: 20)
    @item_2 = create(:item, inventory: 25)
    @item_3 = create(:item, inventory: 30)
    @item_order_1 = @order.item_orders.create(item: @item_1, quantity: 10, price: @item_1.price)
    @order.item_orders.create(item: @item_2, quantity: 10, price: @item_2.price)
    @order.item_orders.create(item: @item_3, quantity: 10, price: @item_3.price)

    email = @admin.email
    password = @admin.password

    visit('/')
    click_on('Login')
    fill_in :email, with: email
    fill_in :password, with: password
    click_on('Submit')
  end

  it 'admin has their own orders show page' do
    visit('/admin')
    expect(page).to have_content(@order.id)
    click_on(@order.id)
    expect(current_path).to eq("/admin/users/#{@order.user.id}/orders/#{@order.id}")

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

    expect(page).to have_content(ActionController::Base.helpers.number_to_currency(@order.grandtotal))
    expect(page).to have_content("30")
  end

  it "admin can cancel 'pending' orders on behalf of a user" do
    visit "/admin/users/#{@order.user.id}/orders/#{@order.id}"

    @item_order_1.update(status: 'fulfilled')
    expect(ItemOrder.find(@item_order_1.id).status).to eq('fulfilled')
    expect(Item.find(@item_1.id).inventory).to eq(20)

    click_on "Cancel Order"

    expect(current_path).to eq("/admin")

    expect(page).to have_content("#{@order.id} has been cancelled.")

    visit "/admin/users/#{@order.user.id}/orders/#{@order.id}"

    expect(page).to have_content("cancelled")
    expect(ItemOrder.find(@item_order_1.id).status).to eq('unfulfilled')
    expect(Item.find(@item_1.id).inventory).to eq(30)
  end

  it "cannot cancel order because order status isn't pending" do

    @order.update(status: 0)
    expect(Order.find(@order.id).status).to eq('packaged')

    visit "/admin/users/#{@order.user.id}/orders/#{@order.id}"

    expect(page).to_not have_link "Cancel Order"
  end
end
