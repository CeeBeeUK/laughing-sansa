class Event < ActiveRecord::Base
  belongs_to :country
  belongs_to :real_winner, class_name: 'Country', foreign_key: 'real_winner_id'
  belongs_to :home_winner, class_name: 'Country', foreign_key: 'home_winner_id'
  belongs_to :real_player, class_name: 'User', foreign_key: 'real_player_id'
  belongs_to :home_player, class_name: 'User', foreign_key: 'home_player_id'

  has_many :participating_countries
  validates :year, :country_id, :host_city, presence: true
  validates :year, uniqueness: true

  enum status: [ :setup, :active, :archived ]

  scope :last_to_first, -> { all.order(year: :desc) }

  def display_name
    "#{self.host_city} #{self.year}"
  end
  def to_param
    self.year.to_s
  end

  def complete?
    archived? &&
      ((real_winner_id.present? && (real_player_name.present? || real_player_id.present? || false)) ||
      (home_winner_id.present? && (home_player_name.present? || home_player_id.present? || false)))
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
end
