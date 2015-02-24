class AddTrackingFieldsToEvents < ActiveRecord::Migration
  def change

    add_reference :events, :real_winner, references: :countries, index: true
    add_column :events, :real_score, :integer
    add_reference :events, :real_player, references: :users, index: true
    add_column :events, :real_player_name, :string
    add_reference :events, :home_winner, references: :countries, index: true
    add_column :events, :home_score, :integer
    add_reference :events, :home_player, references: :users, index: true
    add_column :events, :home_player_name, :string
    add_column :events, :status, :integer
  end
end
