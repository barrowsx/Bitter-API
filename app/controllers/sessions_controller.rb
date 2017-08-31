class SessionsController < ApplicationController
  skip_before_action :authenticate

  def create
    user = User.find_by(name: auth_params[:name])
    if user && user.authenticate(auth_params[:password])
      jwt = Auth.issue({user: user.id})
      render json: {jwt: jwt}
    else
      render json: {message: 'invalid credentials'}
    end
  end

  private

  def auth_params
    params.require(:auth).permit(:name, :password)
  end

end
