class PropertiesController < ApplicationController
  def index
    @hour = params[:hour] || Time.new.hour
    @hour = @hour.to_i
    @properties = Property.find_active_properties(@hour)

    # Reduce overlapping properties
    @normalized_properties = normalize_properties_on_weight(@properties)
  end

  # GET
  def find
    @hour = params[:hour]
    @latlng = params[:latlng]

    # If a coordinate is given
    if @latlng.present? && @latlng.size == 2
      # convert coordinate to float
      @latlng = @latlng.collect {|c| c.to_f }

      # Get properties that correspond to this coordinate
      @properties = properties_contain_point(Property.props, @latlng)
    elsif @hour
      @hour = @hour.to_i
      # Find properties active for a particular time
      @properties = Property.find_active_properties(@hour.to_i)
    end

    # Reduce overlapping properties
    @normalized_properties = normalize_properties_on_weight(@properties)

    render :partial => 'calendar', :layout => false
  end

  def formatted_hour(hour)
    return "12AM" if hour == 0 || hour == 24
    return "12PM" if hour == 12

    am_or_pm = hour >= 12 ? "PM" : "AM"
    time = hour % 12

    "#{time}#{am_or_pm}"
  end
  helper_method :formatted_hour

  def formatted_time_range(start, stop)
    "#{formatted_hour(start)} - #{formatted_hour(stop)}"
  end
  helper_method :formatted_time_range

private
  # Get only the properties that contain the geographic area
  def properties_contain_point(props, point)
    props.collect {|prop|
      prop if prop.contains_point?(point)
    }.compact
  end

  # Get the highest weighted unique property
  def normalize_properties_on_weight(props)
    # Sort properties by weight first
    props.sort! {|x, y|
      x.name <=> y.name && y.weight <=> x.weight
    }

    uniq_props = {}
    ps = props.select {|p|
      name = p.name
      value = uniq_props[name]

      uniq_props[name] = p

      # Only get the first sorted element as it's the largest
      value.nil? ? p : nil
    }.compact
  end
end
