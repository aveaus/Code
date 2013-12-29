class Player < ActiveRecord::Base
  has_one :leaderboard
  has_many :player_one_games, :class_name => "Game", :foreign_key => "player_one_id", :order => "created_at DESC"
  has_many :player_two_games, :class_name => "Game", :foreign_key => "player_two_id", :order => "created_at DESC"

  delegate :score, :to => :leaderboard

  attr_accessible :name, :role

  # all games sorted by 'created_at'
  def games
    (player_one_games + player_two_games).sort {|x, y|
      x.created_at <=> y.created_at
    }
  end

  # player's score is the number of games they have played
  def score
    Game.count(:conditions => ["player_one_id = :id or player_two_id = :id", :id => self.id])
  end

  # determine if the player is AI player
  def is_ai?
    name == "AI" && role == "ai"
  end

  # Playing a corner is the best opening move
  def first_move(grid, opponent_id)
    return move(grid, opponent_id) if !grid.empty?

    ["1,1"] if self.is_ai?
  end

  # AI player chooses the first possible moves
  def move(grid, opponent_id)
    # 1. If player can win
    winning_step = win(grid)
    return winning_step if winning_step.present?

    # 2. If player need to block
    blocking_step = block(grid, opponent_id)
    return blocking_step if blocking_step.present?

    # 3. Fork opportunity
    forking = fork(grid)
    return forking if forking.present?

    # 4. Blocking an opponent's fork:
    block_forking = block_fork(grid, opponent_id)
    return block_forking if block_forking.present?

    # 5. Center    
    centering = center(grid)
    return centering if centering.present?

    # 6. Opposite corner
    opposite = opposite_corner(grid, opponent_id)
    return opposite if opposite.present?

    # 7. Empty corner
    empty_cornering = empty_corner(grid)
    return empty_cornering if empty_cornering.present?

    # 8. Empty side
    empty_siding = empty_side(grid)
    return empty_siding if empty_siding.present?

    # default to nil
    nil
  end

private
  # Win: If the player has two in a row, they can place a third to get three in a row.
  def win(grid)
    threes = grid.three_in_a_row(self.id)
    threes if threes.present?
  end

  # Block: If the [opponent] has two in a row, the player must play the third themself to block the opponent.
  def block(grid, opponent_id)
    threes = grid.three_in_a_row(opponent_id)
    threes if threes.present?
  end

  # Fork: Creation of an opportunity where the player has two threats to win (two non-blocked lines of 2).
  def fork(grid, id=nil)
    id ||= self.id
    moves = grid.all_possible_moves

    # clone the grid to determine all forking opportunity
    fork_moves = moves.collect {|move| 
      gc = grid.dup
      gc.state = grid.state.dup

      # each possible move to check if there are two ways of making three in a line
      gc.state[move] = id
      threes = gc.three_in_a_row(id)

      move if threes.size >= 2
    }

    fork_moves = fork_moves.compact
  end

  # Blocking an opponent's fork:
  def block_fork(grid, opponent_id)
    fork(grid, opponent_id)
  end

  # Center: A player marks the center.
  def center(grid)
    ["2,2"] if grid.state["2,2"].nil?
  end

  # Opposite corner: If the opponent is in the corner, the player plays the opposite corner.
  def opposite_corner(grid, opponent_id)
    spaces = grid.all_marked_spaces(opponent_id)

    moves = spaces.collect {|space|
      if Grid.corner?(space)
        opposite = Grid.opposite_corner(space)
        opposite if grid.state[opposite].nil?
      end
    }.compact
  end

  # Empty corner: The player plays in a corner square.
  def empty_corner(grid)
    moves = Grid.corners.collect {|space|
      space if grid.state[space].nil?
    }.compact
  end

  # Empty side: The player plays in a middle square on any of the 4 sides.
  def empty_side(grid)
    moves = Grid.middles.collect {|space|
      space if grid.state[space].nil?
    }.compact
  end
end
