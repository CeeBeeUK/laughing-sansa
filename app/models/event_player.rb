class EventPlayer < ActiveRecord::Base
  belongs_to :player, class_name: 'User', foreign_key: 'player_id'
  belongs_to :event

  has_many :scores, class_name: 'EventPlayerScore'

  validates :player_id, :event_id, :predicted_uk_score, presence: true
  validates :predicted_uk_score, numericality: { greater_than_or_equal_to: 0 }
  validates :player_id, uniqueness: { scope: :event_id, message: 'is already playing in this year' }
  before_validation :event_can_be_joined, on: :create

  before_save :build_scores

private

  def event_can_be_joined
    if event && !event.can_be_joined?
      errors.add(:event, 'is not active.')
    end
  end

  def build_scores
    event.participating_countries.each do |pc|
      scores << EventPlayerScore.create(event_player: self, participating_country: pc)
    end
  end
end
