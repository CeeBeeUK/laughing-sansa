class RenameParticipatingPlayerToEventPlayer < ActiveRecord::Migration[4.2]
  def change
  	rename_table :participating_players, :event_players
  end
end
