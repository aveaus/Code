require 'spec_helper'

describe Leaderboard do
  let(:p1) { Player.make! }
  let(:p2) { Player.make! }

  before do
    @lead1 = Leaderboard.make!(:player => p1, :score => 1)
    @lead2 = Leaderboard.make!(:player => p2, :score => 2)
  end

  it "should create valid Leaderboard" do
    @lead1.player.should == p1
    @lead2.player.should == p2
  end

  it "should return the top players" do
    lead3 = Leaderboard.make!(:score => 3)

    players = Leaderboard.top_players
    players.size.should == 3
    players.first.should == lead3.player
    players.last.should == @lead1.player
  end
end
