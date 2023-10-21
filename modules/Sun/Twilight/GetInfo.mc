using Toybox.Math;
using Toybox.Time as T;
using Toybox.Time.Gregorian;
using Keg.Time;

module Keg
{
	module Sun
	{
		module Twilight
		{
			var instance = null;

			(:glance)
			class TwilightLevelInfo
			{
				public var hour = null;
				public var minute = null;
				public var degree = null;

				public function asString() {
					return Time.format(hour, minute);
				}
			}

			(:glance)
			class TwilightInfo
			{
				public var dawn = null;
				public var dusk = null;
			}

			(:glance)
			function getInfo(position, moment, level) {
				if (Twilight.instance == null) {
					Twilight.instance = new Twilight.TwilightInfo();
				}

				if (Twilight.instance.dawn == null) {
					Twilight.instance.dawn = new Twilight.TwilightLevelInfo();
				}

				if (Twilight.instance.dusk == null) {
					Twilight.instance.dusk = new Twilight.TwilightLevelInfo();
				}

				if (position == null) {
					return Twilight.instance;
				}

				var twilight = [
          -0.314159,  /* astronomical dawn/dusk start/end */
          -0.209440,  /* nautical dawn/dusk start/end */
          -0.104720   /* civil dawn/dusk start/end (real dawn/dusk) */
        ][level];

				var N = Math.round(
		      (moment.value().toDouble() / 86400 - 0.5 + 2440588 - 2451545) - 0.0009 + position[1] / 6.283186
		    ).toNumber().toFloat();

		    var DS = 0.0009 - position[1] / 6.283186 + N - 1.1574e-5 * 68;
		    var M = 6.240059967 + 0.0172019715 * DS;
		    var SINM = Math.sin(M);
		    var L = M + ((1.9148 * SINM + 0.02 * Math.sin(2 * M) + 0.0003 * Math.sin(3 * M)) * 0.01745329444) + 1.796593063 + Math.PI;
		    var SIN2L = Math.sin(2 * L);
		    var DEC = Math.asin(0.397783703 * Math.sin(L));
		    var JNOON = 2451545 + DS + 0.0053 * SINM - 0.0069 * SIN2L;

		    var gregorian = null;
		    var time = null;
		    var x = null;

		    for (var i = 0; i < 2; ++i) {
		      x = (Math.sin(twilight) - Math.sin(position[0]) * Math.sin(DEC)) / (Math.cos(position[0]) * Math.cos(DEC));

		      if (x >= -1.0 && x <= 1.0) {
		        time = 2451545 + (0.0009 + (Math.acos(x) - position[1]) / 6.283186 + N - 1.1574e-5 * 68) + 0.0053 * SINM - 0.0069 * SIN2L;

		        if (i > 0) {
		          /* dusk */
		          time = Gregorian.info(new T.Moment((time + 0.5 - 2440588) * 86400), T.FORMAT_SHORT);
		        } else {
		          /* dawn */
		          time = Gregorian.info(new T.Moment(((JNOON - (time - JNOON)) + 0.5 - 2440588) * 86400), T.FORMAT_SHORT);
		        }

		        if (i == 0) {
		        	Twilight.instance.dawn.hour = time.hour;
		        	Twilight.instance.dawn.minute = time.min;
		        	Twilight.instance.dawn.degree = -90 - ((time.hour * 60) + time.min)/4;
		        } else {
		          Twilight.instance.dusk.hour = time.hour;
		        	Twilight.instance.dusk.minute = time.min;
		        	Twilight.instance.dusk.degree = -90 - ((time.hour * 60) + time.min)/4;
		        }
		      }
		    }

				return Twilight.instance;
			}
		}
	}
}
