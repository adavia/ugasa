module V1
  class AttachmentsController < ApplicationController
    skip_before_action :authorize_request, only: [:show]
    before_action :set_attachment, only: [:show, :destroy]
    before_action :set_attacheable_type, only: [:index, :create]

    # GET /clients/:client_id/attachments
    def index
      render json: @attacheable.attachments.order(created_at: "DESC"), status: :ok
    end

    def show
      send_file("#{Rails.root}/public/#{@attachment.file.url}")
    end

    # POST /clients/:client_id/attachments
    def create
      @attachment = @attacheable.attachments.create!({file: params[:file]})
      render json: @attachment, status: :created
    end

    # DELETE /clients/:client_id/attachments/:id
    def destroy
      @attachment.destroy
      render json: @attachment, status: :ok
    end

    private

    def set_attachment
      @attachment = Attachment.find(params[:id])
    end

    def set_attacheable_type
      resource, id = request.path.split('/')[1, 2]
      @attacheable = resource.singularize.classify.constantize.find(id)
    end
  end
end
