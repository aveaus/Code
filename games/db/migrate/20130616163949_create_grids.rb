class CreateGrids < ActiveRecord::Migration
  def change
    create_table :grids do |t|
      t.integer :game_id
      t.foreign_key :games
      
      t.text :state

      t.timestamps
    end
  end
end
