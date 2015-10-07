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

class NumberPickerDelegate extends Ui.BehaviorDelegate {

	function initialize() {

	}
	
	function onBack(evt) {
		Ui.popView(Ui.SLIDE_IMMEDIATE);
	}
	
	function up_action (index) {
		if (index == null) {
			index = NumberPickerView.selectedDigit;
		}
		NumberPickerView.increment(1, index);
	}
	
	function down_action (index) {
		if (index == null) {
			index = NumberPickerView.selectedDigit;
		}
		NumberPickerView.increment(-1, index);
	}
	
	function left_action () {
		NumberPickerView.moveDigit(-1);
	}
	
	function right_action () {
		NumberPickerView.moveDigit(1);
	}
	
	function finish() {
		NumberPickerView.finish();
	}
	
	// screen events
	
	function onTap(evt) {
		var coords = evt.getCoordinates();
		
		var width = NumberPickerView.width;
		var height = NumberPickerView.height;
		var numDigits = NumberPickerView.numDigits;		
		var allocWidth = NumberPickerView.allocWidth;
		
		// screen is in 9 sections - 1=topleft 9=bottomright
		var section = 0;
		for (var col = 0; col < 3; col++) {
			if (coords[0] >= width*col/3 && coords[0] < width*(col+1)/3) {
				for (var row = 0; row < 3; row++) {
					if (coords[1] >= height*row/3 && coords[1] < height*(row+1)/3) {
						section = row*3 + col + 1;
					}
				}
			}
		}

		// detect up arrow
		if (section == 2) {
			up_action();
			return true;
		}
		
		// detect down arrow
		if (section == 8) {
			down_action();
			return true;
		}

		// detect left arrow
		if (section == 4) {
			left_action();
			return true;
		}

		// detect right arrow
		if (section == 6) {
			right_action();
			return true;
		}
		
		// detect OK button
		if (section == 3) {
			finish();
			return true;
		}

		return false;
	}
	
	// key events
	
	function onKey(evt) {
		if (evt.getKey() == Ui.KEY_UP) {
			up_action();
			return true;
		} else if (evt.getKey() == Ui.KEY_DOWN) {
			down_action();
			return true;
		} else if (evt.getKey() == Ui.KEY_LEFT) {
			left_action();
			return true;
		} else if (evt.getKey() == Ui.KEY_RIGHT) {
			right_action();
			return true;
		} else if (evt.getKey() == Ui.KEY_ENTER) {
			finish();
			return true;
		}
		return false;
	}
	
}