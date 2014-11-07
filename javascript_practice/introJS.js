var uniq = function (array) {
  var newArray = [];
  array.forEach(function(num) {
    if (newArray.indexOf(num) === -1) {
      newArray.push(num);
    }
  });
  
  return newArray;
};

var twoSum = function(array){
  var ret = [];
  
  for (var i = 0; i < array.length - 1; i++){
    for (var j = i + 1; j < array.length; j++){
      if (array[i] + array[j] === 0) {
        ret.push([i, j]);
      }
    }
  }
  
  return ret;
};

var transpose = function(matrix){
  var newMatrix = matrix.map(function(row, i){
    return row.map(function(square, j){
      return matrix[j][i];
    });
  });
  
  return newMatrix;
};

var timesTwo = function(array) {
  return array.map(function(n){
    return n * 2;
  });
};

Array.prototype.myEach = function(callback){
  var length = this.length;
  
  for (var i = 0; i < length; i++){
    callback(this[i]);
  }
  
};

Array.prototype.median = function(){
  var sorted = this.sort(function(a, b){
     return a - b;
  });
  
  var middle = Math.floor(sorted.length / 2) 
  
  if (sorted.length % 2 === 0){
    return (sorted[middle] + sorted[middle - 1]) / 2;
  } else {
    return sorted[middle];
  }
};

Array.prototype.myMap = function(callback){
  var returnArray = [];
  
  this.myEach(function(num){
    returnArray.push(callback(num));
  });
  
  return returnArray;
};

Array.prototype.myInject = function(callback){
  var total = this[0];
  
  this.slice(1).myEach(function(num){
    total = callback(total, num);
  });
  
  return total;
};

var bubbleSort = function(array) {
  var end = array.length - 1;
  var sorted = false;
  
  while (!sorted) {
    sorted = true;
    for (var i = 0; i < end; i++) {
      console.log(array);
      if (array[i] > array[i + 1]) {
        sorted = false;
        var swapped = [array[i + 1], array[i]];
        array[i] = swapped[0], array[i + 1] = swapped[1];
      } 
    }
    end--;   
  }
  
  return array;
}

var substrings = function(string) {
  var subs = []
  length = string.length
  
  for (var i = 0; i < length; i++) {
    for (var j = i + 1; j <= length; j++) {
      var sub = string.substring(i,j);
      if (subs.indexOf(sub) === -1) {
        subs.push(sub);
      }
    }
  }
  
  return subs;
}

var range = function(start, end) {
  if (start > end) {
    return [];
  } else {
  return [start].concat(range(start + 1, end));
  }
}

var sum = function(ary) {
  return (ary.length < 2) ? ary[0] : ary[0] + sum(ary.slice(1));
}

var recExp = function(base, exp) {
  if (exp === 0) {
    return 1;
  } else {
    return base * recExp(base, exp - 1);
  }
}

var recFib = function(n) {
  console.log(n)
  if (n === 1) {
    return [1];
  } else if (n === 2) {
    return [1, 1];
  } else {
    var previous = recFib(n - 1);
    console.log(previous);
    var lastTwo = previous.slice(-2);
    // console.log(lastTwo);
    return previous.concat([lastTwo[0] + lastTwo[1]]);
  }
};

Array.prototype.binarySearch = function(target) {
  var length = this.length;
  var middle = Math.floor(length / 2);
  if (length === 0) {
    return -1;
  } else if (this[middle] === target) {
    return middle;
  } else if (target < this[middle]) {
    return this.slice(0, middle).binarySearch(target);
  } else {
    var remainder = this.slice(middle + 1).binarySearch(target);
    if (remainder === -1) {
      return -1;
    } else { 
      return middle + 1 + remainder;
    } 
  }
}

var mergeSort = function(array) {
  var length = array.length;
  var middle = Math.floor(length / 2);
  
  if (length < 2) {
    return array;
  } else {
    return merge(mergeSort(array.slice(0, middle)), 
      mergeSort(array.slice(middle)));
  }
}

var merge = function(arr1, arr2) {
  var merged = []
  
  console.log(arr1, arr2);
  while (arr1.length > 0 && arr2.length > 0) {
    if (arr1[0] < arr2[0]) {
      merged.push(arr1.shift());
    } else {
      merged.push(arr2.shift());
    }
  }
  
  return merged.concat(arr1).concat(arr2);
}

var subsets = function(array) {
  if (array.length === 0) {
    return [[]];
  } else {
    var smallerSubsets = subsets(array.slice(0, -1));
    var firstHalf = smallerSubsets.map( function(arr) {
      return arr.concat(array.slice(-1));
    })
    return smallerSubsets.concat(firstHalf);
  }
}