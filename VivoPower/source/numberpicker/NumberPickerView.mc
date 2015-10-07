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

using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
//using Toybox.Math as Math;

class NumberPickerView extends Ui.View {
	
	hidden static var _value = 0;
	hidden static var _min = 0;
	hidden static var _max = 65535;
	hidden static var _digits = new [0];
	hidden static var _callback;
	
	static var width = 0;
	static var height = 0;
	static var numDigits = 0;
	static var selectedDigit = 0;
	static var font = Gfx.FONT_NUMBER_HOT;
	static var allocWidth;
	static var digitDims;
	static var digitWidth;
	static var digitHeight;
		
	static const ARROW_HEIGHT = 10;
	static const ARROW_WIDTH = 20;

	function initialize(value, min, max, callback) {
		Sys.println("value: " + value);
		if (value != null) {
			_value = value.toNumber();
		}
		if (min != null) {
			_min = min.toNumber();
		}
		if (max != null) {
			_max = max.toNumber();
		}
		numDigits = _max.toString().length();
		selectedDigit = numDigits-1;
		_digits = new [numDigits];
		_callback = callback;
	}

	static function increment(amount, digit) {
		var v = _value + (amount * MathHelper.pow(10, numDigits-digit-1));
		if (v >= _min && v <= _max) {
			_value = v;
		}
		Ui.requestUpdate();
	}

	static function moveDigit(dir) {
		var d = selectedDigit+dir;
		d = MathHelper.max(0, d);
		d = MathHelper.min(numDigits-1, d);
		selectedDigit = d;
		Ui.requestUpdate();
	}

	static function finish() {
		Sys.println("finish()");
		_callback.invoke(_value);
		Ui.popView(Ui.SLIDE_IMMEDIATE);
	}

    //! Load your resources here
    function onLayout(dc) {
    	width = dc.getWidth();
    	height = dc.getHeight();

		allocWidth = (width-ARROW_HEIGHT*2)/numDigits;
		digitDims = dc.getTextDimensions("0", font);
		digitWidth = digitDims[0];
		digitHeight = digitDims[1];
		
	}

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {

    }

    //! Update the view
    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);

		dc.clear();
		
		var x; var y;  var w;  var h;

		for (var i = 0; i < numDigits; i++) {
			// calculate digit
			_digits[i] = (_value % MathHelper.pow(10,(numDigits-i))) / MathHelper.pow(10,(numDigits-i-1));
			// reset screen
			dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
			// draw digit
			x = ARROW_HEIGHT + allocWidth*i + allocWidth/2;
			y = (height - digitHeight) / 2;
			if (selectedDigit == i) {
				dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
			}
			dc.drawText(x, y, font, _digits[i].toString(), Gfx.TEXT_JUSTIFY_CENTER);
		}
		
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);

		// draw up arrow
		x = width/2;
		y = 0;
		dc.fillPolygon([[x, y], [x+(ARROW_WIDTH/2), y+ARROW_HEIGHT], [x-(ARROW_WIDTH/2), y+ARROW_HEIGHT], [x,y]]);
		
		// draw down arrow
		x = width/2;
		y = height;
		dc.fillPolygon([[x, y], [x+(ARROW_WIDTH/2), y-ARROW_HEIGHT], [x-(ARROW_WIDTH/2), y-ARROW_HEIGHT], [x,y]]);

		// draw left arrow
		x = 0;
		y = height/2;
		dc.fillPolygon([[x, y], [x+ARROW_HEIGHT, y+(ARROW_WIDTH/2)], [x+ARROW_HEIGHT, y-(ARROW_WIDTH/2)], [x,y]]);
		
		// draw right arrow
		x = width;
		y = height/2;
		dc.fillPolygon([[x, y], [x-ARROW_HEIGHT, y+(ARROW_WIDTH/2)], [x-ARROW_HEIGHT, y-(ARROW_WIDTH/2)], [x,y]]);

		dc.drawText(dc.getWidth()-3, dc.getHeight()/6 - dc.getFontHeight(Gfx.FONT_SMALL)/2, Gfx.FONT_SMALL, "OK", Gfx.TEXT_JUSTIFY_RIGHT);		
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {

    }

}
