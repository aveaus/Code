# Generates random geographic information.
class Forgery::Geo < Forgery

  # Return a latitude in the range -90.0 to +90.0 as a float.
  def self.latitude
    rand * 180.0 - 90.0
  end

  # Return a latitude's degrees component in the range -180 to +180 as an integer.
  def self.latitude_degrees
    rand(360)-180
  end

  # Return a latitude's minutes component in the range 0 to 60 as an integer.
  def self.latitude_minutes
    rand(60)
  end

  # Return a latitude's seconds component in the range 0 to 60 as an integer.
  def self.latitude_seconds
    rand(60)
  end

  # Return a latitude's direction component, either "N" (north) or "S" (south)
  def self.latitude_direction
    ['N','S'].sample
  end

  # Return a longitude in the range -180.0 to +180.0 as a float.
  def self.longitude
    rand * 360.0 - 180.0
  end

  # Return a longitude's degrees component in the range -180 to +180 as an integer.
  def self.longitude_degrees
    rand(360)-180
  end

  # Return a longitude's minutes component in the range 0 to 60 as an integer.
  def self.longitude_minutes
    rand(60)
  end

  # Return a longitude's seconds component in the range 0 to 60 as an integer.
  def self.longitude_seconds
    rand(60)
  end

  # Return a longitude's direction component, either "E" (east) or "W" (west)
  def self.longitude_direction
    ["E","W"].sample
  end

  # Create a square by default
  def self.polygon(center, lat_offset=0.006, long_offset=0.0075, side = 4)
    rectangle(center, lat_offset, long_offset) if side == 4
  end

  # Ex. [[top-left], [top-right], [bottom-right], [bottom-left], [top-left]]
  def self.rectangle(center, lat_offset, long_offset)
    lat = center[0]
    long = center[1]

    top_left = [lat+lat_offset, long-long_offset] # lat+, long-
    top_right = [lat+lat_offset, long+long_offset] # lat+, long+
    bottom_right = [lat-lat_offset, long+long_offset] # lat-, long+
    bottom_left = [lat-lat_offset, long-long_offset] # lat-, long-

    [top_left, top_right, bottom_right, bottom_left, top_left]
  end
end
