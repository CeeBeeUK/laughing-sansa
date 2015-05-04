class Event < ActiveRecord::Base
  belongs_to :country
  belongs_to :real_winner, class_name: 'Country', foreign_key: 'real_winner_id'
  belongs_to :home_winner, class_name: 'Country', foreign_key: 'home_winner_id'
  belongs_to :real_player, class_name: 'User', foreign_key: 'real_player_id'
  belongs_to :home_player, class_name: 'User', foreign_key: 'home_player_id'

  has_many :participating_countries, -> { order('position ASC') }
  has_many :event_players

  validates :year, :country_id, :host_city, presence: true
  validates :year, uniqueness: true

  enum status: [:setup, :active, :archived]

  scope :last_to_first, -> { all.order(year: :desc) }

  scope :latest_active, -> { all.where('status=?', Event.statuses[:active]).order(:year) }

  def display_name
    "#{host_city} #{year}"
  end

  def to_param
    year.to_s
  end

  def can_be_joined?
    active?
  end

  def can_be_joined_by?(player)
    active? && EventPlayer.find_by(event: self, player: player).nil?
  end

  def being_played_by?(player)
    active? && EventPlayer.find_by(event: self, player: player).present?
  end

  def complete?
    archived? && (real_winner_complete? || home_winner_complete?)
  end

  def players
    event_players
  end

  def players_predictions_high_to_low
    event_players.order(predicted_uk_score: :desc)
  end

  def real_winner_complete?
    real_winner_id.present? && (real_player_name.present? || real_player_id.present? || false)
  end

  def home_winner_complete?
    home_winner_id.present? && (home_player_name.present? || home_player_id.present? || false)
  end

  def real_winning_country
    real_winner.name if real_winner_id
  end

  def real_winning_player
    if real_player
      real_player.display_name
    else
      real_player_name
    end
  end

  def home_winning_country
    home_winner.name if home_winner_id
  end

  def home_winning_player
    if home_player
      home_player.display_name
    else
      home_player_name
    end
  end

  def real_winner_display
    "Won by #{real_winning_player} with #{real_winning_country}" if real_winner_complete?
  end

  def home_winner_display
    "Home champion was #{home_winning_player} with #{home_winning_country}" if home_winner_complete?
  end
end
