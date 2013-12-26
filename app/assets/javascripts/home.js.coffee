# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Dashboard Events

function answerRequest(id, accept) {
	if(accept) {
		$("#"+id).css("background-color", "rgba(0,255,0,0.2)");

	}
}