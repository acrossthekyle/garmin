using Toybox.Activity;
using Toybox.Sensor;
using Toybox.System;

module Keg
{
	module Altitude
	{
		var instance = null;

		(:glance)
		class AltitudeOxygenInfo
		{
			public var elevation = 0;
			public var value = 100;

			private var zones = [
		    209, 201, 194, 186, 179, 173, 166, 160, 154, 148, 143, 137, 132, 127,
		    123, 118, 114, 110, 105, 101, 97, 94, 90, 87, 84, 81, 78, 75, 72, 69
		  ]b;

			public function asString() {
				return self.value.format(self.value > 99.9 ? "%d" : "%.1f") + "%";
			}

			public function calculate() {
				var feet = Math.ceil(self.elevation.toFloat() * 3.28084);

			  self.value = 100;

			  if (feet > 0) {
				  for (var i = 1; i <= 30; ++i) {
				    if (feet <= i * 1000) {
				      var zoneStart = zones[i]/10.0;
				      var zoneEnd = zones[i + 1]/10.0;
				      var zoneDenominator = ((zoneStart - zoneEnd) * 10);
				      var zoneAsThousands = ((i * 1000) - feet);
				      var zoneBaseAsThousands = i == 1 ? 0 : ((i - 1) * 1000);

				      zoneDenominator = zoneAsThousands/zoneDenominator;
				      zoneDenominator = zoneDenominator <= 0 ? 1 : zoneDenominator;

				      var x = (((zoneBaseAsThousands - feet).abs()/zoneDenominator)/100)/10;

				      self.value = ((zoneStart - x)/20.9) * 100;

				      break;
				    }
				  }
				}
			}
		}

		(:glance)
		class AltitudeInfo
		{
			public var value = 0;
			public var unit = "";
			public var oxygen = null;
			public var risk = 0;
			public var zone = 0;

			public function asString() {
				return Altitude.format(self.value);
			}
		}

		(:glance)
		function getInfo() {
			var activity = Activity.getActivityInfo();
			var sensor = Altitude.activityInfo != null ? Altitude.activityInfo : Sensor.getInfo();

			var elevation = null;

			if (sensor != null) {
				if (sensor.altitude != null) {
			    elevation = sensor.altitude;
			  }
			}

		  if (elevation == null) {
		    if (activity.altitude != null) {
		      elevation = activity.altitude;
		    }
		  }

		  if (Altitude.instance == null) {
	    	Altitude.instance = new Altitude.AltitudeInfo();
	    }

	    Altitude.instance.value = elevation;

	    if (Altitude.instance.oxygen == null) {
	    	Altitude.instance.oxygen = new Altitude.AltitudeOxygenInfo();
	    }

	    Altitude.instance.oxygen.elevation = elevation;
	    Altitude.instance.oxygen.calculate();

	    Altitude.instance.risk = 0;
	    Altitude.instance.unit = System.getDeviceSettings().elevationUnits == 0 ? "m" : "ft";
	    Altitude.instance.zone = 0;

	    if (elevation > 5000) {
	      Altitude.instance.zone = 4;
	    } else if (elevation <= 5000 && elevation > 3000) {
	      Altitude.instance.zone = 3;
	    } else if (elevation <= 3000 && elevation > 1500) {
	      Altitude.instance.zone = 2;
	    } else if (elevation > 0) {
	      Altitude.instance.zone = 1;
	    }

	    if (elevation > 4000) {
		    Altitude.instance.risk = 3;
		  } else if (elevation <= 4000 && elevation > 3500) {
		    Altitude.instance.risk = 2;
		  } else if (elevation > 3000) {
		    Altitude.instance.risk = 1;
		  }

  		return Altitude.instance;
		}
	}
}
