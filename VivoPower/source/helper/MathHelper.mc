using Toybox.Math as Math;

class MathHelper {

	static function mod(dividend, divisor) {
		if (dividend == null || divisor == null) {
			return null;
		}
		if (dividend == 0 || divisor == 0) {
			return 0;
		} else {
	        var n = (dividend / divisor).toNumber();
	        return dividend - (n * divisor);
        }
	}
	
	static function abs(number) {
		if (number == null) {
			return null;
		}
		if (number < 0) {
			return number * -1.0;
		} else {
			return number;
		}
	}
	
	static function compare (oldnumber, newnumber) {
		if (oldnumber == null || newnumber == null) {
			return null;
		}
		if (newnumber > oldnumber) {
			return 1;
		} else if (newnumber < oldnumber) {
			return -1;
		} else {
			return 0;
		}
	}
	
	static function min (value1, value2) {
		if (value2 == null || value1 < value2) {
			return value1;
		} else {
			return value2;
		}
	}

	static function max (value1, value2) {
		if (value2 == null || value1 > value2) {
			return value1;
		} else {
			return value2;
		}
	}
	
	static function round (value) {
		if (value == null) {
			return null;
		}
		var temp = value.toNumber();
		if (value > temp+0.5) {
			return temp + 1;
		} else if (value < temp+0.5) {
			return temp;
		} else if (temp % 2 == 1) {
			// round to nearest even number
			return temp + 1;
		} else {
			return temp;
		}
	}
	
	static function pow(value, factor) {
		var r = 1;
		for (var i = 0; i < factor; i++) {
			r = r * value;
		}
		return r;
	}
	
}
