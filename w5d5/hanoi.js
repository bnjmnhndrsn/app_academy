var readline = require('readline');

var reader = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

var Hanoi = function(){
  this.stacks = [[3, 2, 1], [], []];    
};

Hanoi.prototype.isWon = function() {
  return (this.stacks[1].length === 3 || this.stacks[2].length === 3);
};

Hanoi.prototype.isValidMove = function(startTowerIdx, endTowerIdx){
  if (this.stacks[startTowerIdx].length === 0) {
    return false;
  } else if (this.stacks[endTowerIdx].length === 0){
    return true;
  }
  var startPlate = this.stacks[startTowerIdx].slice(-1)[0];
  var endPlate = this.stacks[endTowerIdx].slice(-1)[0];
  return (startPlate > endPlate) ? false : true;
};

Hanoi.prototype.move = function(startTowerIdx, endTowerIdx) {
 if (this.isValidMove(startTowerIdx, endTowerIdx)) {
   this.stacks[endTowerIdx].push(this.stacks[startTowerIdx].pop());
   return true;
 } 
 return false;
};

Hanoi.prototype.print = function() {
  console.log(JSON.stringify(this.stacks));
};

Hanoi.prototype.promptMove = function(callback) {
  this.print();
  
  reader.question("What tower would you like to move from?", function(num1) {
    reader.question("What tower would you like to move to", function(num2) {
      callback(num1, num2);
    });
  });
};

Hanoi.prototype.run = function(completionCallback) {
  var tower = this
  this.promptMove(function(num1, num2){
    var validMove = tower.move(parseInt(num1), parseInt(num2));
    
    if (validMove && tower.isWon()){
        console.log("You win!");
        tower.print();
        reader.close();
        
        return (completionCallback) ? completionCallback() : "" ;
        
    } else if (!validMove) {
      console.log("invalid move!");
    }
      
  tower.run(completionCallback);
    
  });
  
};

hanoi = new Hanoi();
hanoi.run()
