require 'rails_helper'

RSpec.describe 'As a Merchant', type: :feature do
  before(:each) do
    @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210, enabled?: false)

    @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    bike = @bike_shop.items.create(name: "Specialized Stumpjumper", description: "The best mountain bike ever!", price: 2000, image: "https://cdn11.bigcommerce.com/s-ha7hv3uknh/images/stencil/1280x1280/attribute_rule_images/4207_source_1554059208.jpeg", inventory: 2)
    seat = @bike_shop.items.create(name: "Bike Seat", description: "Stay comfy!", price: 40, image: "https://cdn.shopify.com/s/files/1/1246/6231/products/bike-seat-comfortable.jpg?v=1521624290", inventory: 8)
    jersey = @bike_shop.items.create(name: "Jersey", description: "Ladies bike jersey.", price: 80, image: "https://cdn.shopify.com/s/files/1/0185/7770/products/HeavyPedal_OutrunWomensJersey-1_1080x.png?v=1560285903", inventory: 15)
    helmet = @bike_shop.items.create(name: "Helmet", description: "The hipster-ist helmet there ever was!", price: 95, image: "https://cdn.shopify.com/s/files/1/0836/6919/products/thousand-helmet-rose-gold-1_2000x.jpg?v=1568244140", inventory: 4)

    pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

    merchant_employee = User.create(name: 'merchant_employee', address: 'merchant_employee_address', city: 'merchant_employee_city', state: 'merchant_employee_state', zip: 12345, email: 'merchant_employee_email', password: 'p', password_confirmation: 'p', role: 1, merchant: @bike_shop)
    merchant_employee_2 = User.create(name: 'merchant_employee_2', address: 'merchant_employee_address', city: 'merchant_employee_city', state: 'merchant_employee_state', zip: 12345, email: 'merchant_employee_email_2', password: 'p', password_confirmation: 'p', role: 1, merchant: dog_shop)

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
    expect(find_field('name').value).to eq 'Gatorskins'
    expect(find_field('description').value).to eq "They'll never pop!"
    expect(find_field('price').value).to eq '$100.00'
    expect(find_field('image').value).to eq "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588"
    expect(find_field('inventory').value).to eq '12'

    fill_in :price, with: 0
    click_on('Update Item')
    expect(page).to have_content('Price must be greater than 0')

    fill_in :price, with: 22
    fill_in :inventory, with: -1
    click_on('Update Item')
    expect(page).to have_content('Price is not a number')

    fill_in 'Name', with: "Other Thing"
    fill_in 'Price', with: 333
    fill_in 'Description', with: "They're a bit more expensive, and they kinda do pop sometimes, but whatevs.. this is retail."
    fill_in 'Image', with: ''
    fill_in 'Inventory', with: 66
    click_on('Update Item')

    expect(current_path).to eq("/merchant/items")
    expect(page).to have_content('Other Thing')
    expect(page).to have_content(333)
    expect(page).to have_content("They're a bit more expensive, and they kinda do pop sometimes, but whatevs.. this is retail.")
    expect(page).to have_content("img[src*='https://scontent-den4-1.cdninstagram.com/v/t51.2885-15/e35/11375785_1097843546897273_287775595_n.jpg?_nc_ht=scontent-den4-1.cdninstagram.com&_nc_cat=105&_nc_ohc=yrczfty57n0AX-7OByN&oh=d6298df08426babd3eb105ea14b12329&oe=5E9B3359']")
    expect(page).to have_content(66)
    expect(page).to have_content('Item Has Been Updated')
  end

# User Story 47, Merchant edits an item
# As a merchant
# When I visit my items page
# And I click the edit button or link next to any item
# Then I am taken to a form similar to the 'new item' form
# The form is pre-populated with all of this item's information
# I can change any information, but all of the rules for adding a new item still apply:
# - name and description cannot be blank
# - price cannot be less than $0.00
# - inventory must be 0 or greater
#
# When I submit the form
# I am taken back to my items page
# I see a flash message indicating my item is updated
# I see the item's new information on the page, and it maintains its previous enabled/disabled state
# If I left the image field blank, I see a placeholder image for the thumbnail
end
