var Board = function(){
  this.grid = [[null,null,null],[null,null,null],[null,null,null]];
}

Board.prototype.validMove = function(i, j) {
  return (!this.grid[i][j] && this.grid[i][j] !== undefined);
};

Board.prototype.makeMove = function(i, j, piece) {
  if (this.validMove(i, j)) {
   this.grid[i][j] = piece; 
   console.log("made move")
   return true;
  } 
  console.log("Invalid Move!")
  return false;
};

Board.prototype.isWon = function() {
  var lines = this.grid.concat(this.columns()).concat(this.diagonals());
  for(var i = 0; i < lines.length; i++){
    if (lines[i][0] === lines[i][1] && lines[i][0] === lines[i][2]){
      if (lines[i][0] === null) {
        continue;
      } else {
       return lines[i][0]; 
      }
    }
  }
  return false;
};

Board.prototype.columns = function() {
  var board = this.grid
  var transposed = this.grid.map(function(row, i){
    return row.map(function(square, j){
      return board[j][i];
    });
  });
  return transposed;
};

Board.prototype.diagonals = function() {
  var board = this.grid
  var coords = [[[0, 0], [1, 1], [2, 2]], [[2, 0], [1, 1], [0, 2]]];
  diags = coords.map(function(sub){
    return sub.map(function(coord){
      return board[coord[0]][coord[1]];
    });
  });
  return diags;
};

Board.prototype.display = function() {
  var mappedGrid = this.grid.map(function(line){
    return JSON.stringify(line);
  })
  console.log(mappedGrid.join("\n"))
};

module.exports = Board;

