using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;

module Keg
{
	module Moon
	{
		var instance = null;

		class MoonInfo
		{
			public var phase = 0;
		}

		function getInfo(moment) {
			if (Moon.instance == null) {
				Moon.instance = new Moon.MoonInfo();
			}

			var date = Gregorian.info(moment, Time.FORMAT_SHORT);

	    var phase = 0;

	    var n0 = 0;
	    var f0 = 0.0;
	    var AG = f0;

	    var Y1 = date.year;
	    var M1 = date.month;
	    var D1 = date.day;

	    var YY1 = n0;
	    var MM1 = n0;
	    var K11 = n0;
	    var K21 = n0;
	    var K31 = n0;
	    var JD1 = n0;
	    var IP1 = f0;
	    var DP1 = f0;

	    YY1 = Y1 - ((12 - M1) / 10).toNumber();
	    MM1 = M1 + 9;

	    if (MM1 >= 12) {
	      MM1 = MM1 - 12;
	    }

	    K11 = (365.25 * (YY1 + 4712)).toNumber();
	    K21 = (30.6 * MM1 + 0.5).toNumber();
	    K31 = (((YY1 / 100) + 49).toNumber() * 0.75).toNumber() - 38;

	    JD1 = K11 + K21 + D1 + 59; // for dates in Julian calendar

	    if (JD1 > 2299160) {
	      JD1 = JD1 - K31; // for Gregorian calendar
	    }

	    // calculate moon's age in days
	    IP1 = (JD1 - 2451550.1) / 29.530588853;
	    IP1 = IP1 - IP1.toNumber();

	    if (IP1 < 0) {
	      IP1 = IP1 + 1;
	    }

	    Moon.instance.phase = (IP1 * 29.53);

	    return Moon.instance;
		}
	}
}
