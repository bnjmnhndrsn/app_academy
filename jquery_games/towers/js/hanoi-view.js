(function(){
var View = Hanoi.View = function (game, $el) {
  this.game = game;
  this.$el = $el;
  this.render();
  this.bindHandlers();
};

View.prototype.render = function(){
  var view = this;
  this.$el.find(".tower").each(function(index) {
    $(this).html(JSON.stringify(view.game.towers[index]));
  })
}

View.prototype.clickTower = function($tower) {
  if (this.selected){
    var successful = this.game.move(this.selected.data("id"), $tower.data("id"));
    if (successful){
      this.selected.toggleClass("selected");
      this.selected = null;
      this.render();
      if (this.game.isWon()) {
        alert("You've won!");
      }
    }
    else {
      alert("invalid move!");
    }
    
  } else {
    this.selected = $tower;
    this.selected.toggleClass("selected");
  }
};

View.prototype.bindHandlers = function(){
  var view = this;
  this.$el.find(".tower").click(function(){
    view.clickTower( $(this) );
  });
};

})();