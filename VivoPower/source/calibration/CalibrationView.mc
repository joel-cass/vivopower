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

class CalibrationView extends Ui.View {
	
	var _value = null;
	
	var width;
	var height;
	
	function initialize(sensor) {
		sensor.calibrate(method(:onCalibrate));
	}

	function onCalibrate (data) {
		_value = data.calibration_value;
		Ui.requestUpdate();
	}

    //! Load your resources here
    function onLayout(dc) {
    	width = dc.getWidth();
    	height = dc.getHeight();
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
		
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);

		if (_value != null) {		
			dc.drawText(dc.getWidth()/2, (dc.getHeight()-dc.getFontHeight(Gfx.FONT_LARGE))/2, Gfx.FONT_LARGE, _value.format("%d"), Gfx.TEXT_JUSTIFY_CENTER);		
			dc.drawText(dc.getWidth()/2, (dc.getHeight()-dc.getFontHeight(Gfx.FONT_SMALL)), Gfx.FONT_SMALL, "OK", Gfx.TEXT_JUSTIFY_CENTER);		
		} else {
			dc.drawText(dc.getWidth()/2, (dc.getHeight()-dc.getFontHeight(Gfx.FONT_LARGE))/2, Gfx.FONT_LARGE, "-----", Gfx.TEXT_JUSTIFY_CENTER);		
			dc.drawText(dc.getWidth()/2, (dc.getHeight()-dc.getFontHeight(Gfx.FONT_SMALL)), Gfx.FONT_SMALL, "Cancel", Gfx.TEXT_JUSTIFY_CENTER);		
		}
		
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {

    }

}
