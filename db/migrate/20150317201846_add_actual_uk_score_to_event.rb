class AddActualUkScoreToEvent < ActiveRecord::Migration
  def change
    add_column :events, :actual_uk_score, :integer
  end
end
