var readline = require('readline');
var reader = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

var addNumbers = function(sum, numsLeft, completionCallback) {
  if (numsLeft === 0) {
    completionCallback(sum);
  } else {
    reader.question("What number do you want to add?", function(response) {
      var num = parseInt(response);
      console.log(sum + num);
      addNumbers(sum + num, numsLeft - 1, completionCallback);
    });
  }
};

addNumbers(0, 3, function (sum){
  console.log("Total sum:" + sum);
});