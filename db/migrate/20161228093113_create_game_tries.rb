class CreateGameTries < ActiveRecord::Migration[5.0]
  def change
    create_table :game_tries do |t|
      t.string :game_token
      t.string :try
      t.string :result
      t.integer :seconds
      t.boolean :accepted

      t.timestamps
    end
  end
end
