class ParticipatingCountry < ActiveRecord::Base
  belongs_to :country
  belongs_to :event
  belongs_to :player, class_name: 'User', foreign_key: 'player_id'
end
