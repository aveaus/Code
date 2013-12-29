class GamesController < ApplicationController
  def index
    @top_players = Leaderboard.top_players
    @player = current_player
  end

  #POST /games
  #POST /games.json
  def create
    @player = current_player || Player.find_by_id(params[:id])

    @game = Game.new_game(@player)
    @game.save!

    # get the current leaderboard
    @leaderboard = Leaderboard.top_players.collect{|p| [p.name, p.score]}.flatten

    # find automated first move of the first player
    @first_player = @game.player_one
    @moves = @first_player.first_move(@game.grid, @game.find_opponent(@first_player))

    # if first player is AI player
    move = @moves.try(:first)
    @game.grid.state[move] = @first_player.id if move.present?
    @game.grid.save!  # need to explicitly persist grid

    render :json => {:errors => nil, :gid => @game.id, :first_move => move, :leaderboard => @leaderboard }
  end

  # PUT /games/1
  # PUT /games/1.json
  def update
    @game = Game.find_by_id(params[:id])

    @player = current_player || Player.find_by_id(params[:pid])
    @opponent = @game.find_opponent(@player)

    # save player's move
    move = params[:move]
    @game.grid.state[move] = @player.id

    # if the game is not won yet by the player
    if !@game.grid.winner?(@player.id)
      # find the moves the opponent will take
      moves = @opponent.move(@game.grid, @player.id)
      opponent_move = moves.try(:first)

      # if opponent doesn't have the next move then the game is tied
      if opponent_move.present?
        @game.grid.state[opponent_move] = @opponent.id
      else
        result = "You are tied!"
      end
    end
    @game.grid.save!  # need to explicitly persist the grid

    # check if the opponent's move result in a win
    if @game.grid.dup.winner?(@opponent.id)
      result = "You lost..."

    end

    render :json => {:errors => nil, :gid => @game.id, :move => opponent_move, :result => result}
  end
end
