class AddPointsToScores < ActiveRecord::Migration[5.0]
  def change
    add_column :scores, :points, :integer
  end
end
