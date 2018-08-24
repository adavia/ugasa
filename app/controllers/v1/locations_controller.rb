module V1
  class LocationsController < ApplicationController
    before_action :set_location, only: [:destroy]

    # GET /locations
    def index
      if params[:value].present?
        @locations = Location.search(params[:value]).order(zone: 'ASC').limit(20)
      else
        @locations = Location.order(zone: 'ASC').limit(20)
      end
      render( 
        json: @locations, 
        status: :ok
      )
    end

    # POST /users
    def create
      location = Location.create!(location_params)
      render json: location, status: :created
    end

    def destroy
      @location.destroy
      render json: @location, status: :ok
    end

    private

    def set_location
      @location = Location.find(params[:id])
    end

    def location_params
      params.require(:location).permit(:zone)
    end
  end
end
