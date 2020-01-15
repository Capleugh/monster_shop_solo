 require 'rails_helper'

RSpec.describe 'Cart show' do
  describe 'When I have added items to my cart' do
    describe 'and visit my cart path' do
      before(:each) do
        @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
        @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

        @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
        @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
        visit "/items/#{@paper.id}"
        click_on "Add To Cart"
        visit "/items/#{@tire.id}"
        click_on "Add To Cart"
        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"
        @items_in_cart = [@paper,@tire,@pencil]
      end

      it 'I can empty my cart by clicking a link' do
        visit '/cart'
        expect(page).to have_link("Empty Cart")
        click_on "Empty Cart"
        expect(current_path).to eq("/cart")
        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      it 'I see all items Ive added to my cart' do
        visit '/cart'

        @items_in_cart.each do |item|
          within "#cart-item-#{item.id}" do
            expect(page).to have_link(item.name)
            expect(page).to have_css("img[src*='#{item.image}']")
            expect(page).to have_link("#{item.merchant.name}")
            expect(page).to have_content("$#{item.price}")
            expect(page).to have_content("1")
            expect(page).to have_content("$#{item.price}")
          end
        end
        expect(page).to have_content("Total: $122")

        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"

        visit '/cart'

        within "#cart-item-#{@pencil.id}" do
          expect(page).to have_content("2")
          expect(page).to have_content("$4")
        end

        expect(page).to have_content("Total: $124")
      end
    end
  end

  describe "When I haven't added anything to my cart" do
    describe "and visit my cart show page" do
      it "I see a message saying my cart is empty" do
        visit '/cart'
        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      it "I do NOT see the link to empty my cart" do
        visit '/cart'
        expect(page).to_not have_link("Empty Cart")
      end
    end
  end

    describe "i can increment/decrement items" do
      it "increments (only to inventory limit) and decrements to zero" do
        mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
        meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

        tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 10)
        paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
        pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
        visit "/items/#{paper.id}"
        click_on "Add To Cart"
        visit "/items/#{tire.id}"
        click_on "Add To Cart"
        visit "/items/#{pencil.id}"
        click_on "Add To Cart"
        visit '/cart'

        within "#cart-item-#{paper.id}" do
          expect(page).to have_content("1")
          click_button "Increase"
          expect(page).to have_content("2")
          click_button "Increase"
          expect(page).to have_content("3")
          click_button "Increase"
          expect(page).to have_content("3")
          click_button "Decrease"
          expect(page).to have_content("2")
          click_button "Decrease"
          expect(page).to have_content("1")
          click_button "Decrease"
        end
        expect(page).to_not have_css("#cart-item-#{paper.id}")
      end

    describe "show page notifies visitor to log in" do
      it "if not logged in, says you must be logged in to checkout" do
        mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
        meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

        tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 10)
        paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
        pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

        visit "/items/#{paper.id}"
        click_on "Add To Cart"
        visit "/items/#{tire.id}"
        click_on "Add To Cart"
        visit "/items/#{pencil.id}"
        click_on "Add To Cart"
        visit '/cart'
        expect(page).to_not have_link("Checkout")
        expect(page).to have_content("You must register or log in to checkout.")
        expect(page).to have_link('register')
        expect(page).to have_link('log in')

        click_on('register')
        expect(current_path).to eq('/users/register')

        click_on('Cart')
        click_on('log in')
        expect(current_path).to eq('/login')
      end
    end

    describe "show page displays a form with which to add a coupon code as a visitor" do
      it "when I enter that code, it is applied to my cart" do

        bike_shop = create(:merchant)
        doge_shop = create(:merchant)

        tire = create(:item, merchant: bike_shop)
        bike_seat = create(:item, merchant: bike_shop)
        basket = create(:item, merchant: bike_shop)
        bone = create(:item, merchant: doge_shop)
        treats = create(:item, merchant: doge_shop)


        coupon_1 = bike_shop.coupons.create(name: "25% weekend promo", code: "WKD25", percent: 0.25)
        coupon_2 = doge_shop.coupons.create(name: "50% labor day promo", code: "LABOR50", percent: 0.5)
        coupon_3 = bike_shop.coupons.create(name: "40% weekend promo", code: "WKD40", percent: 0.40)


        visit "/items/#{tire.id}"
        click_on "Add To Cart"
        visit "/items/#{bike_seat.id}"
        click_on "Add To Cart"
        visit "/items/#{basket.id}"
        click_on "Add To Cart"


        visit '/cart'

        fill_in :coupon_code, with: 'WKD25'

        click_button 'Submit'

        expect(current_path).to eq("/cart")

        expect(page).to have_content("Coupon has been applied to #{bike_shop.name}'s items.")
      end
    end

    describe "show page displays a form with which to add a coupon code as a user" do
      it "when I enter that code, it is applied to my cart" do
        user = create(:user, role: 0)

        bike_shop = create(:merchant)

        tire = create(:item, merchant: bike_shop)
        bike_seat = create(:item, merchant: bike_shop)
        basket = create(:item, merchant: bike_shop)

        bike_shop.coupons.create(name: "25% weekend promo", code: "WKD25", percent: 0.25)
        bike_shop.coupons.create(name: "40% weekend promo", code: "WKD40", percent: 0.40)


        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

        visit "/items/#{tire.id}"
        click_on "Add To Cart"
        visit "/items/#{bike_seat.id}"
        click_on "Add To Cart"
        visit "/items/#{basket.id}"
        click_on "Add To Cart"


        visit '/cart'

        fill_in :coupon_code, with: 'WKD25'

        click_button 'Submit'

        expect(current_path).to eq("/cart")

        expect(page).to have_content("Coupon has been applied to #{bike_shop.name}'s items.")

    # why is rspec weird? it works in rails
        # visit "/items/#{bike_seat.id}"
        # click_on "Add To Cart"
        # visit "/items/#{basket.id}"
        # click_on "Add To Cart"
        #

        fill_in :coupon_code, with: 'WKD40'

        click_button 'Submit'

        expect(current_path).to eq("/cart")

        expect(page).to have_content("Coupon has been applied to #{bike_shop.name}'s items.")
      end

      it "when a coupon code which doesn't exist is entered, I see an error message" do
        user = create(:user, role: 0)

        bike_shop = create(:merchant)

        tire = create(:item, merchant: bike_shop)
        bike_seat = create(:item, merchant: bike_shop)
        basket = create(:item, merchant: bike_shop)


        bike_shop.coupons.create(name: "25% weekend promo", code: "WKD25", percent: 0.25)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

        visit "/items/#{tire.id}"
        click_on "Add To Cart"
        visit "/items/#{bike_seat.id}"
        click_on "Add To Cart"
        visit "/items/#{basket.id}"
        click_on "Add To Cart"

        visit '/cart'

        fill_in :coupon_code, with: 'CODE78'

        click_button 'Submit'

        expect(page).to have_content("Please enter a valid coupon")
      end

      it "coupon only applies to items belonging to merchant that coupon belongs to and I see the discounted total" do
        user = create(:user, role: 0)

        bike_shop = create(:merchant)
        doge_shop = create(:merchant)

        tire = create(:item, merchant: bike_shop)
        bike_seat = create(:item, merchant: bike_shop)
        basket = create(:item, merchant: bike_shop)
        bone = create(:item, merchant: doge_shop)
        treats = create(:item, merchant: doge_shop)

        coupon_1 = bike_shop.coupons.create(name: "25% weekend promo", code: "WKD25", percent: 0.25)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

        visit "/items/#{tire.id}"
        click_on "Add To Cart"
        visit "/items/#{bike_seat.id}"
        click_on "Add To Cart"
        visit "/items/#{basket.id}"
        click_on "Add To Cart"
        visit "/items/#{bone.id}"
        click_on "Add To Cart"
        visit "/items/#{treats.id}"
        click_on "Add To Cart"

        visit '/cart'

        fill_in :coupon_code, with: 'WKD25'

        click_button 'Submit'

        expect(current_path).to eq("/cart")

        expect(page).to have_content("Coupon has been applied to #{bike_shop.name}'s items.")
        expect(page).to have_content("#{coupon_1.code} discount applied.")

        expect(page).to have_content("Total: $270")
        expect(page).to have_content("Discounted Total: $230.25")
        # factory bot has been weird...
      end
    end
  end
end
