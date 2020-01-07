class OrdersController <ApplicationController
  before_action :order_status_monitor

  def index
  end

  def new
    @user = current_user
  end

  def show
    @order = Order.find(params[:order_id])
  end

  def create
    order = current_user.orders.create(order_params)
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      #Item.decrease_item_inventory(cart)
      session.delete(:cart)
      flash[:success] = "Order created!"
      redirect_to "/profile/orders"
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  def destroy
    order = Order.find(params[:order_id])
    if order.status == 'pending'
      ItemOrder.change_items_status_to_unfilled(order)
      Item.increase_item_inventory(order)
      change_order_status_to_cancelled(order)
    else
      flash[:error] = "Unable to cancel order."
      redirect_back(fallback_location: profile_path)
    end
  end

  def update
    # binding.pry
    order = Order.find(params[:id])
    order.status = 'shipped'
    order.save
    # order.update(update_status)
    redirect_to '/admin'
  end


  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end

  def change_order_status_to_cancelled(order)
    order.update(status: 3)
    flash[:success] = "#{order.id} has been cancelled."
    redirect_to profile_path
  end

  def order_status_monitor
    Order.update_order_status_to_packaged
  end

 #  def update_status
 #   params.permit(:status)
 # end
end
