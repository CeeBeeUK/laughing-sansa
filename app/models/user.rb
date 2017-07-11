class User < ApplicationRecord

  devise :omniauthable, omniauth_providers: [:google_oauth2]

  ROLES = %w[admin user].freeze

  validates :email, format: Devise.email_regexp
  validates :email, uniqueness: true
  validates :role, presence: true
  validates :role, inclusion: {
    in: ROLES,
    message: '%{value} is not a valid role',
    allow_nil: true
  }

  def in_event?(event)
    EventPlayer.find_by(event: event, player: self).present?
  end

  def self.find_for_google_oauth2(access_token, _signed_in_resource = nil)
    data = access_token.info
    # data[:last_sign_in_at] = DateTime.now
    user = User.find_by(email: data['email'])
    user = if user
             update_user(user, data)
           else
             add_new_user(data)
           end
    user
  end

  def display_name
    self[:display_name].presence ? self[:display_name] : first_name
  end

  def admin?
    role == 'admin'
  end

  def display_name_set?
    self[:display_name].presence ? true : false
  end

  def self.add_new_user(data)
    User.create!(name: data['name'],
                 email: data['email'],
                 last_name: data['last_name'],
                 first_name: data['first_name'],
                 encrypted_password: Devise.friendly_token[0, 20],
                 image: data['image'],
                 role: 'user')
  end

  def self.update_user(user, data)
    user.update!(name: data['name'],
                 last_name: data['last_name'],
                 first_name: data['first_name'],
                 encrypted_password: Devise.friendly_token[0, 20],
                 image: data['image'])
    user
  end
end
