class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :fake_authenticate

  before_action :authenticate
  helper_method :current_owner, :owner_signed_in?

  private
  def fake_authenticate
    # !!!DEVELOPMENT!!!
    if Rails.env.development?
      @current_owner ||= OwnerAuthenticator.new({}).person
      sign_in(@current_owner)
    end
  end
  
  def authenticate
    if current_owner
      unless has_permissions?(current_owner)
        flash[:warning] = 'Your account is not activated yet.'
        redirect_to :root
      end
    else
      flash[:danger] = 'You need to sign in or sign up before continuing.'
      redirect_to :root
    end
  end

  def has_permissions?(owner)
    true if owner && owner.approved
  end

  def current_owner
    @current_owner ||= Owner.find_by(id: session[:owner_id]) if session[:owner_id]
  rescue
    @current_owner = nil
  end

  def sign_in(owner)
    session[:owner_id] = owner.id
  end

  def owner_signed_in?
    true if current_owner
  end

  def sign_out
    session[:owner_id] = nil
  end
end
