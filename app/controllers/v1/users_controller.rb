module V1
  class UsersController < ApplicationController
    before_action :set_user, only: [:update, :destroy]
    #skip_before_action :authorize_request, only: [:unique_field]

    # GET /users
    def index
      @users = User.all.page(params[:page])
      render(
        json: @users, 
        meta: { total_users: @users.total_entries }, 
        status: :ok
      )
    end

    # POST /users
    def create
      user = User.create!(user_params)
      render json: user, meta: { total_users: User.all.count }, status: :created
    end

    # PUT /clients/:id
    def update
      @user.update(user_params)
      render json: @user, status: :ok
    end

     # DELETE /clients/:id
     def destroy
      @user.destroy
      render json: @user, meta: { total_users: User.all.count }, status: :ok
    end

    # Verify username/email is unique
    def unique_field
      user = User.where(username: params[:field]).or(User.where(email: params[:field]))
      render json: user.present?, status: :ok
    end

    # Get current user
    def me
      render json: current_user, status: :ok
    end

    private

    def user_params
      params.require(:user).permit(
        :username,
        :email,
        :password,
        :password_confirmation
      )
    end

    def set_user
      @user = User.find(params[:id])
    end
  end
end
