require 'spec_helper'

describe Grid do
  before do
    @grid = Grid.make!
  end

  it "should create a valid Grid" do
    @grid.should_not be_nil
    @grid.state.should_not be_nil
    @grid.state.size == 9
  end

  it "should return empty for a grid" do
    @grid.empty?.should be_true

    @grid.state["1,1"] = 1
    @grid.save!
    @grid.empty?.should be_false
  end

  describe "Find winner" do
    it "should return winner for a row" do
      @grid.state['1,1'] = 1
      @grid.state['1,2'] = 1
      @grid.save!

      @grid.winner(1).should be_false

      @grid.state['1,3'] = 1
      @grid.winner(1).should be_true
    end

    it "should return winner for a column" do
      @grid.state['1,1'] = 1
      @grid.state['2,1'] = 1
      @grid.save!

      @grid.winner(1).should be_false

      @grid.state['3,1'] = 1
      @grid.winner(1).should be_true
    end

    it "should return winner for a diagonal" do
      @grid.state['1,1'] = 1
      @grid.state['2,2'] = 1
      @grid.save!

      @grid.winner(1).should be_false

      @grid.state['3,3'] = 1
      @grid.winner(1).should be_true
    end
  end

  describe "Possible moves & spaces" do
    it "should return all indexes for an empty side" do
      moves = @grid.possible_moves_per_line(['1,1', '1,2', '1,3'])

      moves.size.should == 3
      moves.should include('1,1', '1,2', '1,3')
    end

    it "should return only the indexes that are empty" do
      @grid.state['1,1'] = 1
      @grid.state['1,3'] = 1
      @grid.save!

      moves = @grid.reload.possible_moves_per_line(['1,1', '1,2', '1,3'])
      moves.size.should == 1
      moves.should include('1,2')
    end

    it "should return an empty index for a side that's full" do
      @grid.state['1,1'] = 1
      @grid.state['1,2'] = 2
      @grid.state['1,3'] = 1
      @grid.save!

      moves = @grid.reload.possible_moves_per_line(['1,1', '1,2', '1,3'])
      moves.size.should == 0
    end

    it "should return 0 as number of marked spaces for empty side" do
      marked = @grid.number_of_marked_spaces(['1,1', '1,2', '1,3'], 1)
      marked.should == 0
    end

    it "should return the number of marked spaces" do
      @grid.state['1,1'] = 1
      @grid.state['1,3'] = 2
      @grid.save!

      marked = @grid.number_of_marked_spaces(['1,1', '1,2', '1,3'], 1)
      marked.should == 1
    end

    it "should all the empty space as possible moves" do
      @grid.state['1,1'] = 1
      @grid.save!

      moves = @grid.all_possible_moves
      moves.size.should == 8
      moves.should_not include("1,1")
    end

    it "should return marked spaces for a player" do
      @grid.state["1,1"] = 1
      @grid.state["3,3"] = 1
      @grid.save!

      spaces = @grid.all_marked_spaces(1)
      spaces.size.should == 2
      spaces.should include("1,1", "3,3")
    end
  end

  describe "Three in a line" do
    it "should not find any index if that's not possible for three in a line" do
      moves = @grid.three_in_a_row(1)
      moves.size.should == 0
    end

    it "should find three in a line for a row" do
      @grid.state['1,1'] = 1
      @grid.state['1,3'] = 1
      @grid.save!

      moves = @grid.three_in_a_row(1)
      moves.size.should == 1      
      moves.first.should == '1,2'
    end

    it "should find three in a line for multiple rows, columns, and diagonals" do
      @grid.state['1,1'] = 1
      @grid.state['1,2'] = 1
      @grid.state['2,2'] = 1
      @grid.save!

      moves = @grid.three_in_a_row(1)
      moves.size.should == 3     
      moves.should include('1,3', '3,2', '3,3')
    end
  end

  describe "Find type of box within the grid" do
    it "should determine if a box is corner" do
      Grid.corner?('1,1').should be_true
      Grid.corner?('1,2').should be_false
      Grid.corner?('2,2').should be_false
    end

    it "should return the opposite corner" do
      Grid.opposite_corner('1,1').should == "3,3"
      Grid.opposite_corner('1,3').should == "3,1"

      Grid.opposite_corner('1,2').should be_nil
    end

    it "should determine if a box is a middle of four side" do
      Grid.middle?("1,2").should be_true
      Grid.middle?("2,3").should be_true

      Grid.middle?("1,1").should be_false
      Grid.middle?("3,1").should be_false
    end
  end

end
