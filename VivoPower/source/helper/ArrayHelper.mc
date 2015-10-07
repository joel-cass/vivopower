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

class ArrayHelper {

	static function append(array, value) {
		var returnvalue = new [array.size()+1];
		for (var i = 0; i < array.size(); i++) {
			returnvalue[i] = array[i];
		}
		returnvalue[array.size()] = value;
		
		return returnvalue;
	}
	
	static function remove(array, value) {
		var length = 0;
		for (var i = 0; i < array.size(); i++) {
			if (!(array[i] == value || (array[i] has :equals && array[i].equals(value)))) {
				length++;
			}
		}
		var returnvalue = new [length];
		var n = 0;
		for (var i = 0; i < array.size(); i++) {
			if (!(array[i] == value || (array[i] has :equals && array[i].equals(value)))) {
				returnvalue[n] = value;
				n++;
			}
		}
		
		return returnvalue;
	}

	static function contains (array, value) {
		for (var i = 0; i < array.size(); i++) {
			if ((array[i] == value || (array[i] has :equals && array[i].equals(value)))) {
				return true;
			}
		}
		return false;
	}
	
}