Pokedex.RootView.prototype.addToyToList = function (toy) {
  var text = [
    toy.get("name"), 
    toy.get("price"), 
    toy.get("happiness")
  ].join(", ");
  
  var $li = $("<li>").text(text).addClass("toy");
  $li.data({ 
    "toy-id": toy.get('id'),
    "pokemon-id": toy.get("pokemon_id")
  });

  this.$pokeDetail.find("ul.toys").append($li);
};

Pokedex.RootView.prototype.renderToyDetail = function (toy) {
  var $div = $("<div>").addClass("detail");
  
  _.each(toy.attributes, function(val, attr){
    if (attr !== "image_url") {
      var $li = $("<li>");
      $li.append( $("<strong>").text(attr) );
      $li.append(": " + val);
      $li.appendTo($div);
    }
  });
  
  $("<img>").attr("src", toy.get("image_url")).appendTo($div);
  
  this.$toyDetail.html($div)
};

Pokedex.RootView.prototype.selectToyFromList = function (event) {
  var toyId = $(event.currentTarget).data("toy-id"),
    pokemonId = $(event.currentTarget).data("pokemon-id");
  
  this.renderToyDetail(this.pokes.get(pokemonId).toys().get(toyId));
};
