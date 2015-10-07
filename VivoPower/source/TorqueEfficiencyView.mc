using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Timer;

class TorqueEfficiencyView extends Ui.View {

	var _title = "Torque Efficiency";
	var _label1 = "Smoothness.L";
	var _value1 = "---";
	var _label2 = "Smoothness.R";
	var _value2 = "---";
	var _label3 = "Efficiency.L";
	var _value3 = "---";
	var _label4 = "Efficiency.R";
	var _value4 = "---";

    //! Load your resources here
    function onLayout(dc) {

    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    	VivoPowerApp.sensor.addListener(method(:updateValues), AntPowerSensor.PAGE_TORQUE_EFFICIENCY);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    	VivoPowerApp.sensor.clearListeners(AntPowerSensor.PAGE_TORQUE_EFFICIENCY);
    }

	function updateValues (data) {
		_value1 = data.left_smoothness.format(VivoPowerApp.NUMBER_FORMAT);
		_value2 = data.right_smoothness.format(VivoPowerApp.NUMBER_FORMAT);
		_value3 = data.left_efficiency.format(VivoPowerApp.NUMBER_FORMAT);
		_value4 = data.right_efficiency.format(VivoPowerApp.NUMBER_FORMAT);
	}

    //! Update the view
    function onUpdate(dc) {
		var y = 0;
		var w = dc.getWidth();
		
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
		dc.clear();
		
		// status
		dc.drawText(dc.getWidth() / 2, 0, Gfx.FONT_SMALL, LoggingHelper.getStatus(), Gfx.TEXT_JUSTIFY_CENTER);
		y += dc.getFontHeight(Gfx.FONT_SMALL);
		// line 1 headings
		dc.drawText(w * 1 / 4, y, Gfx.FONT_SMALL, _label1, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(w * 3 / 4, y, Gfx.FONT_SMALL, _label2, Gfx.TEXT_JUSTIFY_CENTER);
		y += dc.getFontHeight(Gfx.FONT_SMALL);
		// line 1 values
		dc.drawText(w * 1 / 4, y, Gfx.FONT_NUMBER_MILD, _value1, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(w * 3 / 4, y, Gfx.FONT_NUMBER_MILD, _value2, Gfx.TEXT_JUSTIFY_CENTER);
		y += dc.getFontHeight(Gfx.FONT_NUMBER_MILD);
		// line 2 headings
		dc.drawText(w * 1 / 4, y, Gfx.FONT_SMALL, _label3, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(w * 3 / 4, y, Gfx.FONT_SMALL, _label4, Gfx.TEXT_JUSTIFY_CENTER);
		y += dc.getFontHeight(Gfx.FONT_SMALL);
		// line 2 values
		dc.drawText(w * 1 / 4, y, Gfx.FONT_NUMBER_MILD, _value3, Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(w * 3 / 4, y, Gfx.FONT_NUMBER_MILD, _value4, Gfx.TEXT_JUSTIFY_CENTER);
		y += dc.getFontHeight(Gfx.FONT_NUMBER_MILD);
		// log
		//dc.drawText(dc.getWidth() / 2, dc.getHeight()-dc.getFontHeight(Gfx.FONT_SMALL), Gfx.FONT_SMALL, LoggingHelper.getLatest(), Gfx.TEXT_JUSTIFY_CENTER);
		// title
		dc.drawText(dc.getWidth() / 2, dc.getHeight()-dc.getFontHeight(Gfx.FONT_SMALL), Gfx.FONT_SMALL, _title, Gfx.TEXT_JUSTIFY_CENTER);
    }

}
