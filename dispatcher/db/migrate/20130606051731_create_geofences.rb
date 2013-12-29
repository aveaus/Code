class CreateGeofences < ActiveRecord::Migration
  def up
    create_table :geofences do |t|
      t.integer :property_id
      t.text :vertices
    end
  end

  def down
    drop_table :geofences
  end
end
