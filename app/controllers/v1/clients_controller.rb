module V1
  class ClientsController < ApplicationController
    before_action :set_client, only: [:show, :update, :destroy]
    skip_before_action :authorize_request, only: :welcome

    # GET /
    def welcome
      render json: "UGA Soluciones Ambientales", status: :ok
    end

    # GET /clients
    def index
      if params[:value].present?
        @clients = Client.search(params[:value])
          .order(comercial_name: 'ASC')
          .page(params[:page])
          .includes(:contract, :emails, :location)
      else
        @clients = Client
          .order(comercial_name: 'ASC')
          .page(params[:page])
          .includes(:contract, :emails, :location)
      end
      render( 
        json: @clients, 
        meta: pagination_links(@clients),
        status: :ok
      )
    end

    # POST /clients
    def create
      @client = Client.create!(client_params)
      render json: @client, status: :created
    end

    # GET /clients/:id
    def show
      render json: @client, status: :ok
    end

    # PUT /clients/:id
    def update
      @client.update(client_params)
      render json: @client, status: :ok
    end

    # DELETE /clients/:id
    def destroy
      @client.destroy
      render json: @client, status: :ok
    end

    private

    def client_params
      params.require(:client).permit(
        :rfc,
        :social_name,
        :legal_representative,
        :comercial_name,
        :responsible,
        :phone,
        :location_id,
        contract_attributes: [
          :id,
          :oil_payment,
          :contract_date,
          :contract_end,
          :contact,
          :address,
          :bank_name,
          :bank_account,
          :_destroy
        ],
        emails_attributes: [ :id, :address, :_destroy ]
      )
    end

    def pagination_links(collection)
      {
        current: collection.current_page,
        total_entries: collection.total_entries,
        total_pages: collection.total_pages,
        self: "?page=#{collection.current_page}",
        first: "?page=#{1}",
        next: "?page=#{collection.next_page}",
        prev: "?page=#{collection.previous_page}",
        last: "?page=#{collection.total_pages}"
      }
    end

    def set_client
      @client = Client.find(params[:id])
    end
  end
end
