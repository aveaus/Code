class AddLeaderboards < ActiveRecord::Migration
  def up
    create_table :leaderboards do |t|
      t.integer :player_id
      t.foreign_key :players

      t.integer :score, :default => 0
    end
  end

  def down
    drop_table :leaderboards
  end
end
