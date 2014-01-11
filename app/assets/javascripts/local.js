// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require canvasjs.js
//= require scroller.js


function update_total() {
    console.log('update');
    $('.total').html($('#transaction_amount').val() * $('#transaction_price').val());
    
}

$(document).ready(function() {
        
    update_total();
    $('#transaction_amount').keyup(update_total);
    $('#transaction_price').keyup(update_total);
    $('#transaction_amount').click(update_total);
    $('#transaction_price').click(update_total);

    if($('#new_transaction').length > 0) {
        $('#new_transaction select')[0].focus();

        $('#new_transaction').bind("keyup keypress", function(e) {
            var code = e.keyCode || e.which; 
            if (code  == 13) {               
                e.preventDefault();
                return false;
            }
        });
    }


    if($('.portfolio').length > 0) {
        window.print(); 
        if($('#utopist_seller').length > 0) {
            document.location.href = "/transactions/new_public_utopist";        
        } else {
            document.location.href = "/transactions/new_public";        
        }
    }


    // Charts

    $(".roll").each( function() {
    	elems = $(this).children();
    	timer = parseInt($(this).data("timer"));
    	new Roller(elems, timer);
    });
    

    if($('#chart-usx').length > 0) {
        new Chart ("chart-usx", "/stocks/usx_data", "USX");
    }

    if($('.chart').length > 0) {
        $(".chart").each(function() {
            console.log($(this).data("id"));
            new Chart ("chart-"+$(this).data("symbol"), "/stocks/chart_data/"+$(this).data("id"), $(this).data("title"));
        });
    }

});

function Chart(canvas_id, url, title) {
    this.updateInterval = 5000 + Math.random(5000);

	this.dps = [];   //dataPoints.
	this.last_tick = 0;

console.log($("#"+canvas_id).parent().width());

	this.chart = new CanvasJS.Chart(canvas_id,{
		backgroundColor: "transparent",
		width: $("#"+canvas_id).parent().width(),
		culture: "de",
		creditHref: "",
		creditText: "",	
		title :{
			text: title,
			labelFontFamily: "Arial Black",
			labelFontColor: "white",
		},
		axisX: {						
			title: "",
			labelFontColor: "white",
			valueFormatString: "HH:mm",
		},
		axisY: {						
			title: "",
			labelFontColor: "white",
		},
		data: [{
			type: "spline",
			dataPoints : this.dps
		}]
	});
	 
	this.chart.render();
	var t = this;
	setInterval(function(){
		
		$.getJSON( url + "?tick="+ t.last_tick ,function( data ) {

		  $.each( data, function( i,item ) {
		    t.dps.push({x: new Date(item.seconds), y: item.price});
		    t.last_tick = item.tick;
		  });
		  t.chart.render();
		});
	}, this.updateInterval);
}

function Roller(elems,timer) {
	this.elems = elems;
	this.timer = timer;
	this.i = 0;
	self = this;

	this.roll = function() {
		console.log("roll " + self.i + " " + self.timer);
		if (self.i >= self.elems.length) self.i = 0;
		self.elems.hide();
		$(self.elems.get(self.i)).show();
		self.i++;
	}

	this.roll();

	this.interval = setInterval(this.roll,this.timer);
}
