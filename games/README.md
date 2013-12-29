Tic Tac Toe Game
===
Implemented using the strategy in this [Wikipedia article](http://en.wikipedia.org/wiki/Tic-tac-toe)

### Info
The starting player is randomized between the current player or the AI player
* This Tic-tac-toe game is also deployed to [Heroku](http://afternoon-lake-5271.herokuapp.com/)

`$ rake db:migrate`

`$ rails server`

### Tech Stacks
* Ruby 1.9.3
* Rails 3.2.13: persist the Player and Game information
* Machinist: to create blueprint for each model
* Rspec: for testing models and controllers logics
* Haml: cleaner markup
* Heroku: just for fun

### Future Improvements
* Leaderboard is not implemented yet, it should display the players who played the most games
