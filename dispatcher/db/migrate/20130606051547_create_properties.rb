class CreateProperties < ActiveRecord::Migration
  def up
    create_table :properties do |t|
      t.string :name
      t.float :value
      t.float :weight
      t.integer :start
      t.integer :stop

      t.timestamps
    end
  end

  def down
    drop_table :properties
  end
end
