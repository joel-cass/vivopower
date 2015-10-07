using Toybox.Ant as Ant;
using Toybox.WatchUi as Ui;
using Toybox.System as System;
using Toybox.Time as Time;
using Toybox.Timer as Timer;
using Toybox.Math as Math;

class AntPowerSensor extends Ant.GenericChannel
{
	// settings
	static const NETWORK_TYPE = Ant.NETWORK_PLUS;
	static const CHANNEL_TYPE = Ant.CHANNEL_TYPE_RX_NOT_TX;
	static const CHANNEL_FREQUENCY = 57;
    static const CHANNEL_PERIOD = 8182;
    static const DEVICE_TYPE = 0x0B;

	// for finding devices
	static const SEARCH_TRANSMISSION_TYPE = 0;

	// pages
	static const PAGE_CALIBRATION = 0x01;
	static const PAGE_PARAMETERS = 0x02;
	static const PAGE_CALIBRATION_OUTPUT = 0x03;
	static const PAGE_POWER_ONLY = 0x10;
	static const PAGE_TORQUE_WHEEL = 0x11;
	static const PAGE_TORQUE_CRANK = 0x12;
	static const PAGE_TORQUE_EFFICIENCY = 0x13;
	static const PAGE_TORQUE_FREQUENCY = 0x20;

	// calibration
	static const CALIBRATION_TX = 0xAA;
	static const CALIBRATION_RX_ACK = 0xAC;
	static const CALIBRATION_RX_FAIL = 0xAF;
	
    var searching = false;
    
    hidden var _channel;
    hidden var _data;
    hidden var _device_number;
    hidden var _device;
    
    hidden var _pages = [];
    hidden var _listeners = [];
    hidden var _calibration_listener;
    
    function initialize(device_number, pages_to_watch)
    {
		LoggingHelper.log("Initialising");
		
		if (pages_to_watch != null) {
			_pages = pages_to_watch;
		}

		if (device_number == null) {
			device_number = 0; //Wildcard our search
		}
		_device_number = device_number;
		
		_data = new AntData();
		
		//LoggingHelper.log("n="+device_number+",t="+DEVICE_TYPE+",rf="+SEARCH_TRANSMISSION_TYPE+",p="+CHANNEL_PERIOD+",f="+CHANNEL_FREQUENCY+"");
				
		open();
    }

    function open()
    {
        LoggingHelper.log("Creating channel");

        // Get the channel
        _channel = new Ant.ChannelAssignment(
            CHANNEL_TYPE,
            NETWORK_TYPE);
            
        GenericChannel.initialize(method(:onMessage), _channel);

        LoggingHelper.log("Setting Configuration");

        // Set the configuration
        _device = new Ant.DeviceConfig( {
            :deviceNumber => _device_number,
            :deviceType => DEVICE_TYPE,
            :transmissionType => SEARCH_TRANSMISSION_TYPE,
            :messagePeriod => CHANNEL_PERIOD,
            :radioFrequency => CHANNEL_FREQUENCY,              //Ant+ Frequency
            :searchTimeoutLowPriority => 6,    //Timeout in 15s
            :searchTimeoutHighPriority => 1,    //Timeout in 2.5s
            :searchThreshold => 0} );           //Pair to all transmitting sensors
        GenericChannel.setDeviceConfig(_device);

        LoggingHelper.log("Opening channel");
        
        // Open the channel
        GenericChannel.open();

		LoggingHelper.log("Connection Open. Device id = " + _device.deviceNumber);

        searching = true;
        
		LoggingHelper.setStatus("Searching");
    }

    function close()
    {
		LoggingHelper.log("Connection Closed.");
		LoggingHelper.setStatus("Connection Closed");

        GenericChannel.close();
        GenericChannel.release();
    }
    
    function reopen() {
		LoggingHelper.log("Re-opening connection");
    	close();
    	open();
   	}

	function addListener(listener, page) {
		_listeners = ArrayHelper.append(_listeners, page);
		_listeners = ArrayHelper.append(_listeners, listener);
	}

//	function clearListener(listener) {
//		_listeners = ArrayHelper.remove(_listeners, listener);
//	}

