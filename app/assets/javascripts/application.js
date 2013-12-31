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
//= require jquery.onepage-scroll.js

function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

function Scroller(content, step) {
	this.scrollPos = 0;
	this.scrollStep = step;
	this.scrollContent = $(content);
	this.scrollPlaceholder = this.scrollContent.clone();
	this.scrollContent.parent().append(this.scrollPlaceholder);
	this.scrollPlaceholder.css('left', this.scrollContent.width() + 'px');
	this.start = function() {
		var t = this;
		this.interval = setInterval(function() {
			//console.log('step: ' + t.scrollPos);
			if(t.scrollPos < -$(t.scrollContent).width()) {
				t.scrollPos += $(t.scrollContent).width();
			}
			t.scrollPos -= t.scrollStep;
			$(t.scrollContent).css('left', t.scrollPos + 'px');		
			$(t.scrollPlaceholder).css('left', t.scrollPos + $(t.scrollContent).width() + 'px');		
		}, 25);
	}
}

$(document).ready(function() {

  $("#new_utopia").on("ajax:success", function(e, data, status, xhr) {
    $("#new_utopia").append(xhr.responseText);
  });
  
  $("#new_utopia").bind("ajax:error", function(e, xhr, status, error) {
    $("#new_utopia").append("<p>ERROR</p>");
  });

	topScroller1 = new Scroller('#scroll-content-1', 3);
	topScroller1.start();

	topScroller2 = new Scroller('#scroll-content-2', 1);
	topScroller2.start();
	
	$(".main").onepage_scroll({
    beforeMove: function(index) {
      console.log(index);
			$('#claim-' + index).fadeOut();
			$('#icon-' + index).fadeOut();
			if(index == 4) {
				$('.ip-logo').fadeOut();
			} else if(index == 5) {
				$('.stier-logo').fadeOut();
			}			
    }, 
    afterMove: function(i) {
			index = $('section.active').data("index"); // bug in one_scroll - get index through css
			$('#claim-' + index).fadeIn();
			$('#icon-' + index).fadeIn();
			if(index == 4) {
				$('.ip-logo').fadeIn();
			} else if(index == 5) {
				$('.stier-logo').fadeIn();
			}
    },
  	responsiveFallback: 1000
  });
  
  if(getParameterByName('new')) {
  	setTimeout(scrollToForm, 500);
  }
  
  $(".formlink").click(function() {
		$('.claim').fadeOut();
		$('.icon').fadeOut();
		$(".main").moveTo(5);
	});
  
  $('input[type="text"], input[type="email"], textarea').focus(function() {
  	$(this).val('');
  	$(this).css('color', '#000');
  });
  
  $('#new_utopia').submit(function(e) {
  
  	if(!confirm('Sind Sie sicher, dass Sie diese Utopie wirklich wollen?')) {
  		e.preventDefault();
  	} else {
  		alert('Vielen Dank! Wir melden uns per E-Mail bei Ihnen.');
  	}
  });
  

  $('#utopia_image').change(function() {
	  $(".file_input").css('color', '#000');
  	$(".file_input").val($('#utopia_image').val());
  });
  
});