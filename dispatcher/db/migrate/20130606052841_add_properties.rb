class AddProperties < ActiveRecord::Migration
  def change
    # Create dispatch distance properties 
    distances = Forgery::Property.max_dispatch_distance
    distances = add_geofences(distances)
    distances.each {|w|
      w.save!
    }

    # Create surcharge properties
    surcharges = Forgery::Property.max_fuel_surcharge
    surcharges = add_geofences(surcharges)
    surcharges.each {|w|
      w.save!
    }

    # Create wait time properties
    waits = Forgery::Property.max_wait_time
    waits = add_geofences(waits)
    waits.each {|w|
      w.save!
    }
  end

  def add_geofences(props)
    # Rough geographic enter of SF
    lat = 37.7740
    long = -122.4385
    max_lat_offset, max_long_offset = 0.0325, 0.0325

    # Generate random geofence for the properties
    props.collect! {|p|
      # Create the property
      prop = Property.create_from_params(p)

      # Randomly determine on which axis from the center the polygon should be on
      lat_dir = Forgery::Basic.boolean ? 1 : -1
      long_dir = Forgery::Basic.boolean ? 1 : -1

      # Find the new center to create the polygon
      center_lat_offset = Forgery::Basic.decimal({:at_most => max_lat_offset}) * lat_dir
      center_long_offset = Forgery::Basic.decimal({:at_most => max_long_offset}) * long_dir
      polygon_center = [lat+center_lat_offset, long+center_long_offset]

      # Create new random offset size for the polygon 
      poly_lat_offset = Forgery::Basic.decimal({:at_most => max_lat_offset})
      poly_long_offset = Forgery::Basic.decimal({:at_most => max_long_offset})

      polygon = Forgery::Geo.polygon(polygon_center, poly_lat_offset, poly_long_offset)
      prop.geofence = Geofence.new(:vertices => polygon)

      prop
    }

    props
  end
end
