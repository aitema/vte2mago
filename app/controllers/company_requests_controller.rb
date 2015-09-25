class CompanyRequestsController < ApplicationController
  before_action :set_company_request, only: [:show, :edit, :update, :destroy]
  protect_from_forgery :except => :create

  # GET /company_requests
  # GET /company_requests.json
  def index
    @company_requests = CompanyRequest.all
  end

  # GET /company_requests/1
  # GET /company_requests/1.json
  def show
  end

  # GET /company_requests/new
  def new
    @company_request = CompanyRequest.new
  end

  # GET /company_requests/1/edit
  def edit
  end

  # POST /company_requests
  # POST /company_requests.json
  def create
    # 1. Archivia la richiesta su database di transito

    #@company_request = CompanyRequest.new(company_request_params)
    @company_request = CompanyRequest.new(
        :ragione_sociale => params[:ragione_sociale],
        :id_univoco => params[:id_univoco],
        :partita_iva => params[:partita_iva],
        :codice_fiscale => params[:codice_fiscale],
        :indirizzo => params[:indirizzo],
        :città => params[:città],
        :codice => params[:codice],
        :provincia => params[:provincia],
        :regione => params[:regione],
        :indirizzo_spedizione => params[:indirizzo_spedizione],
        :citta_spedizione => params[:citta_spedizione],
        :codice_spedizione => params[:ragione_sociale],
        :provincia_spedizione => params[:provincia_spedizione],
        :regione_spedizione => params[:regione_spedizione],
        :assegnato_a => params[:assegnato_a],
        :email => params[:email],
        :telefono => params[:telefono],
        :fax => params[:fax],
        :sito_web => params[:sito_web],
        :descrizione => params[:descrizione]
    )

    #respond_with(render :text => "ERROR") unless @company_request.save

    # 2. Chiamata a Mago.Net
    @code = 3123

    # 3. Restituzione risultato
    respond_to do |format|
      if @company_request.save
        format.html { render :create, layout: "blank"  }
      else
        format.html { render :error }
       end
    end
  end

  # PATCH/PUT /company_requests/1
  # PATCH/PUT /company_requests/1.json
  def update
    respond_to do |format|
      if @company_request.update(company_request_params)
        format.html { redirect_to @company_request, notice: 'Company request was successfully updated.' }
        format.json { render :show, status: :ok, location: @company_request }
      else
        format.html { render :edit }
        format.json { render json: @company_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /company_requests/1
  # DELETE /company_requests/1.json
  def destroy
    @company_request.destroy
    respond_to do |format|
      format.html { redirect_to company_requests_url, notice: 'Company request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company_request
      @company_request = CompanyRequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_request_params
      params[:company_request].permit
    end
end
