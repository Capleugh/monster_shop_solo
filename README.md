Documentation
4: Final project has a well written README with pictures, schema design, code snippets, contributors names linked to their github profile, heroku link, and implementation instructions.

3: Passing Students have a README with thorough implementation instructions and description of content.

# Monster Shop

## Description
Monster Shop is an ecommerce application in which users can register, login, and ficticiously buy and sell items. Users are differentiated by one of three roles: default user (consumer), merchant, or administrator and access to functionality will change depending on these roles.

write me!

## Use Monster Shop
### Via the Web
[Click Here to Use Our App](https://powerful-castle-36304.herokuapp.com/)
### Access Locally
* Clone this repo with: `git clone git@github.com:DavidBarriga-Gomez/monster_shop_part_1.git`
* Install Ruby 2.4.1
* Install Rails 5.1.7
* gems for testing (rspec, etc.)
* Run `$ bundle install`
* Run `$ bundle update`
* Run `$ rails db:setup`
* Seeds are provided but feel free to add your own!
* Note: This application uses the following gems for testing, which are included in the gemfile: 
   * `rspec-rails`
   * `capybara`
   * `shoulda-matchers`
   * `factory_bot_rails`

## Authentication
Monster Shop requires authentication of users to log-in to the site. Passwords are encrypted using BCrypt. 

Upon registration, users are required to create and confirm a password, which is used in conjunction with their email address to log-in. Email address must be unique.

```
  validates :email, uniqueness: true, presence: true
  validates_presence_of :password, require: true

  has_secure_password
```

Proper credentials are required to log-in. Flash messages are utilized to alert the user if they attempt to login with incorrect credentials.

![alt text](https://github.com/DavidBarriga-Gomez/monster_shop_part_1/blob/refactor/readme/Screen%20Shot%202020-01-09%20at%2011.54.18%20AM.png)

The use of sessions allows the storage of user information as they navigate the site via a `current_user` method in the Application Controller.

```
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
```

## Authorization
We implemented `before_action`s and namespacing as part of the authorization limit functionality to authorized users
``` 
  namespace :merchant  do
    get '/', to: 'dashboard#show'
    resources :orders, only: [:show, :update]
    resources :items, only: [:index, :show, :update, :destroy, :new, :create, :edit]
  end

  namespace :admin do
    get '/', to: 'dashboard#index'
    resources :users, only: [:index, :show] do
      resources :orders, only: [:show]
    end
    resources :merchants, only: [:index, :show, :update] do
      resources :items, only: [:index, :new, :create, :edit, :update, :destroy]
    end
  end
```

```
  class Admin::BaseController < ApplicationController
    before_action :require_admin

    def require_admin
      render file: "/public/404" unless current_admin?
    end
  end
```
  
Namespacing also necessitated the use of nested `form_for` partials for new and edit views of nested resources.
```
<%= form_for([@merchant, @item]) do |f| %>
  <%= f.label :name %>
  <%= f.text_field :name%>

  <%= f.label :description %>
  <%= f.text_field :description %>

  <%= f.label :price %>
  <%= f.text_field :price %>

  <%= f.label :image %>
  <%= f.text_field :image %>

  <%= f.label :inventory %>
  <%= f.text_field :inventory %>

  <%= f.submit "Submit"  %>
<% end %>
```

## User Roles
We used enums in our User model to differentiate user type. Different types of users have various CRUD functionality.
```   enum role: ['default', 'merchant_employee', 'merchant_admin', 'admin'] ```


### Visitors 
* Visitors are users browsing the site who are not logged in as a registered user.

#### Permissions
* Browse the site to see all merchants and all active items 
* Visit individual show pages for merchants and items
* Add and remove items from their cart

#### Restrictions
* Must register and log in before given access to checking out their cart
* A flash message provides links to register and login pages
![alt text](https://github.com/DavidBarriga-Gomez/monster_shop_part_1/blob/refactor/readme/visitor_checkout.png)

### Default Users
* Default users are essentially consumers who are registered and logged in to the site.

#### Permissions
* Includes all permissions as a visitor
* Edit profile and password
* Checkout their cart by creating an order
* View all of their orders and the order's individual show page
* Cancel an order that has the status of "pending"

#### Restrictions
* They cannot visit any path starting with "/admin" or "/merchant"
* They cannot add or update merchants or items

### Merchant Employees
* Users who are assigned a merchant to work for

#### Permissions
* Includes all permissions as default user
* Add and update items to their shop
* Enable and disable items in their shop
* Delete items that have never been ordered
* Fulfill items from their shop in a consumer's order (the last item to be fulfilled updates the order status to "packaged")

#### Restrictions
* They cannot visit any path starting with "/admin"
* They cannot edit the details of the store they work at
* They cannot edit a user's information, password, or cancel an order

### Admin
* Admins have the most permissions of any user and can perform nearly all actions on behalf of a default user or merchant employee.

#### Permissions
* Enable and disable merchants
* Ship an order that is "packaged"
* Manage items on behalf of a merchant, ex: `/admin/merchant/1/items/3`
* Access to an admin specific index and show pages for users, `/admin/users`
* Access to an admin specific index and show pages for merchants
* Access admin specific show pages for users orders, ex: `/admin/users/5/orders/15`

#### Restrictions
* They cannot visit any path starting with "/merchant"
* They cannot edit a user's information

Admins have the most ability of any user. They can enable and disable merchants, cancel orders on behalf of a user, and ship orders. They do not have access to a cart or ordering items for themselves.

## Orders
There are four possbile statuses for Orders: 
   1. Packaged - all merchants have fulfilled their items for the order, and has been packaged and ready to ship
   1. Pending - a user has placed items in a cart and "checked out" to create an order, merchants may or may not have fulfilled any items yet
   1. Shipped - an admin has 'shipped' a package and can no longer be cancelled by a user
   1. Cancelled - only 'pending' and 'packaged' orders can be cancelled
   
Orders are created with a status of "pending" by default.

Orders are designated via an enum in the model.
```  enum status: [:packaged, :pending, :shipped, :cancelled]```


When a merchant fulfills the last item in an order, that action changes an order's status from "pending" to "packaged" via the update action in the Merchant Orders Controller.

```
  order = Order.find(params[:id])
    if order.all_items_fulfilled?
      order.update_order_status_to_packaged
    end
```

Only an admin has the ability to ship an order and only once that order has a status of "packaged".
# pic here 

## Built With
* Ruby on Rails - web framework (version)
* PostgresQL - database manager
* Heorku - cloud platform for app hosting


## Testing
Monster Shop was developed using Test Driven Development. We used RSpec, with the addition of Capybara and Shoulda Matchers. All models were tested at the model level and controllers at the feature level. We also utilized Factory Bot on all models to speed up testing.

Factory Bot Merchant Example:
```
FactoryBot.define do
  factory :item do
    sequence(:name) { |n| "Toy #{n}"}
    description { "Great pull toy!" }
    sequence(:price, 5) { |n| "#{n}" }
    image {"http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg" }
    sequence(:inventory, 7 ) { |n| "#{n}" }
    merchant
  end
end
```

* Rspec
* Cabybara
* Launchy



## Schema 
We used a PostgreSQL for out database. It was composed of 6 separate tables. ActiveRecord was used to join tables, calculate statistics and build collections of data. 

```
  def self.top_five_items
    select("items.*, sum(quantity)").where(active?: true).joins(:item_orders).group(:id).order("sum desc").limit(5)
  end

  def self.bottom_five_items
    select("items.*, sum(quantity)").where(active?: true).joins(:item_orders).group(:id).order("sum").limit(5)
  end
```

The schema is depicted below:
![alt text](https://github.com/DavidBarriga-Gomez/monster_shop_part_1/blob/refactor/readme/Monster%20Shop%20DB%20Schema.png "Monster Shop Schema") 

## Authors:
* [Alison Vermeil](https://github.com/mintona)
* [Carleigh Crockett](https://github.com/Capleugh)
* [David Barriga-Gomez](https://github.com/DavidBarriga-Gomez)
* [Harrison Levin](https://github.com/hale4029)



## Order Status

1. 'pending' means a user has placed items in a cart and "checked out" to create an order, merchants may or may not have fulfilled any items yet
2. 'packaged' means all merchants have fulfilled their items for the order, and has been packaged and ready to ship
3. 'shipped' means an admin has 'shipped' a package and can no longer be cancelled by a user
4. 'cancelled' - only 'pending' and 'packaged' orders can be cancelled

## Timeframe
The following is an anticipated timeline of how these stories should be completed in order to be finished by 12/23/19

* Monday: Story 1 && Story 10 - Story 12
* Tuesday: Story 13 - Story 16
* Wednesday: Story 2 - Story 9
* Thursday: Story 17 - Story 22
* Friday: Story 23 - Story 26
* Saturday: Story 27 - Story 30
* Sunday: Story 31 - Story 33
* Monday: Story 34 - Story 37


## Not Everything can be FULLY Deleted

In the user stories, we talk about "CRUD" functionality. However, it's rare in a real production system to ever truly delete content, and instead we typically just 'enable' or 'disable' content. Users, items and orders can be 'enabled' or 'disabled' which blocks functionality (users whose accounts are disabled should not be allowed to log in, items which are disabled cannot be ordered, orders which are disabled cannot be processed, and so on).

Disabled content should also be restricted from showing up in the statistics pages. For example: if an item is disabled, it should not appear in a list of "popular items".

Be careful to watch out for which stories allow full deletion of content, and restrictions on when they apply.

## Deploying to Heroku

```
[ ] done

User Story 1, Deploy your application to Heroku

As a visitor or user of the site
I will perform all user stories
By visiting the application on Heroku.
Localhost is fine for development, but
the application must be hosted on Heroku.
```

---

## Navigation
This series of stories will set up a navigation bar at the top of the screen and present links and information to users of your site.

There is no requirement that the nav bar be "locked" to the top of the screen.

### Completion of these stories will encompass the following ideas:

- the navigation is built into app/views/layouts/application.html.erb or loaded into that file as a partial
- you write a single set of tests that simply click on a link and expect that your current path is what you expect to see
- your nav tests don't need to check any content on the pages, just that current_path is what you expect

You will need to set up some basic routing and empty controller actions and empty action view files.


```
[ ] done

User Story 2, Visitor Navigation

As a visitor
I see a navigation bar
This navigation bar includes links for the following:
- a link to return to the welcome / home page of the application ("/")
- a link to browse all items for sale ("/items")
- a link to see all merchants ("/merchants")
- a link to my shopping cart ("/cart")
- a link to log in ("/login")
- a link to the user registration page ("/register")

Next to the shopping cart link I see a count of the items in my cart
```

```
[ ] done

User Story 3, User Navigation

As a registered regular user
I see the same links as a visitor
Plus the following links
- a link to my profile page ("/profile")
- a link to log out ("/logout")

Minus the following links
- I do not see a link to log in or register

I also see text that says "Logged in as Mike Dao" (or whatever my name is)
```

```
[ ] done

User Story 4, Merchant Navigation

As any type of merchant
I see the same links as a regular user
Plus the following links:
- a link to my merchant dashboard ("/merchant")
```

```
[ ] done

User Story 5, Admin Navigation

As an admin
I see the same links as a regular user
Plus the following links
- a link to my admin dashboard ("/admin")
- a link to see all users ("/admin/users")

Minus the following links/info
- a link to my shopping cart ("/cart") or count of cart items
```

```
[ ] done

User Story 6, Visitor Navigation Restrictions

As a Visitor
When I try to access any path that begins with the following, then I see a 404 error:
- '/merchant'
- '/admin'
- '/profile'
```

```
[ ] done

User Story 7, User Navigation Restrictions

As a User
When I try to access any path that begins with the following, then I see a 404 error:
- '/merchant'
- '/admin'
```

```
[ ] done

User Story 8, Merchant Navigation Restrictions

As any type of merchant
When I try to access any path that begins with the following, then I see a 404 error:
- '/admin'
```

```
[ ] done

User Story 9, Admin Navigation Restrictions

As an Admin
When I try to access any path that begins with the following, then I see a 404 error:
- '/merchant'
- '/cart'
```

---

## User Registration
This series of stories will allow a user to register on the site.


```
[ ] done

User Story 10, User Registration

As a visitor
When I click on the 'register' link in the nav bar
Then I am on the user registration page ('/register')
And I see a form where I input the following data:
- my name
- my street address
- my city
- my state
- my zip code
- my email address
- my preferred password
- a confirmation field for my password

When I fill in this form completely,
And with a unique email address not already in the system
My details are saved in the database
Then I am logged in as a registered user
I am taken to my profile page ("/profile")
I see a flash message indicating that I am now registered and logged in
```

```
[ ] done

User Story 11, User Registration Missing Details

As a visitor
When I visit the user registration page
And I do not fill in this form completely,
I am returned to the registration page
And I see a flash message indicating that I am missing required fields
```

```
[ ] done

User Story 12, Registration Email must be unique

As a visitor
When I visit the user registration page
If I fill out the registration form
But include an email address already in the system
Then I am returned to the registration page
My details are not saved and I am not logged in
The form is filled in with all previous data except the email field and password fields
I see a flash message telling me the email address is already in use
```

---

## Login / Logout
Our application wouldn't be much use if users could not log in to use it.


```
[ ] done

User Story 13, User can Login

As a visitor
When I visit the login path
I see a field to enter my email address and password
When I submit valid information
If I am a regular user, I am redirected to my profile page
If I am a merchant user, I am redirected to my merchant dashboard page
If I am an admin user, I am redirected to my admin dashboard page
And I see a flash message that I am logged in
```

```
[ ] done

User Story 14, User cannot log in with bad credentials

As a visitor
When I visit the login page ("/login")
And I submit invalid information
Then I am redirected to the login page
And I see a flash message that tells me that my credentials were incorrect
I am NOT told whether it was my email or password that was incorrect
```

```
[ ] done

User Story 15, Users who are logged in already are redirected

As a registered user, merchant, or admin
When I visit the login path
If I am a regular user, I am redirected to my profile page
If I am a merchant user, I am redirected to my merchant dashboard page
If I am an admin user, I am redirected to my admin dashboard page
And I see a flash message that tells me I am already logged in
```

```
[ ] done

User Story 16, User can log out

As a registered user, merchant, or admin
When I visit the logout path
I am redirected to the welcome / home page of the site
And I see a flash message that indicates I am logged out
Any items I had in my shopping cart are deleted
```

---

## Items
This is the main "catalog" page of the entire site where users will start their e-commerce experience. Visitors to the site, and regular users, will be able to view an index page of all items available for purchase and some basic statistics. Each item will also have a "show" page where more information is shown.

```
[ ] done

User Story 17, Items Index Page

As any kind of user on the system
I can visit the items catalog ("/items")
I see all items in the system except disabled items

The item image is a link to that item's show page
```

```
[ ] done

User Story 18, Items Index Page Statistics

As any kind of user on the system
When I visit the items index page ("/items")
I see an area with statistics:
- the top 5 most popular items by quantity purchased, plus the quantity bought
- the bottom 5 least popular items, plus the quantity bought

"Popularity" is determined by total quantity of that item ordered
```

---

## User Profile Page
When a user who is not a merchant nor an admin logs into the system, they are taken to a profile page under a route of "/profile".

### Admins can act on behalf of users
Admin users can access a namespaced route of "/admin/users" to see an index page  of all non-merchant/non-admin users, and from there see each user. This will allow the admin to perform every action on a user's account that the user themselves can perform. Admin users can also "upgrade" a user account to become a merchant account.

```
[ ] done

User Story 19, User Profile Show Page

As a registered user
When I visit my profile page
Then I see all of my profile data on the page except my password
And I see a link to edit my profile data
```

```
[ ] done

User Story 20, User Can Edit their Profile Data

As a registered user
When I visit my profile page
I see a link to edit my profile data
When I click on the link to edit my profile data
I see a form like the registration page
The form is prepopulated with all my current information except my password
When I change any or all of that information
And I submit the form
Then I am returned to my profile page
And I see a flash message telling me that my data is updated
And I see my updated information
```

```
[ ] done

User Story 21, User Can Edit their Password

As a registered user
When I visit my profile page
I see a link to edit my password
When I click on the link to edit my password
I see a form with fields for a new password, and a new password confirmation
When I fill in the same password in both fields
And I submit the form
Then I am returned to my profile page
And I see a flash message telling me that my password is updated
```

```
[ ] done

User Story 22, User Editing Profile Data must have unique Email address

As a registered user
When I attempt to edit my profile data
If I try to change my email address to one that belongs to another user
When I submit the form
Then I am returned to the profile edit page
And I see a flash message telling me that email address is already in use
```

---

## Shopping Cart and Checkout
This is what this app is all about: how a user can put things in a shopping cart and check out, creating an order in the process. We want to add functionality to the cart to increment and decrement the quantity within the cart.

### Visitors and Regular Users only
Merchants and Admin users cannot order items. This will cause a conflict in the project if an admin upgrades a user to a merchant and that user had previous orders of their own. We're not going to worry about this conflict.

```
[ ] done

User Story 23, Adding Item Quantity to Cart

As a visitor
When I have items in my cart
And I visit my cart
Next to each item in my cart
I see a button or link to increment the count of items I want to purchase
I cannot increment the count beyond the item's inventory size
```

```
[ ] done

User Story 24, Decreasing Item Quantity from Cart

As a visitor
When I have items in my cart
And I visit my cart
Next to each item in my cart
I see a button or link to decrement the count of items I want to purchase
If I decrement the count to 0 the item is immediately removed from my cart
```

```
[ ] done

User Story 25, Visitors must register or log in to check out

As a visitor
When I have items in my cart
And I visit my cart
I see information telling me I must register or log in to finish the checkout process
The word "register" is a link to the registration page
The words "log in" is a link to the login page
```

```
[ ] done

User Story 26, Registered users can check out

As a registered user
When I add items to my cart
And I visit my cart
I see a button or link indicating that I can check out
And I click the button or link to check out
An order is created in the system, which has a status of "pending"
That order is associated with my user
I am taken to my orders page ("/profile/orders")
I see a flash message telling me my order was created
I see my new order listed on my profile orders page
My cart is now empty
```

---

## User Order Show Page
The show page template for an order can be shared between users, merchants and admins to DRY up our presentation logic. They will operate through separate controllers, though.

### User Control
- Users can cancel an order if an admin has not "shipped" that order
- When an order is cancelled, any fulfilled items have their inventory returned to their respective merchants

### Merchant Control
- Merchants only see items in the order that are sold by that merchant
- Items from other merchants are hidden

### Admin Control
- Admins can cancel an order on behalf of a user
- Admins can fulfill items on order on behalf of a merchant

```
[ ] done

User Story 27, User Profile displays Orders link

As a registered user
When I visit my Profile page
And I have orders placed in the system
Then I see a link on my profile page called "My Orders"
When I click this link my URI path is "/profile/orders"
```

```
[ ] done

User Story 28, User Profile displays Orders

As a registered user
When I visit my Profile Orders page, "/profile/orders"
I see every order I've made, which includes the following information:
- the ID of the order, which is a link to the order show page
- the date the order was made
- the date the order was last updated
- the current status of the order
- the total quantity of items in the order
- the grand total of all items for that order
```

```
[ ] done

User Story 29, User views an Order Show Page

As a registered user
When I visit my Profile Orders page
And I click on a link for order's show page
My URL route is now something like "/profile/orders/15"
I see all information about the order, including the following information:
- the ID of the order
- the date the order was made
- the date the order was last updated
- the current status of the order
- each item I ordered, including name, description, thumbnail, quantity, price and subtotal
- the total quantity of items in the whole order
- the grand total of all items for that order
```

```
[ ] done

User Story 30, User cancels an order

As a registered user
When I visit an order's show page
I see a button or link to cancel the order only if the order is still pending
When I click the cancel button for an order, the following happens:
- Each row in the "order items" table is given a status of "unfulfilled"
- The order itself is given a status of "cancelled"
- Any item quantities in the order that were previously fulfilled have their quantities returned to their respective merchant's inventory for that item.
- I am returned to my profile page
- I see a flash message telling me the order is now cancelled
- And I see that this order now has an updated status of "cancelled"
```

```
[ ] done

User Story 31, All Merchants fulfill items on an order

When all items in an order have been "fulfilled" by their merchants
The order status changes from "pending" to "packaged"
```

```
[ ] done

User Story 32, Admin can see all orders

As an admin user
When I visit my admin dashboard ("/admin")
Then I see all orders in the system.
For each order I see the following information:

- user who placed the order, which links to admin view of user profile
- order id
- date the order was created

Orders are sorted by "status" in this order:

- packaged
- pending
- shipped
- cancelled
```

```
[ ] done

User Story 33, Admin can "ship" an order

As an admin user
When I log into my dashboard, "/admin/dashboard"
Then I see any "packaged" orders ready to ship.
Next to each order I see a button to "ship" the order.
When I click that button for an order, the status of that order changes to "shipped"
And the user can no longer "cancel" the order.
```

---

## Merchant Dashboard
This is the landing page when a merchant logs in. Here, they will see their contact information (but cannot change it), some statistics, and a list of pending orders that require the merchant's attention.

### Admins can act on behalf of merchants
Admin users will see more information on the "/merchants" route that all users see. For example, on this page, an admin user can navigate to each merchant's dashboard under a route like "/admin/merchants/7". This will allow the admin to perform every action that the merchant themselves can perform. Admin users can also "downgrade" a merchant account to become a user account.

```
[ ] done

User Story 34, Merchant Dashboard Show Page

As a merchant employee or admin
When I visit my merchant dashboard ("/merchant")
I see the name and full address of the merchant I work for
```

```
[ ] done

User Story 35, Merchant Dashboard displays Orders

As a merchant
When I visit my merchant dashboard ("/merchant")
If any users have pending orders containing items I sell
Then I see a list of these orders.
Each order listed includes the following information:
- the ID of the order, which is a link to the order show page ("/merchant/orders/15")
- the date the order was made
- the total quantity of my items in the order
- the total value of my items for that order
```

```
[ ] done

User Story 36, Merchant's Items index page

As a merchant
When I visit my merchant dashboard
I see a link to view my own items
When I click that link
My URI route should be "/merchant/items"
```

```
[ ] done

User Story 37, Admin can see a merchant's dashboard

As an admin user
When I visit the merchant index page ("/merchants")
And I click on a merchant's name,
Then my URI route should be ("/admin/merchants/6")
Then I see everything that merchant would see
```

