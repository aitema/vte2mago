class OrderItemRequestsController < ApplicationController
  before_action :set_order_item_request, only: [:show, :edit, :update, :destroy]

  # GET /order_item_requests
  # GET /order_item_requests.json
  def index
    @order_item_requests = OrderItemRequest.all
  end

  # GET /order_item_requests/1
  # GET /order_item_requests/1.json
  def show
  end

  # GET /order_item_requests/new
  def new
    @order_item_request = OrderItemRequest.new
  end

  # GET /order_item_requests/1/edit
  def edit
  end

  # POST /order_item_requests
  # POST /order_item_requests.json
  def create
    @order_item_request = OrderItemRequest.new(order_item_request_params)


    if @order_item_request.save


    end





     # respond_to do |format|
     #   format.html { redirect_to @order_item_request, notice: 'Order item request was successfully created.' }
     #   format.json { render :show, status: :created, location: @order_item_request }
     # else
     #   format.html { render :new }
     #   format.json { render json: @order_item_request.errors, status: :unprocessable_entity }
     # end
     #end
  end

  # PATCH/PUT /order_item_requests/1
  # PATCH/PUT /order_item_requests/1.json
  def update
    respond_to do |format|
      if @order_item_request.update(order_item_request_params)
        format.html { redirect_to @order_item_request, notice: 'Order item request was successfully updated.' }
        format.json { render :show, status: :ok, location: @order_item_request }
      else
        format.html { render :edit }
        format.json { render json: @order_item_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /order_item_requests/1
  # DELETE /order_item_requests/1.json
  def destroy
    @order_item_request.destroy
    respond_to do |format|
      format.html { redirect_to order_item_requests_url, notice: 'Order item request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order_item_request
      @order_item_request = OrderItemRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_item_request_params
      params[:order_item_request]
    end
end
