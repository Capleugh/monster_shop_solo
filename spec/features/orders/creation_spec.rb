RSpec.describe("Order Creation") do
  describe "When I check out from my cart" do
    it 'I can create a new order (AND TEST INVENTORY LEVEL)' do
      mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      user = User.create(name: 'user', address: 'user_address', city: 'user_city', state: 'user_state', zip: 12345, email: 'user_email_test', password: 'pp', password_confirmation: 'pp', role: 0)

      expect(Item.find(paper.id).inventory).to eq(3)
      expect(Item.find(tire.id).inventory).to eq(12)

      visit '/'
      click_link('Login')
      expect(current_path).to eq('/login')
      fill_in :email, with: user.email
      fill_in :password, with: 'pp'
      click_on('Submit')


      visit "/items/#{paper.id}"
      click_on "Add To Cart"
      visit "/items/#{paper.id}"
      click_on "Add To Cart"
      visit "/items/#{tire.id}"
      click_on "Add To Cart"
      visit "/items/#{pencil.id}"
      click_on "Add To Cart"

      visit "/cart"

      click_on "Checkout"

      name = "Bert"
      address = "123 Sesame St."
      city = "NYC"
      state = "New York"
      zip = 10001

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip

      click_button "Create Order"

      expect(current_path).to eq("/profile/orders")

      expect(page).to have_content("Order created!")
    end

    it 'I can create a new order and see order info on order show page' do
      mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      user = User.create(name: 'user', address: 'user_address', city: 'user_city', state: 'user_state', zip: 12345, email: 'user_email_test', password: 'pp', password_confirmation: 'pp', role: 0)
      visit '/'
      click_link('Login')
      expect(current_path).to eq('/login')
      fill_in :email, with: user.email
      fill_in :password, with: 'pp'
      click_on('Submit')

      visit "/items/#{paper.id}"
      click_on "Add To Cart"
      visit "/items/#{paper.id}"
      click_on "Add To Cart"
      visit "/items/#{tire.id}"
      click_on "Add To Cart"
      visit "/items/#{pencil.id}"
      click_on "Add To Cart"

      visit "/cart"
      click_on "Checkout"

      name = "Bert"
      address = "123 Sesame St."
      city = "NYC"
      state = "New York"
      zip = 10001

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip

      click_button "Create Order"

      new_order = Order.last

      visit "/profile/orders/#{new_order.id}"

      within "#item-#{paper.id}" do
        expect(page).to have_link(paper.name)
        expect(page).to have_link("#{paper.merchant.name}")
        expect(page).to have_content("$#{paper.price}")
        expect(page).to have_content("2")
        expect(page).to have_content("$40")
      end

      within "#item-#{tire.id}" do
        expect(page).to have_link(tire.name)
        expect(page).to have_link("#{tire.merchant.name}")
        expect(page).to have_content("$#{tire.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$100")
      end

      within "#item-#{pencil.id}" do
        expect(page).to have_link(pencil.name)
        expect(page).to have_link("#{pencil.merchant.name}")
        expect(page).to have_content("$#{pencil.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$2")
      end

      within "#grandtotal" do
        expect(page).to have_content("Total: $142")
      end
    end

    it 'i cant create order if info not filled out' do
      mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      user = User.create(name: 'user', address: 'user_address', city: 'user_city', state: 'user_state', zip: 12345, email: 'user_email_test', password: 'pp', password_confirmation: 'pp', role: 0)
      visit '/'
      click_link('Login')
      expect(current_path).to eq('/login')
      fill_in :email, with: user.email
      fill_in :password, with: 'pp'
      click_on('Submit')

      visit "/items/#{paper.id}"
      click_on "Add To Cart"
      visit "/items/#{paper.id}"
      click_on "Add To Cart"
      visit "/items/#{tire.id}"
      click_on "Add To Cart"
      visit "/items/#{pencil.id}"
      click_on "Add To Cart"

      visit "/cart"
      click_on "Checkout"

      name = ""
      address = "123 Sesame St."
      city = "NYC"
      state = "New York"
      zip = 10001

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip

      click_button "Create Order"

      expect(page).to have_content("Please complete address form to create an order.")
      expect(page).to have_button("Create Order")
    end
  end
end
