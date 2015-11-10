class OrderRequestsController < ApplicationController
  before_action :set_order_request, only: [:show, :edit, :update, :destroy]
  protect_from_forgery :except => :create

  # GET /order_requests
  # GET /order_requests.json
  def index
    @order_requests = OrderRequest.all
  end


  def show
  end

  def new
    @order_request = OrderRequest.new
  end

  def edit
  end

  def mago_login
    k = OrderRequest.new
    @result = k.login
    @token = k.token
    k.logout
  end



  def create

    #puts params.inspect
    order = params.except('controller','action')
    #puts order.keys
    items = order.except('numero','soggetto','totale_documento','descrizione','codice_esterno','numero_cliente','data_ordine_cliente','numero_offerta')
    #puts items.inspect


    # 1. Creazione ordine
    @order_request = OrderRequest.new(
        :numero => params[:numero],
        :soggetto => params[:soggetto],
        :totale_documento => params[:totale_documento],
        :descrizione => params[:descrizione],
        :codice_esterno => params[:codice_esterno],
        :numero_cliente => params[:numero_cliente],
        :data_ordine_cliente => params[:data_ordine_cliente],
        :numero_offerta => params[:numero_offerta]
    )

    # 2. Creazione dettaglio ordine
    items.each do |item|
      puts "---------"
      puts item.inspect
      puts item[1]["numero_prodotto"]
      @order_request.order_item_requests.new(
          :numero_prodotto => item[1]["numero_prodotto"],
          :nome_prodotto => item[1]["nome_prodotto"],
          :descrizione => item[1]["descrizione"],
          :prezzo_unitario => item[1]["prezzo_unitario"]
      )
    end

    # 3. Salvataggio richiesta ordine in MySQL
    @order_request.save


    # 4. Login MagicLink
    @order_request.login
    @order_request.create_tb

    # 5. MagicLink Setdata
    @code = @order_request.set_data


    # 6. Logout MagicLink
    @order_request.logout



    # 7. Output
    respond_to do |format|
      if @code[0] != "ERROR"
        format.html { render :create, layout: "blank"  }
      else
        format.html { render :error, layout: "blank"  }
      end
    end
  end

  def update
    respond_to do |format|
      if @order_request.update(order_request_params)
        format.html { redirect_to @order_request, notice: 'Order request was successfully updated.' }
        format.json { render :show, status: :ok, location: @order_request }
      else
        format.html { render :edit }
        format.json { render json: @order_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /order_requests/1
  # DELETE /order_requests/1.json
  def destroy
    @order_request.destroy
    respond_to do |format|
      format.html { redirect_to order_requests_url, notice: 'Order request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order_request
      @order_request = OrderRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_request_params
      params[:order_request].permit
    end
end
