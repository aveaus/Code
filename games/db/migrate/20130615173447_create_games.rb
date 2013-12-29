class CreateGames < ActiveRecord::Migration
  def up
    # Game needs to track a winner, the moves
    # player one always start with 'X'
    create_table :games do |t|
      t.text :moves
      t.integer :winner, :default => nil

      t.integer :player_one_id
      t.integer :player_two_id

      t.timestamps
    end
  end

  def down
    drop_table :games
  end
end