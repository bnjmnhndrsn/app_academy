function Clock () {
}

Clock.TICK = 5000;

Clock.prototype.printTime = function () {
  // Format the time in HH:MM:SS
  var hours = this.time.getUTCHours();
  var minutes = this.time.getUTCMinutes();
  var seconds = this.time.getUTCSeconds();
  console.log(hours + ":" + minutes + ":" + seconds)
  
  
};

Clock.prototype.run = function () {
  this.time = new Date();
  this.printTime();
  setInterval(this._tick.bind(this), 5000);
  
  // 1. Set the currentTime.
  // 2. Call printTime.
  // 3. Schedule the tick interval.
};

Clock.prototype._tick = function () {
  var start = this.time.getUTCMilliseconds();
  var end = this.time.setUTCMilliseconds(start + Clock.TICK);
  this.time = new Date(end);
  this.printTime();

};

var clock = new Clock();
clock.run();