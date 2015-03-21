class AddPositionToParticipatingCountry < ActiveRecord::Migration
  def change
    add_column :participating_countries, :position, :integer
  end
end
