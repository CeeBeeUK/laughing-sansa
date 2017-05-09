class AddActualUkScoreToEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :actual_uk_score, :integer
  end
end
