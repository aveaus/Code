class Game < ActiveRecord::Base
  has_one :grid

  belongs_to :player_one, :class_name => "Player", :foreign_key => "player_one_id"
  belongs_to :player_two, :class_name => "Player", :foreign_key => "player_two_id"

  serialize :moves

  def find_opponent(player)
    return player_two if player_one == player
    return player_one if player_two == player
  end

  def tied_game
    game
  end

  def game_winner
    if winner == 1
      player_one
    elsif winner == 2
      player_two
    end
  end

  def self.new_game(player)
    game = Game.new

    # assign different player
    ai_player = find_ai

    first = first_player?
    game.player_one_id = first ? player.try(:id) : ai_player.try(:id)
    game.player_two_id = first ? ai_player.try(:id) : player.try(:id)
    game.grid = Grid.build

    game
  end

  def self.games_played_for_player(player)
    return nil if player.nil?

    conditions = ['player_one_id = ? OR player_two_id = ?', player.id, player.id]
    Game.find(:all, :conditions => conditions, :order => "created_at DESC")
  end

  def self.last_game_for_player(player)
    return nil if player.nil?

    conditions = ['player_one_id = ? OR player_two_id = ?', player.id, player.id]
    Game.find(:first, :conditions => conditions, :order => "created_at DESC", :limit => 1)
  end

private
  def self.first_player?
    [true, false].sample
  end

  def self.find_ai
    Player.find_by_role("ai")
  end
end
