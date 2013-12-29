require 'spec_helper'
require "json"

describe PlayersController do
  before do
    @ai = Player.make!(:ai)
    @player = Player.make!
  end

  let(:name) { Faker::Name.name }

  it "should create a new player" do
    expect {
      post :create, {:name => name}  
    }.to change{ Player.count }.by(1)

    # verify JSON response
    result = JSON.parse(response.body)
    result["errors"].should == nil
    result["name"].should == name
    result["id"].should_not be_nil
  end

  it "should not create a player if the player already exist" do
    expect {
      post :create, {:name => @player.name}
    }.to_not change{ Player.count }.by(1)

    # verify JSON response
    result = JSON.parse(response.body)
    result["errors"].should == nil
    result["name"].should == @player.name
    result["id"].should == @player.id
  end

  it "should not create another player with name 'AI'" do
    expect {
      post :create, {:name => "AI" }
    }.to_not change{ Player.count }.by(1)

    # verify JSON response
    result = JSON.parse(response.body)
    result["errors"].should == "You are not the AI"
    result["name"].should == @ai.name
    result["id"].should == @ai.id
  end
end
