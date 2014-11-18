Pokedex.RootView.prototype.createPokemon = function (attrs, callback) {
  var pokemon = new Pokedex.Models.Pokemon();
  
  pokemon.save(attrs, {
    success: callback,
    error: function(model, message) {
      console.log(message.responseText);
    }
  })
};

Pokedex.RootView.prototype.submitPokemonForm = function (event) {
  event.preventDefault();
  var data = $(event.currentTarget).serializeJSON();
  
  this.createPokemon(data.pokemon, function (model) {
    this.pokes.push(model);
    this.addPokemonToList(model);
    this.renderPokemonDetail(model);
  }.bind(this));
};