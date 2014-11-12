var Board = require("./board");



var Game = function(reader) {
  this.player1Mark = "x";
  this.player2Mark = "o";
  this.reader = reader
  this.currentPlayer = "player1Mark"
};

Game.prototype.run = function(completionCallback) {
  this.board = new Board();
  this.takeTurn(completionCallback);
};

Game.prototype.movePrompt = function(callback) {
  this.reader.question("Make your move", function(answer){
    var move = Game.parseMove(answer);
    callback(move);
  });
};

Game.prototype.takeTurn = function(completionCallback) {
  var game = this;
  game.board.display()
  this.movePrompt(function(move){
    moveMade = game.board.makeMove(move[0], move[1], game[game.currentPlayer]);
    if (moveMade) {
      if (game.board.isWon()) {
        game.board.display();
        console.log(game.board.isWon() + " wins!");
        game.reader.close();
        completionCallback();
      } else {
        game.switchPlayer();
        game.takeTurn(completionCallback);
      }
    } else {
      game.takeTurn(completionCallback);
    }
  });
};

Game.parseMove = function(move) {
  return move.split(",").map(function(el){
    return parseInt(el);
  });
};

Game.prototype.switchPlayer = function() {
  this.currentPlayer = (this.currentPlayer === "player1Mark" ? "player2Mark" : "player1Mark");
}

module.exports = Game;