class CreateEventPlayerScores < ActiveRecord::Migration[4.2]
  def change
    create_table :event_player_scores do |t|
      t.references :event_player, index: true
      t.references :participating_country, index: true
      t.integer :score
      t.boolean :best_wail
      t.boolean :fattest
      t.boolean :wackiest
      t.string :notes

      t.timestamps
    end
  end
end
