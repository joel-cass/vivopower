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

using Toybox.Timer as Timer;
using Toybox.System as Sys;
using Toybox.Ant as Ant;

class Test {
	
	var _timer = new Timer.Timer();
	var _sensor;
	var _count = 0;
	
	function initialize(sensor) {
		_sensor = sensor;
		_timer.start(method(:onTimer), 500, true);	
		Sys.println("Test init");
	}
	
	function onTimer() {
		var payload = new [8];
		if (_count % 6 == 0) {
			payload[0] = AntPowerSensor.PAGE_POWER_ONLY;
		} else if (_count % 6 == 1) {
			payload[0] = AntPowerSensor.PAGE_TORQUE_CRANK;
		} else if (_count % 6 == 2) {
			payload[0] = AntPowerSensor.PAGE_TORQUE_WHEEL;
		} else if (_count % 6 == 3) {
			payload[0] = AntPowerSensor.PAGE_PARAMETERS;
		} else if (_count % 6 == 4) {
			payload[0] = AntPowerSensor.PAGE_TORQUE_FREQUENCY;
		} else if (_count % 6 == 5) {
			payload[0] = AntPowerSensor.PAGE_TORQUE_EFFICIENCY;
		}
		payload[1] = _count % 255;
		payload[2] = r();
		payload[3] = r();
		payload[4] = r();
		payload[5] = r();
		payload[6] = r();
		payload[7] = r();
		_count++;
		_sensor.process(payload);
	}
	
	function r () {
		return Math.rand() / 255 / 255 / 255;
	}

}