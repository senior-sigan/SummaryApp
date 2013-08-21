BarChart.BASE_COLOR = color('red');
function BarChart(height, col_width, data){
  	this.kolor = BarChart.BASE_COLOR.clone();
  	var n = 0;
  	this.height = height-30;
  	this.max = Number.MIN_VALUE;
  	this.width = col_width;
  	this.length = 0;
	for (var i in data){
		this.length += col_width;
		if (data[i]>this.max){
      		this.max=data[i]; 
		}
	}
	var offset = 0;
	var pre_offset = this.length-stage.width+this.width;
	if ( pre_offset > 0){
		offset = pre_offset;
	}
	for (var j in data){
		this.slice(j, data[j], ++n, offset);
	}
}
BarChart.prototype = {
	slice: function(name, value, i, offset) {
		var kolor = this.kolor = this.kolor.clone().hue(this.kolor.hue()+0.1);
		var height = value*this.height/this.max;
    	var width = this.width*0.9;
    	var x = i*this.width-offset;
    	var y = this.height*1.1;
    	if (value === 0){
    		height = this.height;
    		kolor = color('#efeff0');
    	}

    	var s = new Rect(x,y,width,-height);
		s.fill(kolor);
		s.addTo(stage).on('mouseover', over).on('mouseout', out);
		var lbl = this.label(name, value, kolor,x);
		lbl.remove();

		function over(){
			lbl.addTo(stage);
			s.animate('.2s', {
        		height: -height*1.2 ,
        		fillColor: kolor.lighter(0.1)
      		}, {
        		easing: 'sineOut'
      		});
		}

		function out(){
			lbl.remove();
			s.animate('.2s', {
        		height: -height,
        		fillColor: kolor
      		});
		}
	},
	label: function(name, value, kolor,pos_x){
		var offset = 30;
		if (pos_x > stage.width/2.0){
			offset = -100;
		}
		var g = new Group().attr({
	        x: offset,
	        y: this.height,
	        cursor: 'pointer'
	    });

		var t = new Text(name + ' (' + value + ')').addTo(g);
		t.attr({
		  x: pos_x-this.width,
		  y: 17,
		  textFillColor: 'black',
		  fontFamily: 'Arial',
		  fontSize: '14'
		});
		g.addTo(stage);
		g.text = t;
		return g;
	}
};