require 'rails_helper'

RSpec.describe "As an admin user" do
  describe "when I visit my admin dashboard (/admin)" do
    it "I see all orders in the system sorted by status (packaged, pending, shipped, cancelled) and each order's id, date created, and user who placed the order which links back to the admin view of their profile" do
      admin = create(:user, role: 3)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      user_1 = create(:user, role: 0)
      user_2 = create(:user, role: 0)
      user_3 = create(:user, role: 0)

      order_1 = create(:order, created_at: Date.today, user: user_1, status: 3)
      order_2 = create(:order, created_at: Date.today, user: user_2, status: 1)
      order_3 = create(:order, created_at: Date.today, user: user_3, status: 2)
      order_4 = create(:order, created_at: Date.today, user: user_1, status: 0)

      item_1 = create(:item)
      item_2 = create(:item)
      item_3 = create(:item)
      item_4 = create(:item)
      item_5 = create(:item)

      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      merchant_3 = create(:merchant)

      merchant_1.items << [item_1, item_2]
      merchant_2.items << [item_2, item_3, item_4]
      merchant_3.items << [item_3, item_5]

      merchant_1_employee = create(:user, role: 1, merchant: merchant_1)
      merchant_2_employee = create(:user, role: 1, merchant: merchant_2)
      merchant_3_employee = create(:user, role: 1, merchant: merchant_3)

      order_1.item_orders.create(item: item_1, quantity: 10, price: item_1.price)
      order_1.item_orders.create(item: item_2, quantity: 10, price: item_2.price)
      order_2.item_orders.create(item: item_1, quantity: 10, price: item_1.price)
      order_2.item_orders.create(item: item_3, quantity: 10, price: item_3.price)
      order_3.item_orders.create(item: item_4, quantity: 10, price: item_4.price)
      order_4.item_orders.create(item: item_5, quantity: 10, price: item_5.price)
      order_4.item_orders.create(item: item_3, quantity: 10, price: item_3.price)

      visit admin_path

      within "#order-#{order_1.id}" do
        expect(page).to have_content(order_1.id)
        expect(page).to have_content(order_1.created_at)
        expect(page).to have_content(order_1.status)
        expect(page).to have_link(order_1.user.name)
      end

      within "#order-#{order_2.id}" do
        expect(page).to have_content(order_2.id)
        expect(page).to have_content(order_2.created_at)
        expect(page).to have_content(order_2.status)
        expect(page).to have_link(order_2.user.name)
      end

      within "#order-#{order_3.id}" do
        expect(page).to have_content(order_3.id)
        expect(page).to have_content(order_3.created_at)
        expect(page).to have_content(order_3.status)
        expect(page).to have_link(order_3.user.name)
      end

      within "#order-#{order_4.id}" do
        expect(page).to have_content(order_4.id)
        expect(page).to have_content(order_4.created_at)
        expect(page).to have_content(order_4.status)
        expect(page).to have_link(order_4.user.name)
      end

      within "#all-orders" do

          within "#order-index-0" do
            expect(page).to have_content(order_4.status)
          end

          within "#order-index-1" do
            expect(page).to have_content(order_2.status)
          end

          within "#order-index-2" do
            expect(page).to have_content(order_3.status)
          end

          within "#order-index-3" do
            expect(page).to have_content(order_1.status)
          end
        end

      within "#order-#{order_1.id}" do
        click_link "#{order_1.user.name}"
      end

      expect(current_path).to eq("/admin/users/#{user_1.id}")
    end
  end
end
