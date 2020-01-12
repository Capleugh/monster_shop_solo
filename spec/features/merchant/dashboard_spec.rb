require 'rails_helper'

RSpec.describe "As a merchant employee or merchant admin" do
  describe "when I visit my merchant dashboard" do
    it "I see the name and full address of the merchant I work for" do
      bike_shop = create(:merchant)
      merchant_employee = create(:user, role: 1, merchant: bike_shop)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)

      visit merchant_path

      expect(page).to have_content(bike_shop.name)
      expect(page).to have_content(bike_shop.address)
      expect(page).to have_content(bike_shop.city)
      expect(page).to have_content(bike_shop.state)
      expect(page).to have_content(bike_shop.zip)
    end
  end

  it "I see the name and full address of the merchant I work for" do
    bike_shop = create(:merchant)
    merchant_admin = create(:user, role: 2, merchant: bike_shop)


    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

    visit merchant_path

    expect(page).to have_content(bike_shop.name)
    expect(page).to have_content(bike_shop.address)
    expect(page).to have_content(bike_shop.city)
    expect(page).to have_content(bike_shop.state)
    expect(page).to have_content(bike_shop.zip)
  end

  it "I see a link to view my own items and when I click that link, my URI route should be '/merchant/items'" do
    bike_shop = create(:merchant)
    merchant_employee = create(:user, role: 1, merchant: bike_shop)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)


    visit merchant_path
    click_link 'View Your Items'

    expect(current_path).to eq(merchant_items_path)
  end

  it "I see a link to view my own items and when I click that link, my URI route should be '/merchant/items'" do
    bike_shop = create(:merchant)
    merchant_admin = create(:user, role: 2, merchant: bike_shop)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

    visit merchant_path
    click_link 'View Your Items'

    expect(current_path).to eq(merchant_items_path)
  end

  describe "if any users have pending orders containing items I sell" do
    it "lists those orders and information about it" do
      @order = create(:order)
      @order_2 = create(:order, created_at: Date.today)
      @user = User.last
      @item_1 = create(:item)
      @item_2 = create(:item)
      @item_3 = create(:item)

      merchant_3 = @item_1.merchant

      merchant_3_employee = create(:user, role: 1, merchant: merchant_3)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_3_employee)

      @order.item_orders.create(item: @item_1, quantity: 10, price: @item_1.price)
      @order.item_orders.create(item: @item_2, quantity: 10, price: @item_2.price)
      @order.item_orders.create(item: @item_3, quantity: 10, price: @item_3.price)

      @order_2.item_orders.create(item: @item_1, quantity: 5, price: @item_1.price)
      @order_2.item_orders.create(item: @item_2, quantity: 5, price: @item_2.price)

      @order_2.update(status: "cancelled")

      visit merchant_path
      within "#pending-orders" do
        within "#order-#{@order.id}" do
          expect(page).to have_content(@order.created_at)
          expect(page).to have_content(@order.items.count)
          expect(page).to have_content(ActionController::Base.helpers.number_to_currency(@order.grandtotal))
          click_link("Order Number: #{@order.id}")
        end
      end

      expect(current_path).to eq("/merchant/orders/#{@order.id}")

      visit merchant_path

      within "#pending-orders" do
        expect(page).to_not have_link("Order Number: #{@order_2.id}")
        expect(page).to_not have_content(@order_2.created_at)
        expect(page).to_not have_content("Number of Items: #{@order_2.items.count}")
        expect(page).to_not have_content(@order_2.grandtotal)
      end
    end

    it "I see a link to manage my coupons" do
      bike_shop = create(:merchant)
      merchant_employee = create(:user, role: 1, merchant: bike_shop)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)

      visit merchant_path

      expect(page).to have_link("Manage Coupons")
    end

    it "I see a link to manage my coupons" do
      bike_shop = create(:merchant)
      merchant_admin = create(:user, role: 2, merchant: bike_shop)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

      visit merchant_path

      expect(page).to have_link("Manage Coupons")
    end

    it "when I click a link to manage my coupons, I am taken to a coupons index page" do
      bike_shop = create(:merchant)
      merchant_employee = create(:user, role: 1, merchant: bike_shop)
      coupon_1 = bike_shop.coupons.create(name: "25% weekend promo", code: "WKD25", percent: 0.25)
      coupon_2 = bike_shop.coupons.create(name: "50% labor day promo", code: "LABOR50", percent: 0.5)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)

      visit merchant_path

      click_link "Manage Coupons"
      expect(current_path).to eq(merchant_coupons_path)

      within "#coupon-#{coupon_1.id}" do
        expect(page).to have_link(coupon_1.name)
        expect(page).to have_content(coupon_1.code)
        expect(page).to have_content(coupon_1.percent)
      end

      within "#coupon-#{coupon_2.id}" do
        expect(page).to have_link(coupon_2.name)
        expect(page).to have_content(coupon_2.code)
        expect(page).to have_content(coupon_2.percent)
      end
    end

    it "when I click a link to manage my coupons, I am taken to a coupons index page" do
      bike_shop = create(:merchant)
      merchant_admin = create(:user, role: 2, merchant: bike_shop)
      coupon_1 = bike_shop.coupons.create(name: "25% weekend promo", code: "WKD25", percent: 0.25)
      coupon_2 = bike_shop.coupons.create(name: "50% labor day promo", code: "LABOR50", percent: 0.5)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_admin)

      visit merchant_path

      click_link "Manage Coupons"
      expect(current_path).to eq(merchant_coupons_path)

      within "#coupon-#{coupon_1.id}" do
        expect(page).to have_link(coupon_1.name)
        expect(page).to have_content(coupon_1.code)
        expect(page).to have_content(coupon_1.percent)
      end

      within "#coupon-#{coupon_2.id}" do
        expect(page).to have_link(coupon_2.name)
        expect(page).to have_content(coupon_2.code)
        expect(page).to have_content(coupon_2.percent)
      end
    end
  end
end
