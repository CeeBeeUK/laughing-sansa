class RemoveSequenceFromParticipatingCountries < ActiveRecord::Migration[4.2]
  def change
    remove_column :participating_countries, :sequence
  end
end
