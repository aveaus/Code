require 'spec_helper'

describe PropertiesController do
  render_views

  before do
    @morning = Property.create(:name => 'early', :start => 8, :stop => 12, :weight => 2)
    @noon = Property.create(:name => 'early', :start => 9, :stop => 14, :weight => 3)
    @afternoon = Property.create(:name => 'late', :start => 14, :stop => 17, :weight => 4)
    @evening = Property.create(:name => 'late', :start => 18, :stop => 22, :weight => 3)
  end

  describe "Index" do
    it "should get the active properties for current time" do
      get :index, {:hour => 11}

      ps = assigns(:properties)
      ps.should include(@morning, @noon)
      ps.should_not include(@afternoon, @evening)

      # normalize overlapping properties
      norms = assigns(:normalized_properties)
      norms.should include(@noon)
      norms.should_not include(@morning)
    end
  end

  describe "Find" do
    before do
      # @morning and @noon have same name but different geofence
      @morning.geofence = Geofence.new(:vertices => Forgery::Geo.polygon([0,0], 1, 1))
      @morning.save!
      @noon.geofence = Geofence.new(:vertices => Forgery::Geo.polygon([3,3], 1, 1))
      @noon.save!
      # @afternoon and @evening have same name and same geofence, different weight
      @afternoon.geofence = Geofence.new(:vertices => Forgery::Geo.polygon([0,0], 1, 1))
      @afternoon.save!
      @evening.geofence = Geofence.new(:vertices => Forgery::Geo.polygon([0, 0], 1, 1))
      @evening.save!
    end

    it "should return active properties for a particular hour" do
      get :find, {:hour => 11}

      ps = assigns(:properties)
      ps.should include(@morning, @noon)
      ps.should_not include(@afternoon, @evening)

      # normalize overlapping properties
      norm = assigns(:normalized_properties)
      norm.should include(@noon)
      norm.should_not include(@morning)
    end

    it "should return all properties for a particular coordinate" do
      get :find, {:latlng => [0,0]}
      
      # should not return @noon as it is a different geofence
      ps = assigns(:properties)
      ps.should include(@morning, @afternoon, @evening)
      ps.should_not include(@noon)

      norms = assigns(:normalized_properties)
      norms.should include(@morning, @afternoon)
      norms.should_not include(@evening)
    end
  end
end
