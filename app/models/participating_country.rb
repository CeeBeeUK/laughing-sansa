class ParticipatingCountry < ActiveRecord::Base
  belongs_to :country
  belongs_to :event
  belongs_to :player, class_name: 'User', foreign_key: 'player_id'

  validates :country_id, :player_id, :event_id, :sequence, presence: true
  validates :sequence, uniqueness: { scope: :event_id }
  validates :country_id, uniqueness: { scope: :event_id }
end
