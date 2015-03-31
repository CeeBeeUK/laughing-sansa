class EventPlayerScore < ActiveRecord::Base

  belongs_to :event_player
  belongs_to :participating_country

  validates :event_player_id, :participating_country_id, presence: true
  validates :score, inclusion: { in: GlobalConstants::VALID_SCORES, allow_nil: true }

  def player
    event_player.player.display_name
  end

  def country
    participating_country.country.name
  end
end
