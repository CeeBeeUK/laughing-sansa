class CreateParticipatingCountries < ActiveRecord::Migration[4.2]
  def change
    create_table :participating_countries do |t|
      t.references :country, index: true
      t.references :event, index: true
      t.integer :sequence
      t.references :player, references: :users, index: true
      t.integer :real_final_score
      t.integer :home_final_score

      t.timestamps
    end
    add_index(:participating_countries, [:country_id, :event_id], unique: true, name: 'unique_country_for_event')
    add_index(:participating_countries, [:event_id, :sequence], unique: true, name: 'unique_sequence_for_event')
  end
end
