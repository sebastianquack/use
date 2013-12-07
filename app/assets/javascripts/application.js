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
//= require_tree .

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

function heightPercentFix(object, reference, relpos) {

		objectTop = $(object).offset().top - $(window).scrollTop();
    target = $(reference).offset().top + ($(reference).height() * relpos); 
    distance = Math.abs(target - ($(window).scrollTop() + objectTop));
		nearness = 0;
		envelope = 200;
		if(distance < envelope) {
			nearness =  (envelope - distance) / envelope;
		}
    //console.log('scrollTop: ' + $(window).scrollTop() + ' referenceTop: ' + $(reference).offset().top + ' objectTop: ' + objectTop + ' distance: ' + distance + 'nearness: ' + nearness);

		return(nearness);
}

function heightPercentFlex(object, relpos) {

    distance = Math.abs($(object).offset().top - $(window).scrollTop() - $(window).height() * relpos);
		nearness = 0;
		envelope = 300;
		if(distance < envelope) {
			nearness =  (envelope - distance) / envelope;
		}
    console.log('scrollTop: ' + $(window).scrollTop() + ' distance: ' + distance + 'nearness: ' + nearness);

		return(nearness);
}



function updateOpacity() {
    $('#claim-1').css('opacity', heightPercentFix('#claim-1', '#spacer-1', 0.0));
    $('#icon-1').css('opacity', heightPercentFix('#icon-1', '#spacer-1', 0.0));
    $('#claim-2').css('opacity', heightPercentFix('#claim-2', '#page-2', 0.8));
    $('#icon-2').css('opacity', heightPercentFix('#icon-2', '#page-2', 0.8));
    $('#claim-3').css('opacity', heightPercentFix('#claim-3', '#page-3', 0.8));
    $('#icon-3').css('opacity', heightPercentFix('#icon-3', '#page-3', 0.8));
		$('.ip-logo').css('opacity', heightPercentFlex('.ip-logo', 0.6));
		$('.stier-logo').css('opacity', heightPercentFlex('.stier-logo', 0.3));
		$('.stier-logo').css('opacity', heightPercentFlex('.stier-logo', 0.3));
}

function scrollToForm() {
	  $('html, body').animate({
  	  scrollTop: $("#page-5").offset().top - 100
		 }, 2000);
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
	
	updateOpacity();
	$(document).scroll(function(e){
		updateOpacity();		
  });
  
  if(getParameterByName('new')) {
  	setTimeout(scrollToForm, 500);
  }
  
  $(".formlink").click(function() {
		scrollToForm();
	});
  
  $('input, textarea').focus(function() {
  	$(this).val('');
  	$(this).css('color', '#000');
  });
  
  $('#new_utopia button.submit').click(function() {
  	if(confirm('Sind Sie sicher, dass Sie diese Utopie wirklich wollen?')) {
	  	alert('Vielen Dank! Wir melden uns per E-Mail bei Ihnen.');
	  	$('#new_utopia')[0].submit();  	
  	}

  });
  
  $('#utopia_image').change(function() {
	  $(".file_input").css('color', '#000');
  	$(".file_input").val($('#utopia_image').val());
  });
  
});