class AddDateToEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :date, :date
  end
end
