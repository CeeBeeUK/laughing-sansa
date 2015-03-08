class CreateParticipatingPlayers < ActiveRecord::Migration
  def change
    create_table :participating_players do |t|
      t.references :player, references: :users, index: true
      t.references :event, index: true
      t.integer :predicted_uk_score

      t.timestamps
    end
  end
end
