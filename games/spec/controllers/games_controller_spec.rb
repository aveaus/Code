require 'spec_helper'

describe GamesController do
  before do
    @player = Player.make!
    @ai = Player.make!(:ai)
    @lead = Leaderboard.make!(:player => @player, :score => 1)
    @game = Game.make!(:first, :player_one_id => @player.id, :grid => Grid.make)
  end

  it "should create new games" do
    controller.stub(:current_player) { @player }
    post :create

    result = JSON.parse(response.body)

    result["errors"].should be_nil
    result["gid"].should_not be_nil
    result["leaderboard"].should_not be_nil
  end

  it "should mark center if player had selected a corner" do
    controller.stub(:current_player) { @player }
    controller.stub(:params) { {:move => '1,1', :id => "#{@game.id}"} }

    put :update, :id => {}

    result = JSON.parse(response.body)
    result["move"].should == "2,2"  # respond to a corner move with center
  end

  it "should corner if player selected a center" do
    controller.stub(:current_player) { @player }
    controller.stub(:params) { {:move => '2,2', :id => "#{@game.id}"} }

    put :update, :id => {}

    result = JSON.parse(response.body)
    result["move"].should == "1,1"  # respond to a corner move with center
  end
end
