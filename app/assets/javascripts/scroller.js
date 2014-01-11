
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

var scrollers = {}

$(document).ready(function() {

	$(".scroll-content").each(function () {
		step = $(this).data("step");
		id   = $(this).attr("id");
		scrollers[id] = new Scroller(this, step);
		scrollers[id].start();
	});
  
});