class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :fake_authenticate

  before_action :authenticate
  helper_method :current_admin, :admin_signed_in?

  private
  def fake_authenticate
    # !!!DEVELOPMENT!!!
    if Rails.env.development?
      @current_admin ||= AdminAuthenticator.new({}).admin
      sign_in(@current_admin)
    end
  end
  
  def authenticate
    if current_admin
      unless has_permissions?(current_admin)
        flash[:warning] = 'Your account is not activated yet.'
        redirect_to :root
      end
    else
      flash[:danger] = 'You need to sign in or sign up before continuing.'
      redirect_to :root
    end
  end

  def has_permissions?(admin)
    true if admin && admin.approved
  end

  def current_admin
    @current_admin ||= Admin.find_by(id: session[:admin_id]) if session[:admin_id]
  rescue
    @current_admin = nil
  end

  def sign_in(admin)
    session[:admin_id] = admin.id
  end

  def admin_signed_in?
    true if current_admin
  end

  def sign_out
    session[:admin_id] = nil
  end
end
