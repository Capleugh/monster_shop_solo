require 'rails_helper'

RSpec.describe "edit an item as an Amdin" do
  before :each do
    @merchant = create(:merchant)
    @item_1 = create(:item, merchant: @merchant)
    @item_2 = create(:item, merchant: @merchant)
    @merchant_employee = create(:user, role: 1, merchant: @merchant)
    @admin = create(:user, role: 3)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
  end

  it "ADMIN: edit items" do
    visit "/admin/merchants/#{@merchant.id}/items"

    within "#item-#{@item_1.id}" do
      click_on('Edit Item')
    end

    expect(current_path).to eq("/admin/merchants/#{@merchant.id}/items/#{@item_1.id}/edit")
    expect(find_field('Name').value).to eq @item_1.name
    expect(find_field('Description').value).to eq @item_1.description
    expect(find_field('Price').value).to eq ActionController::Base.helpers.number_to_currency(@item_1.price)
    expect(find_field('Image').value).to eq @item_1.image
    expect(find_field('Inventory').value).to eq @item_1.inventory.to_s

    fill_in 'Price', with: 0
    click_button "Update Item"
    expect(page).to have_content('Price must be greater than 0')

    fill_in 'Price', with: 22
    fill_in 'Inventory', with: -1
    click_on('Update Item')
    expect(page).to have_content('Inventory must be greater than or equal to 0')

    fill_in 'Name', with: "Other Thing"
    fill_in 'Price', with: 333
    fill_in 'Description', with: "They're a bit more expensive, and they kinda do pop sometimes, but whatevs.. this is retail."
    fill_in 'Image', with: ''
    fill_in 'Inventory', with: 66
    click_on('Update Item')

    expect(current_path).to eq("/admin/merchants/#{@merchant.id}/items")
    expect(page).to have_content('Other Thing')
    expect(page).to have_content(333)
    expect(page).to have_content("They're a bit more expensive, and they kinda do pop sometimes, but whatevs.. this is retail.")
    expect(page).to have_css("img[src*='https://scontent-den4-1.cdninstagram.com/v/t51.2885-15/e35/11375785_1097843546897273_287775595_n.jpg?_nc_ht=scontent-den4-1.cdninstagram.com&_nc_cat=105&_nc_ohc=yrczfty57n0AX-7OByN&oh=d6298df08426babd3eb105ea14b12329&oe=5E9B3359']")
    expect(page).to have_content(66)
    expect(page).to have_content('Item Has Been Updated')
  end

end
