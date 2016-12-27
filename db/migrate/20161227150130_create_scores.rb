class CreateScores < ActiveRecord::Migration[5.0]
  def change
    create_table :scores do |t|
      t.string :game_token
      t.string :user
      t.integer :tries
      t.integer :seconds
      t.integer :num_pos
      t.boolean :repeated

      t.timestamps
    end
  end
end
