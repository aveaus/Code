require 'spec_helper'
require 'benchmark'

describe Geofence do
  context "Contains a Point" do
    # Create a square of of side = 2, center on [0,0]
    let(:polygon) { Forgery::Geo.polygon([0,0], 1, 1) }
    let(:fence) { Geofence.new(:vertices => polygon) }

    it "should create a valid geofence" do
      fence.valid?.should be_true
    end

    it "should return true for point [0,0] is within the polygon" do
      fence.contains_point?([0,0]).should be_true
    end

    it "should return false for point [2, 2[ is outside the polygon" do
      fence.contains_point?([2, 2]).should be_false
    end

    context "Geofence" do
      let(:geo_poly) { Forgery::Geo.polygon([37.779, -122.348], 0.325, 0.325) }
      let(:geo_fence) { Geofence.new(:vertices => geo_poly) }

      it "should return true if point within top-left quadrant of the geofence" do
        geo_fence.contains_point?([37.793, -122.460]).should be_true
      end

      it "should return true if point within top-right quadrant of the geofence" do
        geo_fence.contains_point?([37.783, -122.415]).should be_true
      end

      it "should return true if point within bottom-left quadrant of the geofence" do
        geo_fence.contains_point?([37.757, -122.454]).should be_true
      end

      it "should return true if point within bottom-right quadrant of the geofence" do
        geo_fence.contains_point?([37.754, -122.412]).should be_true
      end

      # Not within the geofence
      it "should return false if point is not within top-left quadrant of the geofence" do
        geo_fence.contains_point?([37.835, -122.508]).should be_true
      end

      it "should return false if point is not within top-right quadrant of the geofence" do
        geo_fence.contains_point?([37.804, -122.299]).should be_true
      end

      it "should return false if point is not within bottom-left quadrant of the geofence" do
        geo_fence.contains_point?([37.691, -122.486]).should be_true
      end

      it "should return false if point is notwithin bottom-right quadrant of the geofence" do
        geo_fence.contains_point?([37.714, -122.384]).should be_true
      end
    end
  end
end
