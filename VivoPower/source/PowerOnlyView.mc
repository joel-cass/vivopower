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
using Toybox.Graphics as Gfx;
using Toybox.Timer;
using Toybox.System as Sys;

class PowerOnlyView extends Ui.View {

	var _title = "Power Only";
	var _label1 = "Power";
	var _value1 = "---";
	var _label2 = "Cadence";
	var _value2 = "---";
	var _label3 = "Torque";
	var _value3 = "---";
	var _label4 = "Balance.L";
	var _value4 = "---";
	var _label5 = "Balance.R";
	var _value5 = "---";
	var _label6 = "Inst.Power";
	var _value6 = "---";

    //! Load your resources here
    function onLayout(dc) {

    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    	VivoPowerApp.sensor.addListener(method(:updateValues), AntPowerSensor.PAGE_POWER_ONLY);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    	VivoPowerApp.sensor.clearListeners(AntPowerSensor.PAGE_POWER_ONLY);
    }

	function updateValues (data) {
		_value1 = data.power.format(VivoPowerApp.NUMBER_FORMAT);
		_value2 = data.cadence.format(VivoPowerApp.NUMBER_FORMAT);
		_value3 = data.torque.format(VivoPowerApp.NUMBER_FORMAT);
		_value4 = data.left_balance.format(VivoPowerApp.NUMBER_FORMAT);
		_value5 = data.right_balance.format(VivoPowerApp.NUMBER_FORMAT);
		_value6 = data.instant_power.format(VivoPowerApp.NUMBER_FORMAT);
		Ui.requestUpdate();
	}

    //! Update the view
    function onUpdate(dc) {
		var y = 0;
		var w = dc.getWidth();
		
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
		dc.clear();
		
		// status
		dc.drawText(w / 2, 0, Gfx.FONT_SMALL, LoggingHelper.getStatus(), Gfx.TEXT_JUSTIFY_CENTER);
		y += dc.getFontHeight(Gfx.FONT_SMALL);
		// line 1 headings
		dc.drawText(w * 1 / 6, y, Gfx.FONT_SMALL, _label1, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(w * 3 / 6, y, Gfx.FONT_SMALL, _label2, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(w * 5 / 6, y, Gfx.FONT_SMALL, _label3, Gfx.TEXT_JUSTIFY_CENTER);
		y += dc.getFontHeight(Gfx.FONT_SMALL);
		// line 1 values
		dc.drawText(w * 1 / 6, y, Gfx.FONT_NUMBER_MILD, _value1, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(w * 3 / 6, y, Gfx.FONT_NUMBER_MILD, _value2, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(w * 5 / 6, y, Gfx.FONT_NUMBER_MILD, _value3, Gfx.TEXT_JUSTIFY_CENTER);
		y += dc.getFontHeight(Gfx.FONT_NUMBER_MILD);
		// line 2 headings
		dc.drawText(w * 1 / 6, y, Gfx.FONT_SMALL, _label4, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(w * 3 / 6, y, Gfx.FONT_SMALL, _label5, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(w * 5 / 6, y, Gfx.FONT_SMALL, _label6, Gfx.TEXT_JUSTIFY_CENTER);
		y += dc.getFontHeight(Gfx.FONT_SMALL);
		// line 2 values
		dc.drawText(w * 1 / 6, y, Gfx.FONT_NUMBER_MILD, _value4, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(w * 3 / 6, y, Gfx.FONT_NUMBER_MILD, _value5, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(w * 5 / 6, y, Gfx.FONT_NUMBER_MILD, _value6, Gfx.TEXT_JUSTIFY_CENTER);
		y += dc.getFontHeight(Gfx.FONT_NUMBER_MILD);
		// log
		//dc.drawText(dc.getWidth() / 2, dc.getHeight()-dc.getFontHeight(Gfx.FONT_SMALL), Gfx.FONT_SMALL, LoggingHelper.getLatest(), Gfx.TEXT_JUSTIFY_CENTER);
		// title
		dc.drawText(w / 2, dc.getHeight()-dc.getFontHeight(Gfx.FONT_SMALL), Gfx.FONT_SMALL, _title, Gfx.TEXT_JUSTIFY_CENTER);
    }

}
