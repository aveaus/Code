# Generates list of properties with random values
class Forgery::Property < Forgery
  def self.max_dispatch_distance
    properties = []

    10.times {|i|
      prop = {
        :name => "maxDispatchDistanceMiles",
        :value => Forgery::Basic.number
      }.merge(self.base)

      properties.push(prop)
    }

    properties
  end

  def self.max_fuel_surcharge
    properties = []

    10.times {|i|
      prop = {
        :name => "maxFuelSurcharge",
        :value => Forgery::Basic.decimal({:at_most => 3}).round(2)
      }.merge(self.base)

      properties.push(prop)
    }

    properties
  end

  def self.max_wait_time
    properties = []

    10.times {|i|
      prop = {
        :name => "maxWaitTime",
        :value => Forgery::Basic.number({:at_least => 10, :at_most => 30})
      }.merge(self.base)

      properties.push(prop)
    }

    properties
  end

  def self.base
    range = Forgery::Time.range
    prop = {
      :weight => Forgery::Basic.number,
      :start => range[0],
      :stop => range[1]
    }
  end
end
