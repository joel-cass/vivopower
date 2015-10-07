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