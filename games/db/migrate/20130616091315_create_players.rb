class CreatePlayers < ActiveRecord::Migration
  def change
    # Player needs to have a name and a role
    create_table :players do |t|
      t.string :name
      t.string :role, :default => 'player'

      t.timestamps
    end

    Player.create(:name => "AI", :role => 'ai')
  end
end
