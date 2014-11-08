var TTT = require("./t3");
var readline = require('readline');

var reader = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

game = new TTT.Game(reader);

game.run(function(){});