class Event < ActiveRecord::Base
  belongs_to :country
  validates :year, :country_id, :host_city, presence: true
  validates :year, uniqueness: true

  scope :last_to_first, -> { all.order(year: :desc) }

  def display_name
    "#{self.host_city} #{self.year}"
  end

end
