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
//= require sound.js
//= require seedrandom.js

$(document).ready(function() {

    // broker form
    
    if($('#new_transaction').length > 0) {        

        // automatically update base price of utopist transaction    
        if($('.utopist-transaction').length > 0) {
            $('#transaction_seller_id').change(function() {
                $('#transaction_price').val($('#transaction_seller_id option:selected').data('base_price'));
                $('.remaining').html($('#transaction_seller_id option:selected').data('stock_left'));
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

    //reload page when market session changes
    if ($('.auto-reload-market-session').length > 0) {
        var session_start = 0;
        var session_end = 0;
        setInterval(function() {    
            console.log("update market session ");
            $.getJSON( "/market_sessions/active_session" ,function( data ) {
                if (   (session_start != 0 && session_start != data.start)
                    || (session_end   != 0 && session_end   != data.end) ) {
                    location.reload();
                }
                session_start = data.start;
                session_end = data.end;
            });
        }, 8000);
    }
    
    // charts
    if($('#chart-usx').length > 0) {
        var elem = $('#chart-usx');
        new Chart ("chart-usx", "/stocks/usx_data", "USX", $(elem).data("min"), $(elem).data("max"));
    }

    if($('.chart').length > 0) {
        $(".chart").each(function() {
            console.log($(this).data("id"));
            new Chart ("chart-"+$(this).data("symbol"), "/stocks/chart_data/"+$(this).data("id"), $(this).data("title"), $(this).data("min"), $(this).data("max"));
        });
    }

    // 100% height
    windowHeight = $(window).height();
    $('.viewportheight').css('height', windowHeight);

    if ($('.screensaver').length > 0) {
        var s_saver;
        $( "body" ).append( '<div id="screensaver" style="height:100%; width:100%; position:fixed; top:0; left:0; background-color:rgba(0,0,0,0.5);"></div>' );
        $('#screensaver').hide();   
        $('body').on('mousemove', function (e)
            {
                console.log("move");
              if (e.type == 'mousemove')
              {
                clearTimeout(s_saver);
                s_saver = setTimeout('$(\'#screensaver\').fadeIn();', 10000);
                $('#screensaver').hide();          
              }
        });      
    }

});

$( window ).load(function() {
    // portfolio print out    
    if($('.portfolio').length > 0) {
        window.print(); 
        if($('.portfolio').length < 3) {
            if($('#utopist_seller').length > 0) {
                document.location.href = "/transactions/new_public_utopist";        
            } else {
                document.location.href = "/transactions/new_public";        
            }
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
                
                if(seconds_left == 0 || minutes_left == 0) {
                    var countdown_audio_string = "";
                    if(minutes_left > 0) {
                        countdown_audio_string += "Noch " + minutes_left + " Minuten bis zum Ende der Handelsphase.";
                    } else {
                        if(seconds_left == 30 || seconds_left = 10) {
                            countdown_audio_string += "Noch " + seconds_left + " Sekunden bis zum Ende der Handelsphase.";
                        }
                        if(seconds_left == 0) {
                            countdown_audio_string += "Die Handelsphase ist beendet.";
                        }
                    }
                    if(total_seconds_left >= 0 && hours_left == 0) {
                        read_with_queue(countdown_audio_string);
                    }
                }
                
                var countdown_string = "";
                if (hours_left > 0 ) countdown_string += hours_left + ":" + ("00" + minutes_left).slice(-2);
                else countdown_string += minutes_left 
                countdown_string += ":" + seconds_left;
                
        		if(total_seconds_left <= 0) {
        		   countdown_string = 'Handelsphase zu Ende.'
                   if(t.active) {
                       $.get(t.url, function(data) {
                           console.log(data);
                       });
                    }  
                   t.active = false;
        		} else {
        		   t.active = true;
                   countdown_string = "Noch " + countdown_string + " Minuten bis zum Ende der Handelsphase.";                      
        		}
        
                $(t.e).html(countdown_string);

        }, 1000);
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

function Chart(canvas_id, url, title, min, max) {
    this.updateInterval = 5000 + Math.random(5000);

	this.dps = [];   //dataPoints.
	this.last_tick = 0;
    this.last_price = 0;
    this.lastDate = new Date(0);
    this.lastUpdate = new Date();
    
    if (typeof min == "undefined" || min == "" || min < 0 ) this.min = null;
    else this.min = new Date(parseInt(min) * 1000);
    if (typeof max == "undefined" || max == "" || max < 0 ) this.max = null;
    else this.max = new Date(parseInt(max) * 1000);
    console.log("min: " + min + " -> " + this.min);
    console.log("max: " + max + " -> " + this.max);
    
    this.scale = [];
    var t = this;

    console.log($("#"+canvas_id).parent().width());

	this.chart = new CanvasJS.Chart(canvas_id,{
		backgroundColor: "transparent",
		width: $("#"+canvas_id).parent().width(),
		culture: "de",
		creditHref: "",
		creditText: "",	
        zoomEnabled:true,
		title :{
			text: title,
			fontFamily: "Arial Black",
			fontColor: "white",
			horizontalAlign: "left",
		},
		axisX: {						
			title: "",
            labelFontFamily: "ProximaNovaThin",
			labelFontColor: "white",
			valueFormatString: "HH:mm",
            gridThickness: 0,
            /*minimum: new Date(1389912787000),
            maximum: new Date(1389915987000),*/
            minimum: this.min,
            maximum: this.max,            
		},
		axisY: {						
			title: "",
            labelFontFamily: "ProximaNovaThin",
			labelFontColor: "white",
            gridThickness: 0,
		},
		data: [{
			type: "line",
            markerType: "none",
            lineThickness: 3,
            color: "#43FF07",
			dataPoints : this.dps,
		},/*
		{
            type: "line",
            markerType: "none",
            lineThickness: 10,
            color: "#ffffff",
            dataPoints : this.scale,
        }*/]
	});
	 
	this.chart.render();
	
	setInterval(function(){
		
		$.getJSON( url + "?tick="+ (t.last_tick+1) ,function( data ) {
            if (data.length > 0) {
              $.each( data, function( i,item ) {
                newDate = new Date(parseInt(item.seconds)*1000);
                if (t.last_price != 0) {
                    // insert random data points
                    lastDataPointDate = t.dps[t.dps.length-1]['x'];
                    randomData = randomDataPoints (lastDataPointDate, newDate, t.last_price, t.dps);
                    //console.log("added " + randomData + " data points, last price " + t.last_price);
                }
    		    t.dps.push({x: newDate, y: item.price});
    		    t.last_tick = parseInt(item.tick);
                t.last_price = parseInt(item.price);
                t.lastDate = newDate;
    		  });       
    		  t.chart.render();
            }
            else if (t.last_price > 0) {
                // insert random data points
                lastDataPointDate = t.dps[t.dps.length-1]['x'];
                randomData = randomDataPoints (lastDataPointDate, new Date(), t.last_price, t.dps);
                //console.log("added " + randomData + " data points, last price " + t.last_price + " (no new ticks, last " + lastDataPointDate + ") ");
                t.chart.render();
            }
            t.lastUpdate = new Date();
    	});
        
	}, this.updateInterval);
}

function randomDataPoints(minDate, maxDate, lastValue, dest) { // Date minDate, maxDate
    seconds_min = Math.round(minDate.getTime() / 1000);
    seconds_max = Math.round(maxDate.getTime() / 1000);
    var seconds_interval = 5;
    Math.seedrandom(seconds_min);
    seconds_min = seconds_min + seconds_interval;
    counter = 0;
    while (seconds_min < seconds_max) {
        seconds_min = seconds_min + seconds_interval;
        if (seconds_min >= seconds_max) continue;
        //console.log("secmin " + seconds_min + " secmax " + seconds_max);
        rnd = Math.random();
        randomValue = (rnd-0.5)/40*lastValue + lastValue;
        dest.push({x: new Date(seconds_min * 1000), y: randomValue});
        counter++;
    }
    return counter;
}
