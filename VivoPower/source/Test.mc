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