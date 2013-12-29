require 'spec_helper'

describe Property do
  it "should create a Property from params" do
    p = Property.create_from_params({
        :name => 'max',
        :value => 1.0,
        :weight => 1,
        :start => 10,
        :stop => 12
      })

    p.name.should == 'max'
    p.value.should == 1.0
    p.weight.should == 1
    p.start.should == 10
    p.stop.should == 12
  end

  it "should return all the properties" do
    p = Property.new
    p.save!

    Property.props.size.should == 1
  end

  describe "Active Properties" do
    before do
      @morning = Property.create(:name => 'early', :start => 8, :stop => 12, :weight => 2)
      @noon = Property.create(:name => 'early', :start => 9, :stop => 14, :weight => 3)
      @afternoon = Property.create(:name => 'late', :start => 14, :stop => 17, :weight => 4)
      @evening = Property.create(:name => 'late', :start => 18, :stop => 22, :weight => 3)
    end

    it "should find property that's active within a time frame" do
      time = 11
      props = Property.find_active_properties(time)

      props.should include(@morning, @noon)
      props.should_not include(@afternoon, @evening)
    end
  end
end
