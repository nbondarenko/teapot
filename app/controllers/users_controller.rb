class UsersController < ApplicationController
  def create
    userToken = SecureRandom.uuid
    @user = User.new(email: user_params[:email], password: user_params[:password], token: userToken)
    if @user.save
      session[:token] ||= userToken
      render json: @user
    else
      render json: { id: 0, errors: @user.errors.full_messages.join(', ') }
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
