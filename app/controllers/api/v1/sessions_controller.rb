class Api::V1::SessionsController < ApplicationController

  def create
    user = User.find_by(email: session_params[:email])

    if user and user.valid_password?(session_params[:password])
      sign_in user, store: false
      user.generete_authentication_token!
      user.save
      render json: user, status: 200
    else
      render json: {errors: "Email ou senha invalida"}, status: 401
    end
  end

  def destroy
    user = User.find_by auth_token: params[:id]
    user.generete_authentication_token!
    user.save
    head 204
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
