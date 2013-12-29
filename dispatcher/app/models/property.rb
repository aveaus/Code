class Property < ActiveRecord::Base
  has_one :geofence

  delegate :contains_point?, :to => :geofence

  attr_accessible :name, :weight, :start, :stop
  
  def self.create_from_params(params)
    p = Property.new

    p.name = params[:name]
    p.value = params[:value]
    p.weight = params[:weight]
    p.start = params[:start]
    p.stop = params[:stop]

    p
  end

  # Find active properties during the hour
  def self.find_active_properties(hour)
    # time range begins 'start' and end at 'stop'
    Property.find(:all, :conditions => ['start <= ? AND stop > ?', hour, hour])
  end

  # Cache all properties
  def self.props
    @props ||= Property.all
  end
end

