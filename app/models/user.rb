class User < ActiveRecord::Base

  devise :omniauthable, :omniauth_providers => [:google_oauth2]

  ROLES = %w[admin user]

  validates_format_of :email, :with => Devise::email_regexp
  validates :email, uniqueness: true
  validates :role, presence: true
  validates :role, inclusion: { in: ROLES, message: "%{value} is not a valid role", allow_nil: true }


  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:email => data['email']).first

    unless user
      user = User.create!(name: data['name'],
                         email: data['email'],
                         encrypted_password: Devise.friendly_token[0,20],
                         image: data['image'],
                         role: 'user'
      )
    end
    user
  end

  def admin?
    self.role == 'admin'
  end

end
