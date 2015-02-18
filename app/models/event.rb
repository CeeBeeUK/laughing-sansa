class Event < ActiveRecord::Base
  belongs_to :country
  validates :year, :country_id, :host_city, presence: true
  validates :year, uniqueness: true
end
