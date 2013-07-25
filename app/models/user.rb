class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         #:recoverable, 
         :rememberable, 
         :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:google_oauth2]


  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    p "="*80
    p access_token
    p "="*80
    data = access_token.info
    user = User.where(:email => data["email"]).first
    unless user
      user = User.create(
      	name: data["name"],
        gplus: data["urls"]["Google"],
        image: data["image"], 
      	email: data["email"],
        password: Devise.friendly_token[0,20])
    end
    user
  end
end
