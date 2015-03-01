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
    if user
      user.update!(name: data['name'],
                   last_name: data['last_name'],
                   first_name: data['first_name'],
                   encrypted_password: Devise.friendly_token[0,20],
                   image: data['image'])
    else
      user = User.create!(name: data['name'],
                          email: data['email'],
                          last_name: data['last_name'],
                          first_name: data['first_name'],
                          encrypted_password: Devise.friendly_token[0,20],
                          image: data['image'],
                          role: 'user'
      )
    end
    user
  end

  def display_name
    self[:display_name].presence ? self[:display_name] : first_name
  end

  def admin?
    self.role == 'admin'
  end

  def display_name_set?
    self[:display_name].presence ? true : false
  end

private

  def add_new_user(data)

  end

  def update_user(user, data)

  end
end
