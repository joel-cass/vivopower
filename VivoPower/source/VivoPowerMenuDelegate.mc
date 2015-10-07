using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application as App;

class VivoPowerMenuDelegate extends Ui.MenuInputDelegate {

    function onMenuItem(item) {
        if (item == :search) {
        	var view = new SearchView();
        	var delegate = new SearchDelegate(view);
            Ui.pushView(view, delegate, Ui.SLIDE_IMMEDIATE);
        } else if (item == :calibrate) {
        	var view = new CalibrationView(VivoPowerApp.sensor);
        	var delegate = new CalibrationDelegate(view);
            Ui.pushView(view, delegate, Ui.SLIDE_IMMEDIATE);
        } else if (item == :id) {
        	var id = App.getApp().getProperty("power_id");
        	if (id == null) {
        		id = VivoPowerApp.sensor.getDeviceId();
        	}
            var numberpicker = new NumberPickerView( id, 0, 65535, method(:selectPowerId) );
            Ui.pushView( numberpicker, new NumberPickerDelegate(), Ui.SLIDE_IMMEDIATE );
        } else if (item == :reset) {
	    	// save setting
	    	App.getApp().setProperty("power_id", 0);
	    	// update sensor
			VivoPowerApp.setSensorId(0);
        }
    }

    function selectPowerId(value) {
    	// save setting
    	App.getApp().setProperty("power_id", value);
    	// update sensor
		VivoPowerApp.setSensorId(value);
        // close the power meter menu
    	Ui.popView(Ui.SLIDE_IMMEDIATE);
    	// close the main menu
    	//Ui.popView(Ui.SLIDE_IMMEDIATE);
    }
}