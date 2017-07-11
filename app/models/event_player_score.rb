class EventPlayerScore < ApplicationRecord

  belongs_to :event_player
  belongs_to :participating_country
  has_one :event, through: :event_player
  validates :event_player_id, :participating_country_id, presence: true
  validates :score, inclusion: { in: GlobalConstants::VALID_SCORES, allow_nil: true }

  scope :playing_order, (lambda { |id|
    all.where(event_player_id: id).
      joins(:participating_country).
      order('participating_countries.position')
  })
  scope :scoring_order, (lambda { |id|
    all.where(event_player_id: id).
      joins(:participating_country).
      order('participating_countries.position +
        CASE WHEN (event_player_scores.score IS NULL)
        THEN 0
        ELSE 40 END')
  })
  def player
    participating_country.player.display_name unless participating_country.player.nil?
  end

  def country
    participating_country.country.name
  end
end
