class EventPlayer < ActiveRecord::Base
  belongs_to :player, class_name: 'User', foreign_key: 'player_id'
  belongs_to :event

  validates :player_id, :event_id, :predicted_uk_score, presence: true
  validates :predicted_uk_score, numericality: { greater_than_or_equal_to: 0 }
  validates :player_id, uniqueness: { scope: :event_id, message: 'is already playing in this year' }
  before_validation :event_can_be_joined, on: :create

private

  def event_can_be_joined
    if event && !event.can_be_joined?
      errors.add(:event, 'is not active.')
    end
  end
end
