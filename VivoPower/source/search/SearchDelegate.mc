using Toybox.Timer;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class SearchDelegate extends Ui.BehaviorDelegate {

	var _timer = new Timer.Timer();
	var _direction = 1;
	
	var _view;
	
	function initialize(view) {
		_view = view;
	}

	function isExitButton(coords) {
		return coords[1] > _view.height*2/3;
	}
	
	function onBack(evt) {
		Ui.popView(Ui.SLIDE_IMMEDIATE);
	}
	
	function onTap(evt) {
		var coords = evt.getCoordinates();
		if (isExitButton(coords)) {
			Ui.popView(Ui.SLIDE_IMMEDIATE);
		}
	}
	
}