require 'rails_helper'

RSpec.describe "create an item as an Merchant" do
  before :each do
    @merchant = create(:merchant)
    @item_1 = create(:item, merchant: @merchant)
    @item_2 = create(:item, merchant: @merchant)
    @merchant_employee = create(:user, role: 1, merchant: @merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
  end

  it "MERCHANT EMPLOYEE: click add item button and fill out create new item form" do
    name = "Chamois Buttr"
    price = 18
    description = "No more chaffin'!"
    inventory = 25

    visit "/merchant/items"
    click_on("Add Item")

    expect(current_path).to eq("/merchant/items/new")
    fill_in 'Name', with: name
    fill_in 'Price', with: price
    fill_in 'Description', with: description
    fill_in 'Image', with: ''
    fill_in 'Inventory', with: inventory

    click_button "Submit"

    new_item = Item.last

    expect(current_path).to eq("/merchant/items")
    expect(page).to have_content("Item added!")
    expect(new_item.name).to eq(name)
    expect(new_item.price).to eq(price)
    expect(new_item.description).to eq(description)
    expect(page).to have_css("img[src*='https://scontent-den4-1.cdninstagram.com/v/t51.2885-15/e35/11375785_1097843546897273_287775595_n.jpg?_nc_ht=scontent-den4-1.cdninstagram.com&_nc_cat=105&_nc_ohc=yrczfty57n0AX-7OByN&oh=d6298df08426babd3eb105ea14b12329&oe=5E9B3359']")
    expect(new_item.inventory).to eq(inventory)
    expect(Item.last.active?).to be(true)
    expect("#item-#{Item.last.id}").to be_present
    expect(page).to have_content(name)
    expect(page).to have_content("Price: $#{new_item.price}")
    expect(page).to have_css("img[src*='#{new_item.image}']")
    expect(page).to have_content("Active")
    expect(page).to have_content(new_item.description)
    expect(page).to have_content("Inventory: #{new_item.inventory}")

  end

  it 'I get an alert if I dont fully fill out the form -- data stays populated' do
    visit "/merchant/items"
    click_on("Add Item")
    expect(current_path).to eq("/merchant/items/new")

    name = ""
    price = 18
    description = "No more chaffin'!"
    image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
    inventory = ""

    fill_in 'Name', with: name
    fill_in 'Price', with: price
    fill_in 'Description', with: description
    fill_in 'Image', with: image_url
    fill_in 'Inventory', with: inventory

    click_button "Submit"

    expect(page).to have_content("Name can't be blank, Inventory can't be blank, and Inventory is not a number")
    expect(find_field('Name').value).to eq(name)
    expect(find_field('Price').value).to eq(price.to_s)
    expect(find_field('Image').value).to eq(image_url)
    expect(find_field('Inventory').value).to eq(inventory)
    expect(find_field('Description').value).to eq(description)
    expect(page).to have_button("Submit")
  end
end