	function clearListeners() {
		_listeners = [];
	}
	
	function notifyListeners(page) {
		for(var i = 0; i < _listeners.size(); i+=2) {
			System.println(i + ": " + _listeners[i] + " (page="+page+")");
			if (_listeners[i] == page) {
				_listeners[i+1].invoke(_data);
			}
		}
	}

	function getDeviceId() {
		return _device_number;
	}

	function getData() {
		return _data;
	}

    function onMessage(msg)
    {
        // Parse the payload
        var payload = msg.getPayload();

		//LoggingHelper.log("Received Message: " + msg.messageId);
		//LoggingHelper.log(payload.toString());

        if( Ant.MSG_ID_BROADCAST_DATA == msg.messageId )
        {
            // Were we searching?
            if(searching)
            {
                searching = false;
                // Update our device configuration primarily to see the device number of the sensor we paired to
                _device = GenericChannel.getDeviceConfig();
                _device_number = _device.deviceNumber;
				
				LoggingHelper.log("Device Found. Device id = " + _device.deviceNumber);
    
            }
			LoggingHelper.setStatus("Connected: #" + _device.deviceNumber);
            process(msg.getPayload());
        }
        else if( Ant.MSG_ID_CHANNEL_RESPONSE_EVENT == msg.messageId )
        {
            if( Ant.MSG_ID_RF_EVENT == payload[0] )
            {
                if (payload[1] == Ant.MSG_CODE_EVENT_CHANNEL_CLOSED)
                {
					LoggingHelper.log("Channel Closed");
					LoggingHelper.setStatus("Channel Closed");
                    // Channel closed, re-open
					reopen();
                }
                else if (payload[1] == Ant.MSG_CODE_EVENT_RX_FAIL_GO_TO_SEARCH)
                {
					LoggingHelper.log("RX Fail Go To Search");
					LoggingHelper.setStatus("Searching");
					//searching = true;
					// Channel dropped, re-open
					reopen();
                }
                else if (payload[1] == Ant.MSG_CODE_EVENT_RX_SEARCH_TIMEOUT)
                {
					LoggingHelper.log("RX Timeout");
					LoggingHelper.setStatus("Searching");
					//searching = true;
					// Search timed out, re-open
					reopen();
                }
                else if (payload[1] == Ant.MSG_CODE_EVENT_QUE_OVERFLOW)
                {
					LoggingHelper.log("Queue Overflow");
                }
                else if (payload[1] == Ant.MSG_CODE_EVENT_RX_FAIL)
                {
					LoggingHelper.log("RX Fail");
                } 
                else 
                {
					LoggingHelper.log("Error: " + payload[1]);
                }
            }
            else
            {
                //It is a channel response.
				//LoggingHelper.log("Channel Response");
            }
        }
    }

	hidden var _previous_payloads = {};
	
