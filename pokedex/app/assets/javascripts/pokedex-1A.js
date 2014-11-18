Pokedex.RootView.prototype.addPokemonToList = function (pokemon) {
  var $li = $("<li>").text(pokemon.escape("name") + ": " + 
    pokemon.escape("poke_type")).addClass("poke-list-item");
  
  $li.data("id", pokemon.id);
  this.$pokeList.append($li);
};

Pokedex.RootView.prototype.refreshPokemon = function (callback) {
  var rootView = this;
  this.pokes.fetch({
    success: function(collection, response) {
      collection.each(function(pokemon){
        rootView.addPokemonToList(pokemon);
      });
    }
  })
};
