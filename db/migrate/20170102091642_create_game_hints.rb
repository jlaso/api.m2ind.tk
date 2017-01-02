class CreateGameHints < ActiveRecord::Migration[5.0]
  def change
    create_table :game_hints do |t|
      t.integer :game_id
      t.string :game_token
      t.integer :hint

      t.timestamps
    end
  end
end
