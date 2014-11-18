Pokedex.RootView.prototype.renderPokemonDetail = function (pokemon) {
  var $div = $("<div>").addClass("detail");
  _.each(pokemon.attributes, function(val, attr){
    if (attr !== "image_url") {
      var $li = $("<li>");
      $li.append( $("<strong>").text(attr) );
      $li.append(": " + val);
      $li.appendTo($div);
    }
  });
  
  $("<img>").attr("src", pokemon.get("image_url")).appendTo($div);
  $("<ul>").addClass("toys").appendTo($div);
  this.$pokeDetail.html($div);
  
  var rootView = this;
  pokemon.fetch({
    success: function(){ 
      pokemon.toys().each(function(toy){
        rootView.addToyToList(toy);
      });
    }
  })

};

Pokedex.RootView.prototype.selectPokemonFromList = function (event) {
  var id = $(event.currentTarget).data("id"),
    pokemon = this.pokes.get(id);
  this.renderPokemonDetail(pokemon);
};
