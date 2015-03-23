class RenameParticipatingPlayerToEventPlayer < ActiveRecord::Migration
  def change
  	rename_table :participating_players, :event_players
  end
end
