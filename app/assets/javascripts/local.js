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
//= require turbolinks
//= require canvasjs.js
//= require scroller.js


function update_total() {
    $('.total').html($('#transaction_amount').val() * $('#transaction_price').val());
}

$(document).ready(function() {
        
    update_total();
    $('#transaction_amount').change(update_total);
    $('#transaction_price').change(update_total);

    if($('.portfolio').length > 0) {
        window.print();        
    }


    // Charts

    new Chart ("chart-usx", "/stocks/usx_data", "USX");

    $(".chart").each(function() {
    	console.log($(this).data("id"));
    	new Chart ("chart-"+$(this).data("symbol"), "/stocks/chart_data/"+$(this).data("id"), $(this).data("title"));
    });

});

    function Chart(canvas_id, url, title) {
	    this.updateInterval = 5000 + Math.random(5000);

		this.dps = [];   //dataPoints.
		this.last_tick = 0;

		this.chart = new CanvasJS.Chart(canvas_id,{
			backgroundColor: "transparent",
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