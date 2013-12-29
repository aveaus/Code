require 'spec_helper'

describe Player do
  before do
    @player = Player.make
    @board = Leaderboard.make(:player => @player)
    @board.save!

    @game = Game.make(:first, :player_one_id => @player.id)
    @game.save!
  end

  it "should create a valid Player" do
    @player.should_not be_nil
    @player.role.should == "player"
    @player.leaderboard.should_not be_nil
    @player.leaderboard.score.should == 0

    @player.games.should_not be_nil
    @player.games.first.should == @game
  end

  it "should check for AI player" do
    ai = Player.make!(:ai)
    ai.is_ai?.should be_true

    @player.is_ai?.should be_false
  end

  it "should find the player's score" do
    @player.score.should == 1
    game2 = Game.make!(:first, :player_two_id => @player.id)
    game3 = Game.make!(:first, :player_one_id => @player.id)

    @player.score.should == 3
  end

  describe "AI" do
    let(:player) { Player.make! }
    let(:ai) { Player.make!(:ai) }
    let(:grid) { Grid.make }

    it "should pick the corner first move for AI" do
      player.first_move(grid, ai.id).should be_nil

      ai.first_move(grid, player.id).should include("1,1")
    end

    it "should #{1} find a winning move if there is a one" do
      grid.state["1,1"] = ai.id
      grid.state["1,2"] = ai.id
      grid.save!

      ai.move(grid, player.id).should include("1,3")
    end

    it "should #{2} block a opponent's winning move" do
      # need to block player's move to create 3 in a row
      grid.state["1,1"] = ai.id
      grid.state["1,3"] = player.id
      grid.state["2,3"] = player.id
      grid.save!

      ai.move(grid, player.id).should include("3,3")
    end

    it "should #{3} find a forking opportunity" do
      # should return "3,1" as one of the forking opportunity
      grid.state["1,1"] = ai.id
      grid.state["3,2"] = ai.id
      grid.save!

      ai.move(grid, player.id).should include("3,1", "2,2", "1,2", "3,3")

      # if another player had marked
      grid.state["2,2"] = player.id
      grid.state["1,2"] = player.id
      grid.save!

      ai.move(grid, player.id).should include("3,1")
    end

    it "should #{4} block an opponent's forking" do
      # should return "3,1" as a blocking forking move
      grid.state["2,2"] = ai.id
      grid.state["1,2"] = ai.id
      grid.state["1,1"] = player.id
      grid.state["3,2"] = player.id
      grid.save!      

      ai.move(grid, player.id).should include("3,1")
    end

    it "should #{5} mark the center if it is available" do
      ai.move(grid, player.id).should include("2,2")
    end

    it "should #{6} mark the opponent corners" do
      grid.state["1,1"] = player.id
      grid.state["2,2"] = ai.id
      grid.save!

      ai.move(grid, player.id).should include("3,3")
    end

    it "should #{7} mark the empty corner" do
      grid.state["1,1"] = player.id
      grid.state["2,2"] = ai.id
      grid.state["3,3"] = player.id
      grid.save!

      ai.move(grid, player.id).should include("3,1")
    end
  end
end
