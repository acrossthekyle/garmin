using Toybox.Activity;
using Toybox.Math;
using Toybox.Sensor;
using Keg.Setting;

module Keg
{
	module Compass
	{
		var instance = null;

		(:glance)
		class CompassInfo
		{
			public var heading = 0;
			public var degrees = 0;
			public var radians = 0;

			public function asString() {
				if (self.degrees == null) {
			    return "--";
			  }

			  var asNATO = Setting.getValue("Compass_DegreesFormat", 0);

			  if (asNATO) {
			    self.degrees = self.degrees * 17.777778;
			  }

			  var prettified = "";

			  var degrees = self.degrees.format("%d").toCharArray();

			  var digits = ["0", "0", "0"];

			  if (asNATO) {
			    digits.add("0");
			  }

			  var x = digits.size() - 1;

			  for (var i = degrees.size() - 1; i >= 0; --i) {
			    digits[x] = degrees[i];

			    --x;
			  }

			  for (var i = 0; i < digits.size(); ++i) {
			    prettified += digits[i];
			  }

			  return prettified;
			}

			public function nesw() {
				if (self.degrees == null) {
			    return "--";
			  }

			  return [
		      "N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"
		    ][(Math.round((self.degrees/22.5) + 0.5).toNumber() % 16)];
			}
		}

		(:glance)
		function getInfo() {
			var sensor = Compass.activityInfo != null ? Compass.activityInfo : Sensor.getInfo();

		  var heading = null;

		  if (sensor has :heading) {
		    if (sensor.heading != null) {
		      heading = sensor.heading;
		    }
		  } else if (sensor has :currentHeading) {
		    if (sensor.currentHeading != null) {
		      heading = sensor.currentHeading;
		    }
		  }

		  if (heading == null) {
		  	var activity = Activity.getActivityInfo();

		    if (activity.currentHeading != null) {
		      heading = activity.currentHeading;
		    }
		  }

		  var radians = (heading == null ? 0 : heading) + Setting.getValue("Compass_Declination", 0).toFloat() * Math.PI/180;

	    if (radians < 0) {
	      radians = 2 * Math.PI + radians;
	    }

	    if (Compass.instance == null) {
	    	Compass.instance = new Compass.CompassInfo();
	    }

	    Compass.instance.heading = heading;
	    Compass.instance.degrees = Math.toDegrees(radians).toNumber();
	    Compass.instance.radians = radians;

	    return Compass.instance;
		}
	}
}
