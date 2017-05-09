class AddColumnsToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :name, :string
    add_column :users, :image, :string
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :role, :string
  end
end
