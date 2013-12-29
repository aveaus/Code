var Game = {
  id : null,
  container : null,
  enabled : null,

  init : function() {
    Game.container = $('.container');
    Game.Grid.init();
    Game.Player.init();
  },

  Grid : {
    container : null,

    init : function() {
      Game.Grid.container = Game.container.find('div.board');

      // allow 
      Game.Grid.container.find('div.grid ul li').click(function(evt) {
        var box = $(evt.target);

        // find if this box is not checked
        if(box.html() == "" && Game.enabled) {
          // mark the move
          box.html(Game.Player.symbol);

          // submit the move to the game
          var move = box.attr("data-id");
          var data = {"move" : move, "pid" : Game.Player.id};

          console.log(data)
          $.ajax({
            method: 'put',
            url: '/games/'+Game.id,
            data: data,
            success: function(result) {
              // all moves are exhausted, it's a tie
              if(result["move"] == null) {
                Game.container.find('div.result').html(result["result"]);
                Game.enabled = false;   // game grid disabled as game is over
              }
              else {
                var space = Game.Grid.container.find("li[data-id='"+result["move"]+"']");
                space.html(Game.Player.opponent);

                if(result["result"]) {
                  Game.container.find('div.result').html(result["result"]);
                  Game.enabled = false; // game grid disabled as game is over
                }
              }
            }
          });
        }
      });
    },

    clear : function() {
      Game.Grid.container.find('div.grid ul li').each(function() {
        $(this).html("");
      });

      Game.container.find('div.result').html("");
    }
  },
  
  Player : {
    id : null,
    container : null,
    symbol : null,
    opponent: null,

    init : function() {
      Game.Player.container = Game.container.find('div.player');

      // add handler to 'Add' button to add a Player
      Game.Player.container.find('div.add button').click(function(evt) {
        var name = Game.Player.container.find('input.name').val();

        if(name != "") {
          $.ajax({
            method: 'post',
            url: '/players',
            data: {"name" : name},
            success: function(result) {
              if(result["errors"] == null) {
                Game.Player.id = result["id"];
                Game.Player.container.find('div.game span').html("Welcome: "+result["name"]);
                Game.Player.container.find('div.add').toggle();
                Game.Player.container.find('div.game').toggle();
              }
            }
          });
        }
      });

      // add handler to 'New Game' button to create a new Game
      Game.Player.container.find('div.game button').click(function() {
        // clear the grid
        Game.Grid.clear();

        $.ajax({
          method: 'post',
          url: '/games',
          data: {"id" : Game.Player.id},
          success: function(result) {
            console.log(result)
            if(result["errors"] == null) {
              Game.Grid.container.show();
              Game.id = result["gid"];

              // game grid is enabled
              Game.enabled = true;

              // add the first step if it's there
              if(result["first_move"] != null) {
                Game.Player.symbol = "O";
                Game.Player.opponent = "X";

                var space = Game.Grid.container.find("li[data-id='"+result["first_move"]+"']");
                space.html(Game.Player.opponent);
              }
              else {
                Game.Player.symbol = "X";
                Game.Player.opponent = "O";
              }
            }
          }
        });
      });
    }
  }
}


$(document).ready(function(){
  Game.init();
})