class ParticipatingCountry < ActiveRecord::Base
  belongs_to :country
  belongs_to :event
  belongs_to :player, class_name: 'User', foreign_key: 'player_id'

  acts_as_list scope: :event

  validates :country_id, :player_id, :event_id, :position, presence: true
  validates :position, uniqueness: { scope: :event_id }
  validates :country_id, uniqueness: { scope: :event_id }
end
