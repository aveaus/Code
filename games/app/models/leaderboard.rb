class Leaderboard < ActiveRecord::Base
  belongs_to :player

  def self.top_players
    @boards = top_leaderboards
    @boards.collect {|b| b.player }
  end

private 
  def self.top_leaderboards
    Leaderboard.find(:all, :order => "score DESC", :limit => 10, :include => [:player])
  end
end
