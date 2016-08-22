class UsersController < ApplicationController
  def create
    @user = User.new(email: user_params[:email], password: user_params[:password])
    @user.token = set_unique_token(@user)
    if @user.save
      cookies[:token] = { value: @user.token, expires: 1.year.from_now }
      render json: @user, status: 200
    else
      render json: { error: @user.errors.full_messages.join(', ') }, status: 400
    end
  end

  def sign_in
    if user_params[:email].blank? || user_params[:password].blank?
      return render json: { error: 'All fields must be filled' }, status: 400
    end
    @user = User.where(email: user_params[:email],  password: user_params[:password]).first
    if @user.present?
      @user.token = set_unique_token(@user)
      if @user.save
        cookies[:token] = { value: @user.token, expires: 1.year.from_now }
        render json: @user, status: 200
      else
        render json: { error: 'Error has occured while singing in'}, status: 400
      end
    else
      render json: { error: 'No such user' }, status: 400
    end
  end

  def sign_in_primary
    if(cookies[:token] && User.where(token: cookies[:token]).first.present?)
      render json: { hadAuth: true }, status: 200
    else
      render json: { hadAuth: false }, status: 200
    end
  end

  def destroy
    cookies.delete :token
    render  status: 200
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :primary)
  end

  def set_unique_token(user)
    userToken = ''
    loop do
      userToken = SecureRandom.uuid
      break unless User.exists?(token: userToken)
    end
    userToken
  end
end
