class OrdersController < ApplicationController
  before_filter :find_order, :only => [:show, :edit]

  def index
    @orders = Order.all
  end

  def show
  end

  def edit
  end

  def update
    if not @order.update_attributes params[:order]
      render :edit
    else
      notice_updated
      redirect_to orders_path
    end
  end

  def new
  end

  def create
    @order = Order.new
    @order.date_operation = Time.now
    @order.order_state_id = 1
    @order.human_id = params[:human_id]
    @order.period_id = params[:period_id]
#    i = 0
    params[:debt].each do |d|
      oi = OrderItem.new
      oi.bankbook_utility_id = d["id_bankbook_utility"] 
      oi.amount = d["sum_month"]
      oi.start_date = Time.now
      oi.end_date = Time.now
      @order.order_items << oi
#      i += 1
    end
#      @order.add_lines_from_debts(params[:debt])
    if not @order.save
      render :new
    else
      notice_created
      redirect_to orders_path
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_path
  end
  
  private

  def find_order
    @order = Order.find params[:id]
  end
  
#  def find_payer
#    @payer = Human.find params[:id]
#  end
end
