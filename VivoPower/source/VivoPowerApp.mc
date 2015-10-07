using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class VivoPowerApp extends App.AppBase {

	static var sensor;
	static const NUMBER_FORMAT = "%1.1f";

	static function setSensorId(id) {
		if (sensor != null) {
			sensor.close();
			sensor = null;
		}
    	sensor = new AntPowerSensor(id);
	}

    //! onStart() is called on application start up
    function onStart() {
		var id = App.getApp().getProperty("power_id");
		if (id == null) {
			id = 0;
		}
    	sensor = new AntPowerSensor(id);
    	//var t = new Test(sensor);
    }

    //! onStop() is called when your application is exiting
    function onStop() {
		if (sensor != null) {
			sensor.close();
			sensor = null;
		}
    }

    //! Return the initial view of your application here
    function getInitialView() {
        return [ new PowerOnlyView(), new VivoPowerDelegate(0) ];
    }

}

class VivoPowerDelegate extends Ui.BehaviorDelegate {

	var _screen = 0;
	
	function initialize(screen) {
		_screen = screen;
	}
	
    function onMenu() {
        Ui.pushView(new Rez.Menus.MainMenu(), new VivoPowerMenuDelegate(), Ui.SLIDE_UP);
        return true;
    }
    
    function onNextPage() {
    	displayPage(_screen+1, Ui.SLIDE_LEFT);
    }
    
    function onPreviousPage() {
    	displayPage(_screen-1, Ui.SLIDE_RIGHT);
    }
    
    function displayPage(page_number, transition) {
    	page_number = MathHelper.mod(page_number + 6, 6);
    	Sys.println("Page Number: " + page_number);
    	if (page_number == 0) {
    		Ui.switchToView(new PowerOnlyView(), new VivoPowerDelegate(page_number), transition);
    	} else if (page_number == 1) {
    		Ui.switchToView(new WheelTorqueView(), new VivoPowerDelegate(page_number), transition);
    	} else if (page_number == 2) {
    		Ui.switchToView(new CrankTorqueView(), new VivoPowerDelegate(page_number), transition);
    	} else if (page_number == 3) {
    		Ui.switchToView(new TorqueEfficiencyView(), new VivoPowerDelegate(page_number), transition);
    	} else if (page_number == 4) {
    		Ui.switchToView(new TorqueFrequencyView(), new VivoPowerDelegate(page_number), transition);
    	} else if (page_number == 5) {
    		Ui.switchToView(new ParametersView(), new VivoPowerDelegate(page_number), transition);
    	}
    }

}