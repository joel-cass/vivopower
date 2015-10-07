using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Timer;

class CrankTorqueView extends Ui.View {

	var _title = "Crank Torque";
	var _label1 = "Power";
	var _value1 = "---";
	var _label2 = "Torque";
	var _value2 = "---";
	var _label3 = "Cadence";
	var _value3 = "---";

    //! Load your resources here
    function onLayout(dc) {

    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    	VivoPowerApp.sensor.addListener(method(:updateValues), AntPowerSensor.PAGE_TORQUE_CRANK);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    	VivoPowerApp.sensor.clearListeners(AntPowerSensor.PAGE_TORQUE_CRANK);
    }

	function updateValues (data) {
		_value1 = data.power.format(VivoPowerApp.NUMBER_FORMAT);
		_value2 = data.torque.format(VivoPowerApp.NUMBER_FORMAT);
		_value3 = data.cadence.format(VivoPowerApp.NUMBER_FORMAT);
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
		dc.drawText(w / 2, y, Gfx.FONT_SMALL, _label1, Gfx.TEXT_JUSTIFY_CENTER);
		y += dc.getFontHeight(Gfx.FONT_SMALL);
		// line 1 values
		dc.drawText(w / 2, y, Gfx.FONT_NUMBER_MEDIUM, _value1, Gfx.TEXT_JUSTIFY_CENTER);
		y += dc.getFontHeight(Gfx.FONT_NUMBER_MEDIUM);
		// line 2 headings
		dc.drawText(w * 1 / 4, y, Gfx.FONT_SMALL, _label2, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(w * 3 / 4, y, Gfx.FONT_SMALL, _label3, Gfx.TEXT_JUSTIFY_CENTER);
		y += dc.getFontHeight(Gfx.FONT_SMALL);
		// line 2 values
		dc.drawText(w * 1 / 4, y, Gfx.FONT_NUMBER_MILD, _value2, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(w * 3 / 4, y, Gfx.FONT_NUMBER_MILD, _value3, Gfx.TEXT_JUSTIFY_CENTER);
		y += dc.getFontHeight(Gfx.FONT_NUMBER_MILD);
		// log
		//dc.drawText(dc.getWidth() / 2, dc.getHeight()-dc.getFontHeight(Gfx.FONT_SMALL), Gfx.FONT_SMALL, LoggingHelper.getLatest(), Gfx.TEXT_JUSTIFY_CENTER);
		// title
		dc.drawText(w / 2, dc.getHeight()-dc.getFontHeight(Gfx.FONT_SMALL), Gfx.FONT_SMALL, _title, Gfx.TEXT_JUSTIFY_CENTER);
    }

}