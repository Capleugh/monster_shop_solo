require 'rails_helper'

RSpec.describe 'As a Merchant', type: :feature do
  before(:each) do
    @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

    merchant_employee = User.create(name: 'merchant_employee', address: 'merchant_employee_address', city: 'merchant_employee_city', state: 'merchant_employee_state', zip: 12345, email: 'merchant_employee_email', password: 'p', password_confirmation: 'p', role: 1, merchant: @bike_shop)

    @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

    email = merchant_employee.email
    password = merchant_employee.password
    visit('/')
    click_on('Login')
    fill_in :email, with: email
    fill_in :password, with: password
    click_on('Submit')
    click_on('View Your Items')
  end

  it 'On my items page I have an edit link' do
    within "#item-#{@tire.id}" do
      click_on('Edit Item')
    end

    expect(current_path).to eq("/merchant/items/#{@tire.id}/edit")
    expect(find_field('Name').value).to eq 'Gatorskins'
    expect(find_field('Description').value).to eq "They'll never pop!"
    expect(find_field('Price').value).to eq '100'
    expect(find_field('Image').value).to eq "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588"
    expect(find_field('Inventory').value).to eq '12'

    fill_in 'Price', with: 0
    click_on('Submit')
    expect(page).to have_content('Price must be greater than 0')

    fill_in 'Price', with: 22
    fill_in 'Inventory', with: -1
    click_on('Submit')
    expect(page).to have_content('Inventory must be greater than or equal to 0')

    fill_in 'Name', with: "Other Thing"
    fill_in 'Price', with: 333
    fill_in 'Description', with: "They're a bit more expensive, and they kinda do pop sometimes, but whatevs.. this is retail."
    fill_in 'Image', with: ''
    fill_in 'Inventory', with: 66
    click_on('Submit')

    expect(current_path).to eq("/merchant/items")
    expect(page).to have_content('Other Thing')
    expect(page).to have_content(333)
    expect(page).to have_content("They're a bit more expensive, and they kinda do pop sometimes, but whatevs.. this is retail.")
    expect(page).to have_css("img[src*='https://scontent-den4-1.cdninstagram.com/v/t51.2885-15/e35/11375785_1097843546897273_287775595_n.jpg?_nc_ht=scontent-den4-1.cdninstagram.com&_nc_cat=105&_nc_ohc=yrczfty57n0AX-7OByN&oh=d6298df08426babd3eb105ea14b12329&oe=5E9B3359']")
    expect(page).to have_content(66)
    expect(page).to have_content('Item Has Been Updated')
  end
end
