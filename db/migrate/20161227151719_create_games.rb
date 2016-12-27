class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.string :token
      t.string :ip
      t.string :sequence
      t.integer :num_pos
      t.boolean :repeated

      t.timestamps
    end
  end
end
