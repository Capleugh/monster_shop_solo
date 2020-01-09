require 'rails_helper'

RSpec.describe 'As an Admin', type: :feature do
  before(:each) do
    @admin = User.create!(name: 'admin', address: 'admin_address', city: 'admin_city', state: 'admin_state', zip: 12345, email: 'admin_email', password: 'p', role: 3)

    bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

    tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

    @user = User.create(name: 'user', address: 'user_address', city: 'user_city', state: 'user_state', zip: 12345, email: 'user_email', password: 'p', password_confirmation: 'p', role: 0)
    @order = @user.orders.create(name: 'David', address: '14251 East 22nd place', city: 'Denver', state: 'Co', zip: 80238, status: 'packaged')
    @order.item_orders.create!(item: tire, price: tire.price, quantity: 5)
    @order.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 4)
    @order.item_orders.create!(item: dog_bone, price: pull_toy.price, quantity: 1)
  end

  it 'Can ship packaged orders which can then no longer be canceled' do
    visit '/login'
    fill_in :email, with: 'admin_email'
    fill_in :password, with: 'p'

    click_on 'Submit'
    click_on 'Admin Dashboard'

    click_on 'Ship Order'

    expect(page).to_not have_button('Ship Order')

    click_on('Log Out')
    click_on('Login')

    fill_in :email, with: 'user_email'
    fill_in :password, with: 'p'
    click_on('Submit')
    click_on('My Orders')
    click_on(@order.id)
    expect(page).to_not have_link('Cancel Order')
  end
end
