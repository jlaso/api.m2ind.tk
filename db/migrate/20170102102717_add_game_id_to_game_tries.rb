class AddGameIdToGameTries < ActiveRecord::Migration[5.0]
  def change
    add_column :game_tries, :game_id, :integer
  end
end
