class PlayersController < ApplicationController
  # POST /players
  # POST /players.json
  def create
    @player = Player.find_by_name(params[:name])

    # if player is not registered
    if @player.nil?
      # create player and leaderboard
      @player = Player.create(:name => params[:name])
      @player.leaderboard = Leaderboard.new
      @player.save!

      session[:player_id] = @player.id
    elsif @player.is_ai?
      errors = "You are not the AI"
      
      session[:player_id] = nil
    end

    render :json => {:errors => errors, :name => @player.name, :id => @player.id}
  end
end
