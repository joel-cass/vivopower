// ******* LICENSE ******* 
//  
//  Copyright 2015 Joel Cass 
//  
//  Licensed under the Apache License, Version 2.0 (the "License"); 
//  you may not use this file except in compliance with the License. 
//  You may obtain a copy of the License at 
//  
//      http://www.apache.org/licenses/LICENSE-2.0 
//      
//  Unless required by applicable law or agreed to in writing, software 
//  distributed under the License is distributed on an "AS IS" BASIS, 
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
//  See the License for the specific language governing permissions and 
//  limitations under the License. 

using Toybox.Timer;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class CalibrationDelegate extends Ui.BehaviorDelegate {

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