var Coord = function(i, j) {
  this.i = i;
  this.j = j;
};

Coord.prototype.plus = function(otherCoord) {
  return new Coord(this.i + otherCoord.i, this.j + otherCoord.j);
}

Coord.prototype.equals = function(otherCoord) {
  return (this.i === otherCoord.i && this.j === otherCoord.j)
}

var Snake = function(start) {
  this.dir = "S";
  this.segments = [start];
  this.grow = false;
}


Snake.directions = {
  "N": new Coord(-1, 0), 
  "E": new Coord(0, 1), 
  "S": new Coord(1, 0),
  "W": new Coord(0, -1)
};

Snake.prototype.getMoveVector = function(){
  return Snake.directions[this.dir];
}

Snake.prototype.isOverlapped = function() {
  for (var i = 1; i < this.segments.length; i++) {
    if (this.segments[0].equals(this.segments[i])) {
      return true;
    }
  }
  return false;
}

Snake.prototype.move = function(){
  var snake = this;
  this.segments.unshift( this.segments[0].plus(this.getMoveVector()) );
  if (!this.grow) {
    this.segments.pop();
  }
  this.grow = false;
};

Snake.prototype.turn = function(dir){
  this.dir = dir;
};

var Board = function(dim){
  //this.grid = Board.buildBoard(dim);
  this.dim = dim;
  this.snake = new Snake(new Coord(0,0));
  this.apple = this.generateApple();
}

Board.buildBoard = function(dim) {
  result = [];
  for (var i = 0; i < dim * dim; i++) {
      result.push(null);
  }
  return result;
}

Board.prototype.isOutOfBounds = function(){
  var coord = this.snake.segments[0];
  return (coord.i < 0 || coord.j < 0 ||
     coord.i >= this.dim || coord.j >= this.dim);
};

Board.prototype.isOver = function(){
  return this.isOutOfBounds() || this.snake.isOverlapped();
}

Board.prototype.generateApple = function() {
  var coord;
  var found = false
  while (!found) {
    coord = this.randomPos();
    found = true
    for (var i = 0; i < this.snake.segments.length; i++) {
      if (this.snake.segments[i].equals(coord)) {
        found = false;
        break;
      }
    }
  }
  
  return coord;
}

Board.prototype.randomPos = function(){
  var coords = []
  for (var i = 0; i < 2; i++ ){
    coords.push(Math.floor(Math.random() * this.dim));
  }
  return new Coord(coords[0], coords[1]);
}

Board.prototype.step = function(){
  this.snake.move();
  var head = this.snake.segments[0];
  if (head.equals(this.apple)) {
    this.snake.grow = true;
    this.apple = this.generateApple();
  }
}

Board.prototype.render = function() {
  var board = Board.buildBoard(this.dim);
  var dim = this.dim; 
  
  this.snake.segments.forEach(function(segment){
    if (segment.j >= 0 || segment.j < dim) {
      board[segment.i * dim + segment.j] = "S";
    }
  });
  
  if (this.apple) {
    board[this.apple.i * dim + this.apple.j] = "A" 
  }
  
  return board;
}