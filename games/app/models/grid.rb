class Grid < ActiveRecord::Base
  belongs_to :game

  serialize :state

  # initialize a 3x3 grid
  def self.build
    grid = Grid.new
    grid.state = {
      '1,1' => nil,
      '1,2' => nil,
      '1,3' => nil,
      '2,1' => nil,
      '2,2' => nil,
      '2,3' => nil,
      '3,1' => nil,
      '3,2' => nil,
      '3,3' => nil
    }
    grid
  end

  # there is a 3 in a row
  def winner?(id)
    winner_in_a_line?(all_rows, id) || winner_in_a_line?(all_columns, id) || winner_in_a_line?(all_diagonals, id)
  end

  def empty?
    !state.detect {|k, _|
      state[k] != nil
    }
  end

  # find the opposite corner
  def self.opposite_corner(corner)
    if Grid.corner?(corner) 
      corner = case corner
      when "1,1"
        "3,3"
      when "1,3"
        "3,1"
      when "3,1"
        "1,3"
      when "3,3"
        "1,1"
      end
    end
  end

  # find if a space is a corner space
  def self.corners
    ['1,1','1,3','3,1','3,3']
  end
  def self.corner?(space)
    corners.include?(space)
  end

  # determine if it's middle of empty side
  def self.middles
    ["1,2", "2,3", "3,2", "2,1"]
  end
  def self.middle?(space)
    middles.include?(space)
  end

  # find all three in a row opportunity
  def three_in_a_row(id)
    result = []

    # find possible three in a row
    result << find_three_in_a_line(all_rows, id)
    # find possible three in a column
    result << find_three_in_a_line(all_columns, id)
    # find possible three in a diagonal
    result << find_three_in_a_line(all_diagonals, id)

    result.compact.flatten
  end

  def all_possible_moves
    moves = state.collect {|k, _|
      k if state[k].nil?
    }.compact
  end

  def possible_moves_per_line(line)
    # find empty space
    moves = line.collect {|g|
      g if state[g].nil?
    }.compact
  end

  def number_of_marked_spaces(line, id)
    count = line.count {|r|
      state[r] != nil && state[r] == id
    }
  end

  def all_marked_spaces(id)
    spaces = state.collect{|k, _|
      k if state[k] == id
    }.compact
  end

private
  def winner_in_a_line?(line, id)
    line.detect {|r|
      marked = number_of_marked_spaces(r, id)
      marked == 3
    }
  end

  def find_three_in_a_line(line, id)
    result = []
    line.each {|r|
      marked = number_of_marked_spaces(r, id)
      moves = possible_moves_per_line(r)

      result << moves if marked == 2 and moves.size == 1
    }
    result
  end

  def all_rows
    [
      ['1,1', '1,2', '1,3'],
      ['2,1', '2,2', '2,3'],
      ['3,1', '3,2', '3,3']
    ]
  end

  def all_columns
    [
      ['1,1', '2,1', '3,1'],
      ['1,2', '2,2', '3,2'],
      ['1,3', '2,3', '3,3']
    ]
  end

  def all_diagonals
    [
      ['1,1', '2,2', '3,3'],
      ['1,3', '2,2', '3,1']
    ]
  end 
end
