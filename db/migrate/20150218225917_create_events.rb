class CreateEvents < ActiveRecord::Migration[4.2]
  def change
    create_table :events do |t|
      t.integer :year
      t.references :country, index: true
      t.string :host_city
      t.boolean :active
      #todo add home_winner and real_winner
      t.timestamps
    end
  end
end
