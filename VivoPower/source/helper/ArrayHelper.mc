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