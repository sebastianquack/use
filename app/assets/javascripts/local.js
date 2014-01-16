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

$(document).ready(function() {

    // broker form
    
    if($('#new_transaction').length > 0) {        

        // automatically update base price of utopist transaction    
        if($('.utopist-transaction').length > 0) {
            $('#transaction_seller_id').change(function() {
                $('#transaction_price').val($('#transaction_seller_id option:selected').data('base_price'));
            });
        }
        
        update_total();
        $('#transaction_amount').keyup(update_total);
        $('#transaction_price').keyup(update_total);
        $('#transaction_amount').click(update_total);
        $('#transaction_price').click(update_total);

        $('#new_transaction select')[0].focus();

        // move to next field after selecting
        $("#new_transaction select").change(function() {
          console.log('next');
          var fields = $("#new_transaction select, #new_transaction input");
          fields.eq( fields.index(this) + 1 ).focus();
        });        
        // prevent form submit on enter except when submit button is in focus
        $('#new_transaction').bind("keypress", function(e) {
            var code = e.keyCode || e.which; 
            if (code  == 13) {        
                console.log($(':focus').attr('name'));       
                if(!($(':focus').attr('name') == 'commit')) {
                    e.preventDefault();
                    return false;
                }
            }
            if(code == 32) {
                var fields = $("#new_transaction select, #new_transaction input");
                fields.eq( fields.index($(':focus')) + 1 ).focus();                
                e.preventDefault();
                return false;
            }    
        });
        // prevent submit button firing on space bar
        $('#new_transaction input[type=submit]').bind("keypress keydown", function(e) {
            var code = e.keyCode || e.which; 
             if(code == 32) {
                e.preventDefault();
                $("#new_transaction select")[0].focus();
                return false;                 
             }             
        });
    }

    // portfolio print out
    
    if($('.portfolio').length > 0) {
        window.print(); 
        if($('#utopist_seller').length > 0) {
            document.location.href = "/transactions/new_public_utopist";        
        } else {
            document.location.href = "/transactions/new_public";        
        }
    }
    
    var countdown = new Countdown(".countdown");
    countdown.start();
    
    // rolling
    var rollers = [];
    $(".roll").each( function() {
    	//elems = $(this).children();
    	timer = parseInt($(this).data("timer"));
    	var roller = new Roller($(this), timer);
        roller.start();
        rollers.push(roller);
    });
    
    // auto-update user info and stock info    
    var updaters = [];
    $('.auto-update').each(function(index) {
        updaters.push(new Updater($(this), $(this).data('url'), 10000));
        updaters[index].start();
    });

    
    // charts
    if($('#chart-usx').length > 0) {
        new Chart ("chart-usx", "/stocks/usx_data", "USX");
    }

    if($('.chart').length > 0) {
        $(".chart").each(function() {
            console.log($(this).data("id"));
            new Chart ("chart-"+$(this).data("symbol"), "/stocks/chart_data/"+$(this).data("id"), $(this).data("title"));
        });
    }

    // 100% height
    windowHeight = $(window).height();
    $('.viewportheight').css('height', windowHeight);
        
});

$( window ).load(function() {
    // portfolio print out
    
    if($('.portfolio').length > 0) {     
        window.print(); 
        if($('#utopist_seller').length > 0) {
            document.location.href = "/transactions/new_public_utopist";        
        } else {
            document.location.href = "/transactions/new_public";        
        }
    }
});

function Roller(container, timer) {
	this.container = container;
	this.timer = timer;
	this.url = container.data('url');
    this.update_after = container.data('update-after');
    this.update_counter = 0;
    this.i = 0;
    this.update_html = null;

    this.start = function() {
        var self = this;
        self.interval = setInterval(function() {          

            // load update when last child is reached
            if(self.url && self.i == self.container.children().length) {
              if(self.update_counter >= self.update_counter) {
                  // load update
                  $.get(self.url, function( data ) {
                     self.update_html = data;
                  });
              } else {
                  self.update_counter++;
                }
            }

    		if (self.i >= self.container.children().length) {              
    		  self.i = 0;  
            }  

            // display update when it is ready
            if(self.update_html) {
                self.container.html(self.update_html);
                self.update_html = null;
            }
            self.container.children().hide();
            $(self.container.children().get(self.i)).show();
            console.log("rolled to " + self.i + " " + self.timer);
            self.i++;

        }, self.timer);
    }
}

function Countdown(e) {

    this.e = e
    this.countdown_target = $(this.e).data('countdown-to');
    this.url = $(this.e).data('url');
    this.active = false;
    
    this.start = function() {
        var t = this;
    	this.interval = setInterval(function() {    

                var now = new Date();
                var total_seconds_left = t.countdown_target - Math.floor(now.getTime() / 1000);
		
                var days_left = Math.floor(total_seconds_left / 86400);
        		var hours_left = Math.floor(total_seconds_left / 3600) - days_left * 24;
        		var minutes_left = Math.floor(total_seconds_left / 60) - (days_left * 1440 + hours_left * 60);
        		var seconds_left = total_seconds_left - (days_left * 86400 + hours_left * 3600 + minutes_left * 60);
                if(seconds_left < 10) {
                    seconds_left = '0' + seconds_left;
                }
                var countdown_string = minutes_left + ":" + seconds_left;

        		if(total_seconds_left <= 0) {
        		   countdown_string = '0:00';
                   if(t.active) {
                       $.get(t.url, function(data) {
                           console.log(data);
                       });
                    }  
                   t.active = false;
        		} else {
        		   t.active = true;
        		}
        
                $(t.e).html(countdown_string);
        });
    }
}

// broker form
function update_total() {
    $('.total').html($('#transaction_amount').val() * $('#transaction_price').val());
}


function Updater(element, url, updateInterval) {
    this.url = url;
    this.element = element;
	this.start = function() {
		var t = this;
    	this.interval = setInterval(function() {    
            console.log("update: " + t.url);
            $(t.element).load(t.url);                            
    	}, updateInterval);
    }
}

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
			fontFamily: "Arial Black",
			fontColor: "white",
			horizontalAlign: "left",
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
			type: "stepLine",
			dataPoints : this.dps
		},
        /*
		{
			type: "spline",
			dataPoints: this.dps
		}*/]
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

