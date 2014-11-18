window.Pokedex = (window.Pokedex || {});
window.Pokedex.Models = {};
window.Pokedex.Collections = {};

Pokedex.Models.Pokemon = Backbone.Model.extend({
  urlRoot: "pokemon/",
  toys: function(){
    this._toys = this._toys || new Pokedex.Collections.PokemonToys();
    return this._toys;
  },
  parse: function(payload){
    if (payload.toys) {
      this.toys().set( payload.toys, { parse: true } );
      delete payload.toys;
    }
    return payload;
  }
});

Pokedex.Models.Toy = Backbone.Model.extend({});

Pokedex.Collections.Pokemon = Backbone.Collection.extend({
  url: "pokemon/",
  model: Pokedex.Models.Pokemon
});

Pokedex.Collections.PokemonToys = Backbone.Collection.extend({
  model: Pokedex.Models.Toy
});

window.Pokedex.Test = {
  testShow: function (id) {
    var pokemon = new Pokedex.Models.Pokemon({ id: id });
    pokemon.fetch({
      success: function () {
        console.log(pokemon.toJSON());
      }
    });
  },

  testIndex: function () {
    var pokemon = new Pokedex.Collections.Pokemon();
    pokemon.fetch({
      success: function () {
        console.log(pokemon.toJSON());
      }
    });
  }
};

window.Pokedex.RootView = Backbone.View.extend({
  events: {
    "click .pokemon-list li": "selectPokemonFromList",
    "submit .new-pokemon": "submitPokemonForm",
    "click  .pokemon-detail ul.toys li": "selectToyFromList" 
  },
  initialize: function(options){
    this.$el = options.$el;
    this.pokes = new Pokedex.Collections.Pokemon();
    this.$pokeList = this.$el.find('.pokemon-list');
    this.$pokeDetail = this.$el.find('.pokemon-detail');
    this.$newPoke = this.$el.find('.new-pokemon');
    this.$toyDetail = this.$el.find('.toy-detail');
  }

});


window.Pokedex.RootView1 = function ($el) {
  this.$el = $el;
  this.pokes = new Pokedex.Collections.Pokemon();
  this.$pokeList = this.$el.find('.pokemon-list');
  this.$pokeDetail = this.$el.find('.pokemon-detail');
  this.$newPoke = this.$el.find('.new-pokemon');
  this.$toyDetail = this.$el.find('.toy-detail');
  
  //event handlers
  this.$pokeList.on("click", "li", this.selectPokemonFromList.bind(this));
  this.$newPoke.submit(this.submitPokemonForm.bind(this));
  this.$pokeDetail.on("click", "ul.toys li", this.selectToyFromList.bind(this));
};

$(function() {
  var $rootEl = $('#pokedex');
	window.Pokedex.rootView = new Pokedex.RootView({ $el: $rootEl });
  window.Pokedex.rootView.refreshPokemon();
});
