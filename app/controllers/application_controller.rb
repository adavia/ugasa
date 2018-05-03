class ApplicationController < ActionController::API
  before_action :set_locale
  include ActionController::Serialization
  include ExceptionHandler

  # Called before every action on controllers
  before_action :authorize_request
  attr_reader :current_user

  private

  def set_locale
    I18n.locale = "es"
  end

  # Check for valid request token and return user
  def authorize_request
    @current_user = (Auth.new(request.headers).call)[:user]
  end
end
