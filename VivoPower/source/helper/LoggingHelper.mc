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

using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

class LoggingHelper {

	static var _log = new [20];
	static var _status = "Not Initialised";
	
	static function setStatus (message) {
    	_status = message;
    	Ui.requestUpdate();
    }
    
	static function getStatus () {
    	return _status;
    }
    
	static function log(message) {
		Sys.println(message);
		write(message);
	} 
	
	static function write(message) {
		for (var i = _log.size()-1; i > 0; i--) {
			_log[i] = _log[i-1];
		}
		_log[0] = message;
		Ui.requestUpdate();
	}
	
	static function read() {
		return _log;
	}

	static function getLatest() {
		return _log[0];
	}

}