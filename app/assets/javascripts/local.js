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
    new Chart ("chart-aaa", "/stocks/chart_data/1", "AAA");

});

    function Chart(canvas_id, url, title) {
	    this.updateInterval = 2000;

		this.dps = [];   //dataPoints.
		this.last_tick = 0;

		this.chart = new CanvasJS.Chart(canvas_id,{
			title :{
				text: title
			},
			axisX: {						
				title: "Axis X Title"
			},
			axisY: {						
				title: "Units"
			},
			data: [{
				type: "line",
				dataPoints : this.dps
			}]
		});
		 
		//this.chart.render();

		//setInterval(function(){
			var t = this;
			$.getJSON( url, function( data ) {

			  $.each( data, function( i,item ) {
			    t.dps.push({x: new Date(item.seconds), y: item.value});
			    //t.last_tick = item.tick;
			  });
			  t.chart.render();
			});
		//}, updateInterval);
	}