# Generates random timezone information.
class Forgery::Time < Forgery

  # Gets a random timezone out of the 'timezones' dictionary
  #
  #   Forgery(:timezone).timezone
  #   # => "Sydney"
  def self.zone
    dictionaries[:zones].random.unextend
  end

  def self.range
    start = Forgery::Basic.number({:at_least => 0, :at_most => 23})
    stop = Forgery::Basic.number({:at_least => (start+1), :at_most => 24})

    [start, stop]
  end
end
