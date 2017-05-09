class AddPositionToParticipatingCountry < ActiveRecord::Migration[4.2]
  def change
    add_column :participating_countries, :position, :integer
  end
end
