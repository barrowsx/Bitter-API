class ApplicationController < ActionController::API
  before_action :authenticate

  def logged_in?
    !!current_user
  end

  def current_user
    # byebug
    if auth_present? && auth != nil
      user = User.find(auth["user"])
      if user
        @current_user ||= user
      end
    else
      false
    end
  end

  def authenticate
    render json: {error: "Unauthorized. Make sure you're logged in!"}, status: :unauthorized unless logged_in?
  end

  private

  def token
    # byebug
    request.env["HTTP_AUTHORIZATION"].scan(/Bearer (.*)$/).flatten.last
  end

  def auth
    Auth.decode(token)
  end

  def auth_present?
    !!request.env.fetch("HTTP_AUTHORIZATION", "").scan(/Bearer/).flatten.first
  end

end
