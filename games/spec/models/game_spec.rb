require 'spec_helper'

describe Game do
  before do
    @game = Game.make!
    @p1 = Player.make!
    #@AI = Player.make!(:name => "AI", :role => "ai")
  end

  it "should create a valid Game" do
    @game.should_not be_nil
    @game.player_one.should_not be_nil
    @game.player_two.should_not be_nil

    @game.player_one_id = @p1.id
    @game.save!
    @game.player_one.should == @p1
  end

  it "should return a game winner" do
    @game.game_winner.should be_nil

    @game.winner = 1
    @game.save!
    @game.game_winner.should == @game.player_one
  end

  describe ".opponent" do
    it "should find the opponent for each player" do
      @game.find_opponent(@game.player_one).should == @game.player_two
      @game.find_opponent(@game.player_two).should == @game.player_one
    end
  end

  describe "Find Games" do
    before do
      @g1 = Game.make!(:first, :player_one_id => @p1.id)
      @g2 = Game.make!(:second, :player_two_id => @p1.id)
      @g3 = Game.make!(:first, :player_one_id => @p1.id)
    end

    it "should find all the games played by a player" do
      @g1.created_at.should < @g2.created_at

      games = Game.games_played_for_player(@p1)
      games.size.should == 3
      games.first.should == @g3
      games.last.should == @g1
    end

    it "should return the last game played by the player" do
      g4 = Game.make!(:second, :player_two_id => @p1.id)
      game = Game.last_game_for_player(@p1)
      game.should == g4
    end
  end

  describe "New Game" do
    it "should create a new game with player" do
      game = Game.new_game(@p1)
      game.save!

      game.player_one.should_not == game.player_two
    end
  end
end
