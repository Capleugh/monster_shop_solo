# Monster Shop

## Description
Monster Shop is an e-commerce application in which users can register, login, and fictitiously buy and sell items. Users are differentiated by one of three roles: default user, merchant, or administrator and access to functionality will change depending on these roles.

## Use Monster Shop

### Implementation

#### Access Locally
* Clone this repo with: `git clone git@github.com:DavidBarriga-Gomez/monster_shop_part_1.git`
* Install Ruby 2.4.1
* Install Rails 5.1.7
* Run `$ bundle install`
* Run `$ bundle update`
* Run `$ rails db:setup`
* Seeds are provided but feel free to add your own!
* Note: This application uses the following gems for testing, which are included in the gemfile:
   * `rspec-rails`
   * `capybara`
   * `shoulda-matchers`
   * `factory_bot_rails`

#### Via the Web
[Click Here to Use Our App](https://powerful-castle-36304.herokuapp.com/)

## Authentication
Monster Shop requires authentication of users to log-in to the site. Passwords are encrypted using BCrypt and are not stored in the database.

Upon registration, users are required to create and confirm a password, which is used in conjunction with their email address to log-in. Email addresses must be unique.

From the User model:
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
We implemented `before_action`s and namespacing as part of the authorization to limit functionality to authorized users.

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
We used enums in our User model to differentiate user type. Different types of users have various CRUD functionality, which is described below.

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
* Default users are essentially consumers who are registered and logged in to the site. This type of user is created by a visitor registering for an account.

#### Permissions
* Includes all permissions as a visitor
* Edit profile and password
* Checkout their cart by creating an order
* View all of their orders and the order's individual show page
* Cancel an order that has the status of "pending"

#### Restrictions
* They cannot visit any path starting with "/admin" or "/merchant", attempting will result in a 404 error
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
There are four possible statuses for Orders:
   1. Packaged - all merchants have fulfilled their items for the order and has been packaged and ready to ship
   1. Pending - a user has placed items in a cart and "checked out" to create an order, merchants may or may not have fulfilled any items yet
   1. Shipped - an admin has 'shipped' a package and can no longer be canceled by a user
   1. Canceled - only 'pending' and 'packaged' orders can be canceled

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

![alt text](https://github.com/DavidBarriga-Gomez/monster_shop_part_1/blob/refactor/readme/admin_ship.png "Admin Ship")

The Merchant Order Show page uses a PORO limiting the number of instance variables passed through the controller to one:

```
def show
  order = Order.find(params[:id])
  merchant = current_user
  @merchant_show = MerchantShow.new(order, merchant)
end

-----

class MerchantShow
  attr_reader :order, :merchant

  def initialize(order, merchant)
    @order = order
    @merchant = merchant
  end

```


## Flash Notifications
Flash notifications are used throughout the application to notify users if there is a failed attempt at creating or updating resources.
```
flash[:error] = @item.errors.full_messages.to_sentence
```

## Testing
Monster Shop was developed using Test Driven Development. We used [RSpec](https://github.com/rspec/rspec), with the addition of [Capybara](https://github.com/teamcapybara/capybara) for feature testing and [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers) for model testing. All models were tested at the model level and controllers at the feature level. We also utilized Factory Bot on all models to speed up testing.

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
Utilization in test file:
```
@merchant = create(:merchant)
    @item_1 = create(:item, merchant: @merchant)
    @item_2 = create(:item, merchant: @merchant)
    @merchant_employee = create(:user, role: 1, merchant: @merchant)
    @admin = create(:user, role: 3)
```

## Schema
We used a PostgreSQL for our database. It was composed of 6 separate tables. ActiveRecord was used to join tables, calculate statistics and build collections of data.

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

## Built With
* Ruby on Rails - web framework (version)
* PostgresQL - database manager
* Heorku - cloud platform for app hosting

## Authors:
* [Alison Vermeil](https://github.com/mintona)
* [Carleigh Crockett](https://github.com/Capleugh)
* [David Barriga-Gomez](https://github.com/DavidBarriga-Gomez)
* [Harrison Levin](https://github.com/hale4029)
