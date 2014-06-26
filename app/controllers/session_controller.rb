class SessionController < ApplicationController
  skip_before_action :authenticate, only: [:create, :destroy]

  def create
    admin = AdminAuthenticator.new(request.env['omniauth.auth']).admin

    if admin
      sign_in(admin)
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