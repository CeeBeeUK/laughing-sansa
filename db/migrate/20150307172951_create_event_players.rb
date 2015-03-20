class CreateEventPlayers < ActiveRecord::Migration
  def change
    create_table :event_players do |t|
      t.references :player, references: :users, index: true
      t.references :event, index: true
      t.integer :predicted_uk_score

      t.timestamps
    end
    add_index(:event_players, [:player_id, :event_id], unique: true, name: 'unique_player_and_event')
  end
end
