using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Timer;

class ParametersView extends Ui.View {

	var _title = "Parameters";
	var _label1 = "Param 1";
	var _value1 = "---";
	var _label2 = "Param 2";
	var _value2 = "---";
	var _label3 = "Param 3";
	var _value3 = "---";
	var _label4 = "Param 4";
	var _value4 = "---";
	var _label5 = "Param 5";
	var _value5 = "---";
	var _label6 = "Param 6";
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
		_value1 = data.param1.format(VivoPowerApp.NUMBER_FORMAT);
		_value2 = data.param2.format(VivoPowerApp.NUMBER_FORMAT);
		_value3 = data.param3.format(VivoPowerApp.NUMBER_FORMAT);
		_value4 = data.param4.format(VivoPowerApp.NUMBER_FORMAT);
		_value5 = data.param5.format(VivoPowerApp.NUMBER_FORMAT);
		_value6 = data.param6.format(VivoPowerApp.NUMBER_FORMAT);
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