	function process (payload) {
		var pageNumber = payload[0];
		
		//System.println("RECEIVED PAGE: " + pageNumber + " = " + payload);
		
		if (pageNumber == PAGE_CALIBRATION) {
			// 1: Calibration ID
			if (payload[1] == CALIBRATION_RX_ACK) {
				_data.calibration_success = true;
				_data.calibration_auto = payload[2] == 0x00 ? "Off" : (payload[2] == 0x01 ? "On" : "Unsupported") ;
				_data.calibration_value = combineBytes(payload[6], payload[7]);
				LoggingHelper.setStatus("CALIBRATION SUCCESS");
			} else if (payload[1] == CALIBRATION_RX_FAIL) {
				_data.calibration_success = false;
				_data.calibration_auto = "";
				_data.calibration_value = 0;
				LoggingHelper.setStatus("CALIBRATION FAIL");
			} else {
				LoggingHelper.setStatus("CALIBRATION UNKNOWN ("+payload[1]+")");
			}
			if (_calibration_listener != null) {
				_calibration_listener.invoke(_data);
			}
		} else if (_pages.size() == 0 || ArrayHelper.contains(_pages, pageNumber)) {
			var last_payload = _previous_payloads.hasKey(pageNumber) ? _previous_payloads[pageNumber] : payload;
			var eventDelta = MathHelper.mod(255 + payload[1] - last_payload[1], 255);
			
			if (pageNumber == PAGE_POWER_ONLY) {
				// 2: Balance. First 6 bits are %, 7th bit indicates R if true, L if false 
				if (payload[2] == 0xFF) {
					_data.left_balance = 0;
					_data.right_balance = 0;
				} else {
					var blnRight = getBits(payload[2], 0, 1);
					var value = getBits(payload[2], 1, 7);
					if (blnRight == 1) {
						_data.left_balance = 100-value;
						_data.right_balance = value;
					} else {
						_data.left_balance = value;
						_data.right_balance = 100-value;
					}
				}
				// 3: Cadence
				_data.cadence = payload[3];
				// 4: Accumulated Power LSB
				// 5: Accumulated power MSB
				var diffPower = MathHelper.mod(65535 + (combineBytes(payload[4], payload[5]) - combineBytes(last_payload[4], last_payload[5])), 65535);
				if (eventDelta > 0) {
					_data.power = diffPower / eventDelta;
				}
				// 6: Instantaneous power LSB
				//power = payload[6];
				// 7: Instantaneous power MSB
				//power = payload[7];
				_data.instant_power = combineBytes(payload[6], payload[7]);
				_data.torque = calculateTorque(_data.power, _data.cadence);
				_data.instant_torque = calculateTorque(_data.instant_power, _data.cadence);
				notifyListeners(PAGE_POWER_ONLY);
				//LoggingHelper.log("POWER ONLY");
				LoggingHelper.log("POWER ONLY (b="+_data.left_balance+"/"+_data.right_balance+",c="+_data.cadence+",p="+_data.power+")");
			} else if (pageNumber == PAGE_TORQUE_WHEEL) {
				// 2: Wheel Ticks
				// 3: Cadence
				_data.cadence = payload[3];
				// 4: Wheel Period LSB
				// 5: Wheel Period MSB
				var periodDelta = MathHelper.mod(65535 + (combineBytes(payload[4], payload[5]) - combineBytes(last_payload[4], last_payload[5])), 65535);
				// 6: Accumulated Torque LSB
				// 7: Accumulated Torque MSB
				var diffTorque = MathHelper.mod(65535 + (combineBytes(payload[6], payload[7]) - combineBytes(last_payload[6], last_payload[7])), 65535);
				if (eventDelta > 0) {
					_data.torque = diffTorque / (32 * eventDelta);
				}
				if (periodDelta > 0) {
					_data.power =  128 * Math.PI * diffTorque / periodDelta;
				}
				notifyListeners(PAGE_TORQUE_WHEEL);
				//LoggingHelper.log("WHEEL TORQUE");
				LoggingHelper.log("WHEEL TORQUE (t="+_data.torque+",p="+_data.power+")");
			} else if (pageNumber == PAGE_TORQUE_CRANK) {
				// 2: Crank Ticks
				// 3: Instantaneous Cadence
				_data.cadence = payload[3];
				// 4: Period LSB
				var periodDelta = MathHelper.mod(65535 + combineBytes(payload[4], payload[5]) - combineBytes(last_payload[4], last_payload[5]), 65535);
				// 5: Period MSB
				// 6: Accumulated Torque LSB
				// 7: Accumulated Torque MSB
				var diffTorque = MathHelper.mod(65535 + (combineBytes(payload[6], payload[7]) - combineBytes(last_payload[6], last_payload[7])), 65535);
				if (eventDelta > 0) {
					_data.torque = diffTorque / (32 * eventDelta);
				}
				if (periodDelta > 0) {
					_data.power = 128 * Math.PI * diffTorque / periodDelta;
				}
				notifyListeners(PAGE_TORQUE_CRANK);
				//LoggingHelper.log("CRANK TORQUE");
				LoggingHelper.log("CRANK TORQUE (c="+_data.cadence+",t="+_data.torque+",p="+_data.power+")");
			} else if (pageNumber == PAGE_TORQUE_EFFICIENCY) {
				// 2: Left Leg Effectiveness
				_data.left_efficiency = payload[2];
				// 3: Right Leg Effectiveness
				_data.right_efficiency = payload[3];
				// 4: Left Leg Smoothness
				_data.left_smoothness = payload[4];
				// 5: Right Leg Smoothness
				_data.right_smoothness = payload[5];
				// 6: Unused
				// 7: Unused
				notifyListeners(PAGE_TORQUE_EFFICIENCY);
				//LoggingHelper.log("TORQUE EFFICIENCY");
				LoggingHelper.log("TORQUE EFFICIENCY (le="+_data.left_efficiency+",re="+_data.right_efficiency+",ls="+_data.left_smoothness+",rs="+_data.right_smoothness+")");
			} else if (pageNumber == PAGE_TORQUE_FREQUENCY) {
				// 2: Slope MSB
				// 3: Slope LSB
				var slope = combineBytes(payload[2], payload[3]) - combineBytes(last_payload[2], last_payload[3]);
				// 4: Time Stamp MSB
				// 5: Time Stamp LSB
				var time = combineBytes(payload[4], payload[5]) - combineBytes(last_payload[4], last_payload[5]);
				// 6: Torque Ticks Stamp MSB
				// 7: Torque Ticks Stamp LSB
				var ticks = combineBytes(payload[6], payload[7]) - combineBytes(last_payload[6], last_payload[7]);
				if (time > 0 && ticks > 0 && slope > 0) {
					var frequency = 1/time/ticks - _data.calibration_value;
					_data.cadence = 60 / ((time / eventDelta) * 0.0005);
					_data.torque = frequency/slope/10.0;
					_data.power = _data.torque * _data.cadence * Math.PI / 30;
					notifyListeners(PAGE_TORQUE_FREQUENCY);
				}
				LoggingHelper.log("TORQUE FREQUENCY");
				//LoggingHelper.log("TORQUE FREQUENCY");
			} else if (pageNumber == PAGE_PARAMETERS) {
				LoggingHelper.log("PARAMETERS");
				_data.param1 = payload[2];
				_data.param2 = payload[3];
				_data.param3 = payload[4];
				_data.param4 = payload[5];
				_data.param5 = payload[6];
				_data.param6 = payload[7];
				notifyListeners(PAGE_PARAMETERS);
				//LoggingHelper.log("PARAMETERS");
			} 
			_previous_payloads[pageNumber] = payload;
		}
	}

