class RemoveSequenceFromParticipatingCountries < ActiveRecord::Migration
  def change
    remove_column :participating_countries, :sequence
  end
end
