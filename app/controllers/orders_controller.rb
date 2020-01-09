class OrdersController <ApplicationController

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
      order.item_orders.change_status_to_unfulfilled
      reset_inventory(order)
      change_order_status_to_cancelled(order)
    else
      flash[:error] = "Unable to cancel order."
      redirect_back(fallback_location: profile_path)
    end
  end

  def update
    order = Order.find(params[:id])
    order.status = 'shipped'
    order.save
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

    def reset_inventory(order)
      order.items.each do |item|
        quantity = item.quantity_ordered(order)
        item.increase_item_inventory(quantity)
      end
    end
end
