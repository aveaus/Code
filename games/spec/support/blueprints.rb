require 'machinist/active_record'

Player.blueprint do
  name { Faker::Name.name }
end
Player.blueprint(:ai) do
  name { "AI" }
  role { "ai" }
end

Game.blueprint do
  players = random_starting_players
  player_one_id { players[0].id }
  player_two_id { players[1].id }
  grid { Grid.make }
end
Game.blueprint(:first) do
  player_one_id { Player.make!.id }
  player_two_id { Player.make!(:ai).id }
end
Game.blueprint(:second) do
  player_one_id { Player.make!(:ai).id }
  player_two_id { Player.make!.id }
end
def random_starting_players
  first_ai = [true, false].sample
  player_one = first_ai ? Player.make!(:ai) : Player.make!
  player_two = first_ai ? Player.make! : Player.make!(:ai)

  [player_one, player_two]
end

Leaderboard.blueprint do
  player { Player.make }
end

Grid.blueprint do
  state { 
    {'1,1' => nil,
      '1,2' => nil,
      '1,3' => nil,
      '2,1' => nil,
      '2,2' => nil,
      '2,3' => nil,
      '3,1' => nil,
      '3,2' => nil,
      '3,3' => nil
    }
  }
end
