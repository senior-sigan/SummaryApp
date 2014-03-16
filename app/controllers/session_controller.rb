class SessionController < ApplicationController
  skip_before_action :authenticate, only: [:create, :destroy]

  def create
    auth_hash = request.env['omniauth.auth']
    user = Owner.sign_in_by_oauth_hash(auth_hash)

    if user
      sign_in(user)
      flash[:success] = 'Successfully authenticated from google-plus account.'
      redirect_to :root
    else
      flash[:error] = 'Pleas finish registration'
      redirect_to :root
    end
  end

  def destroy
    sign_out
    redirect_to :root
  end
end