var SnakeView = function($el, dim) {
  this.dim = dim
  this.$el = $el;
  this.setUpGrid();
  this.$divs = $el.find(".square");
};

SnakeView.prototype.run = function() {
  this.board = new Board(this.dim);
  this.bindListeners();
  var sv = this;

  this.interval = setInterval(function() {
      sv.step();
    if (sv.board.isOver()) {
      console.log(sv.board);
      sv.end();
      alert("game is over, fun is over, back to work!")
    }
   
  }, 500);
};

SnakeView.prototype.end = function(){
   clearInterval(this.interval);
}

SnakeView.prototype.setUpGrid = function(){
  for (var i = 0; i < this.dim * this.dim; i++) {
    var myDiv = $("<div></div>").addClass("square");
    this.$el.append(myDiv);
  }
  
}

SnakeView.prototype.bindListeners = function() {
  var board = this.board;
  $(document).on("keydown", function(event) {
    var dir = {40: "S", 37: "W", 38: "N", 39: "E"}[event.keyCode];
    if (dir) {
      board.snake.turn(dir);      
    }
  });
}

SnakeView.prototype.step = function(){
  this.board.step();
  if (!this.board.isOver()){
    this.update();
  }
}

SnakeView.prototype.update = function() {
  var array = this.board.render();
  var classes = {
    "S" : "snake",
    "A" : "apple"
  };
  
  this.$divs.each(function(i){
    if (array[i]){
      $(this).removeClass("snake apple");
      $(this).addClass(classes[array[i]]);
    } else {
      $(this).removeClass("snake apple");
    }
  });
}