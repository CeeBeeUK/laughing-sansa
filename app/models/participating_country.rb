class ParticipatingCountry < ApplicationRecord
  belongs_to :country
  belongs_to :event
  belongs_to :player, class_name: 'User', foreign_key: 'player_id'

  acts_as_list scope: :event

  validates :country_id, :player_id, :event_id, :position, presence: true
  validates :position, uniqueness: { scope: :event_id }
  validates :country_id, uniqueness: { scope: :event_id }
  validates :player_id, numericality: { greater_than_or_equal_to: 0 }

  scope :by_position, (-> { all.order(:position) })
  scope :player_for_event, (lambda { |event, player|
    all.where(event_id: event, player_id: player).order(:country_id)
  })

  def sum
    EventPlayerScore.where(participating_country_id: id).sum(:score)
  end
end
