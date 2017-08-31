class UsersController < ApplicationController
  skip_before_action :authenticate

  def create
    user = User.new(user_params)
    if user.save
      render json: {message: "user created successfully"}, status: :ok
    else
      render json: {}, status: :unauthorized
    end
  end

  def test
    render json: {message: 'you did it boyo!!!!!!!!!!'}
  end

  private

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end

end
