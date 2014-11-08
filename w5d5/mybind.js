Function.prototype.myBind = function(context){
  fn = this;
  return function() {
    fn.apply(context);
  }
}