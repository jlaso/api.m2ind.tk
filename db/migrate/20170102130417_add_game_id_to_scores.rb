class AddGameIdToScores < ActiveRecord::Migration[5.0]
  def change
    add_column :scores, :game_id, :integer
  end
end
