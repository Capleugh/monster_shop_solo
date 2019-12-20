require 'rails_helper'

RSpec.describe 'As A User', type: :feature do
  before(:each) do
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

    @foxy_user = User.create!(name: 'Foxy', address: '4942 Willow Street', city: 'Denver', state: 'Colorado', zip:80238, email: 'foxy_email', password: 'david', role: 0)

    @order = @foxy_user.orders.create!(name: 'this', address: 'that', city: 'this', state: 'that', zip: 12345)
  end

  it 'As a registered user if i have orders there is a link to to My Orders to /profile/orders' do
    visit '/login'

    fill_in :email, with: @foxy_user.email
    fill_in :password, with: @foxy_user.password

    click_on('Submit')

    visit "/items/#{@paper.id}"
    click_on "Add To Cart"
    visit "/items/#{@tire.id}"
    click_on "Add To Cart"
    visit "/items/#{@pencil.id}"
    click_on "Add To Cart"

    visit('/cart')

    click_on('Checkout')

    fill_in :name, with: 'Foxy'
    fill_in :address, with: '4942 Willow Street'
    fill_in :city, with: 'Denver'
    fill_in :state, with: 'Colorado'
    fill_in :zip, with: 80238

    click_on('Create Order')

    visit '/profile'

    click_on('My Orders')

    expect(current_path).to eq('/profile/orders')
  end
end
