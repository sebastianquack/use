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
//= require scroller.js

function setupSelectorEvents() {
	$('.utopia-selector').click(function(e) {
		direction = 'next';
		if($(e.target).attr('id') == 'utopia-selector-left') {
			direction = 'previous';
		}
		
		$.get( "stocks/" + direction + "/" + $(e.target).attr('rel'), function(data) {
		  $('#page-2 div.page-content').html(data);
		  setupSelectorEvents()
		});
		
	});
}

function loadStock(id) {
	$.get( "stocks/show_gallery/" + id, function(data) {
	  $('#page-2 div.page-content').html(data);
	  setupSelectorEvents()
	});
	
}

$(document).ready(function() {
	
	$(".main").onepage_scroll({
  		responsiveFallback: 1000
	});
  
  	setupSelectorEvents();
  
	$(".utopialink").click(function(e) {
		$(".main").moveTo(2);
		loadStock($(e.target).attr('rel'));
	});
  
});