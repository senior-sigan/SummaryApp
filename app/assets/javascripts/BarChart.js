BarChart.BASE_COLOR = color('red');
function BarChart(data){
  this.kolor = BarChart.BASE_COLOR.clone();
  var n = 0;
  this.height = 100;
	this.max = Number.MIN_VALUE;
  this.width = 20;
	for (var i in data){
		if (data[i]>this.max){
      this.max=data[i]; 
		}
	}
	for (var j in data){
		this.slice(j, data[j], ++n);
	}
}
BarChart.prototype = {
	slice: function(name, value, i) {
		var kolor = this.kolor = this.kolor.clone().hue(this.kolor.hue()+0.1);
		var height = value*this.height/this.max;
    var width = this.width*0.9;
    var x = i*this.width;
    var y = this.height*1.1;
    var s = new Rect(x,y,width,-height);
		s.fill(kolor);
		s.addTo(stage).on('mouseover', over).on('mouseout', out);
		function over(){
			s.animate('.2s', {
        height: -height*1.2 ,
        fillColor: kolor.lighter(0.1)
      }, {
        easing: 'sineOut'
      });
		}
		function out(){
			s.animate('.2s', {
        height: -height,
        fillColor: kolor
      });
		}
	}
};
var data={"a":1,"b":3,"c":2,"d":7};
new BarChart(data);