    function calibrate(listener)
    {
        _calibration_listener = listener;

        if( !searching )
        {
            //Create and populat the data payload
            var payload = new [8];
            payload[0] = PAGE_CALIBRATION;  //Calibration data page
            payload[1] = CALIBRATION_TX;  //Calibration command
            payload[2] = 0xFF; //Reserved
            payload[3] = 0xFF; //Reserved
            payload[4] = 0xFF; //Reserved
            payload[5] = 0xFF; //Reserved
            payload[6] = 0xFF; //Reserved
            payload[7] = 0xFF; //Reserved
          
          	_data.calibration_success = null;
          
          	//Form and send the message
            var message = new Ant.Message();
            message.setPayload(payload);
            GenericChannel.sendAcknowledge(message);

			LoggingHelper.log("CALIBRATION MESSAGE SENT");
        }

    }

	function getBits(value, start, length) {
		return (value >> (8-(start+length))) & ((1 << length)-1);
	}

	function combineBytes(lsb, msb) {
		return msb << 8 | lsb;
	}

	function calculateTorque(power, cadence) {
		if (power > 0 && cadence > 0) {
			return power / (2 * Math.PI * cadence / 60);
		} else {
			return 0;
		}
	}

    class AntData
    {

		// standard fields
		var cadence = 0;
		var power = 0;		
		var torque = 0;		

		// power only fields
		var instant_power = 0;		
		var instant_torque = 0;		
		var left_balance = 0;
		var right_balance = 0;

		// efficiency fields
		var left_efficiency = 0.0;
		var right_efficiency = 0.0;
		var left_smoothness = 0.0;
		var right_smoothness = 0.0;

		// calibration fields
		var calibration_success = null;
		var calibration_auto = "";
		var calibration_value = 0;

		// parameter fields
		var param1 = 0;
		var param2 = 0;
		var param3 = 0;
		var param4 = 0;
		var param5 = 0;
		var param6 = 0;
    }


}