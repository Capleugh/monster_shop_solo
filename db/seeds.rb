# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ItemOrder.destroy_all
Order.destroy_all
User.destroy_all
Merchant.destroy_all
Item.destroy_all

#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210, enabled?: false)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
bike = bike_shop.items.create(name: "Specialized Stumpjumper", description: "The best mountain bike ever!", price: 2000, image: "https://cdn11.bigcommerce.com/s-ha7hv3uknh/images/stencil/1280x1280/attribute_rule_images/4207_source_1554059208.jpeg", inventory: 2)
seat = bike_shop.items.create(name: "Bike Seat", description: "Stay comfy!", price: 40, image: "https://cdn.shopify.com/s/files/1/1246/6231/products/bike-seat-comfortable.jpg?v=1521624290", inventory: 8)
jersey = bike_shop.items.create(name: "Jersey", description: "Ladies bike jersey.", price: 80, image: "https://cdn.shopify.com/s/files/1/0185/7770/products/HeavyPedal_OutrunWomensJersey-1_1080x.png?v=1560285903", inventory: 15)
helmet = bike_shop.items.create(name: "Helmet", description: "The hipster-ist helmet there ever was!", price: 95, image: "https://cdn.shopify.com/s/files/1/0836/6919/products/thousand-helmet-rose-gold-1_2000x.jpg?v=1568244140", inventory: 4)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
# pull_toy1 = dog_shop.items.create(name: "Pull Toy1", description: "Great pull toy!", price: 12, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 20)
# pull_toy2 = dog_shop.items.create(name: "Pull Toy2", description: "Great pull toy!", price: 15, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 80)
# pull_toy3 = dog_shop.items.create(name: "Pull Toy3", description: "Great pull toy!", price: 18, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 24)
# pull_toy4 = dog_shop.items.create(name: "Pull Toy4", description: "Great pull toy!", price: 18, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 24)
# pull_toy5 = dog_shop.items.create(name: "Pull Toy5", description: "Great pull toy!", price: 18, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 24)
# pull_toy6 = dog_shop.items.create(name: "Pull Toy6", description: "Great pull toy!", price: 18, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 24)
# pull_toy7 = dog_shop.items.create(name: "Pull Toy7", description: "Great pull toy!", price: 18, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 24)
# pull_toy8 = dog_shop.items.create(name: "Pull Toy8", description: "Great pull toy!", price: 18, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 24)

user = User.create(name: 'user', address: 'user_address', city: 'user_city', state: 'user_state', zip: 12345, email: 'user_email', password: 'p', password_confirmation: 'p', role: 0)
user_2 = User.create(name: 'user', address: 'user_address', city: 'user_city', state: 'user_state', zip: 12345, email: 'user_2_email', password: 'p', password_confirmation: 'p', role: 0)

order_1 = user.orders.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2)
order_1.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 3)
order_1.item_orders.create!(item: dog_bone, price: pull_toy.price, quantity: 5)

order_2 = user_2.orders.create(name: 'Ali', address: '123 Stang Ave', city: 'Hershey', state: 'WI', zip: 54701)
order_2.item_orders.create!(item: tire, price: tire.price, quantity: 5)
order_2.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 4)
order_2.item_orders.create!(item: dog_bone, price: pull_toy.price, quantity: 1)

order_3 = user.orders.create(name: 'David', address: '14251 East 22nd place', city: 'Denver', state: 'Co', zip: 80238)
order_3.item_orders.create!(item: tire, price: tire.price, quantity: 4)
order_3.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 2)
order_3.item_orders.create!(item: dog_bone, price: pull_toy.price, quantity: 6)

order_4 = user.orders.create(name: 'Foxy', address: '14251 East 22nd place', city: 'Denver', state: 'Co', zip: 80238)
order_4.item_orders.create!(item: tire, price: tire.price, quantity: 9)
order_4.item_orders.create!(item: pull_toy, price: pull_toy.price, quantity: 7)
order_4.item_orders.create!(item: dog_bone, price: pull_toy.price, quantity: 8)

merchant_employee = User.create(name: 'merchant_employee', address: 'merchant_employee_address', city: 'merchant_employee_city', state: 'merchant_employee_state', zip: 12345, email: 'merchant_employee_email', password: 'p', password_confirmation: 'p', role: 1, merchant: bike_shop)
merchant_admin = User.create(name: 'merchant_admin', address: 'merchant_admin_address', city: 'merchant_admin_city', state: 'merchant_admin_state', zip: 12345, email: 'merchant_admin_email', password: 'p', password_confirmation: 'p', role: 2, merchant: bike_shop)

merchant_employee_2 = User.create(name: 'merchant_employee_2', address: 'merchant_employee_address', city: 'merchant_employee_city', state: 'merchant_employee_state', zip: 12345, email: 'merchant_employee_email_2', password: 'p', password_confirmation: 'p', role: 1, merchant: dog_shop)
merchant_admin_2 = User.create(name: 'merchant_admin_2', address: 'merchant_admin_address', city: 'merchant_admin_city', state: 'merchant_admin_state', zip: 12345, email: 'merchant_admin_email_2', password: 'p', password_confirmation: 'p', role: 2, merchant: dog_shop)

admin = User.create(name: 'admin', address: 'admin_address', city: 'admin_city', state: 'admin_state', zip: 12345, email: 'admin_email', password: 'p', password_confirmation: 'p', role: 3)
