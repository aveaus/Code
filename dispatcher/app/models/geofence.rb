class Geofence < ActiveRecord::Base
  belongs_to :property
  serialize :vertices

  # attr_accessible :vertices
  validates_presence_of :vertices
  validate :polygon?

  attr_accessible :vertices
  
  def polygon?
    # Geofence is valid if it has vertices that make at least a triangle (> 3 vertices)
    # and the last vertex equals the first vertex
    vertices.size > 3 && vertices[3][0] == vertices[0][0] && vertices[3][1] == vertices[0][1]
  end

  # Using Ray casting algorithm (Even-odd rule) to determine
  # if a point is within the boundary of the polygon
  def contains_point?(point)
    # Validate the polygon first
    return false if !self.valid?

    contains_pt = false
    start = -1
    trail = self.vertices.size - 2 # disregard the last vertex

    # Test for all sides
    while (start += 1) < self.vertices.size-1      
      # Initially set starting_pt = top-left, trailing_pt = bottom-left 
      starting_pt = self.vertices[start]
      trailing_pt = self.vertices[trail]

      # If the point is between the y segment (latitude)
      if point_is_between_ys_of_line_segment?(point, starting_pt, trailing_pt)
        if ray_crosses_line_segment?(point, starting_pt, trailing_pt)
          contains_pt = !contains_pt
        end
      end

      # Check the next edge
      trail = start
    end
    
    contains_pt
  end

private
  def point_is_between_ys_of_line_segment?(point, starting_pt, trailing_pt)
    # If starting_pt is higher than trailing_pt
    (point[0] >= trailing_pt[0] && point[0] < starting_pt[0]) ||
    # starting_pt is lower than trailing_pt
    (point[0] >= starting_pt[0] && point[0] < trailing_pt[0]) 
    
  end

  def ray_crosses_line_segment?(point, starting_pt, trailing_pt)
    # tan = Y/X = Y'/X'. If point is at the edge of this line segment, then it
    # should have ALMOST the same tagent as this line segment, therefore
    # Y/X * X' = Y'. Once the Y' is found and add to the starting(y)
    # if it's not greater than point(y), then the point is outside the line
    ((trailing_pt[1] - starting_pt[1]) * (point[0] - starting_pt[0]) / 
      (trailing_pt[0] - starting_pt[0]) + starting_pt[1]) > point[1]
  end
end
