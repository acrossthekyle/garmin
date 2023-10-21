using Toybox.SensorHistory;

module Keg
{
	module Altitude
	{
		module Elevation
		{
			var instance = null;

			class ElevationVariationInfo
			{
				public var value = 0;

				public function initialize(value) {
					self.value = value;
				}

				public function asString() {
					return Altitude.format(self.value);
				}
			}

			class ElevationExtremityInfo
			{
				public var value = 0;

				public function initialize(value) {
					self.value = value;
				}

				public function asString() {
					return Altitude.format(self.value);
				}
			}

			class ElevationInfo
			{
				public var ascent = null;
	  		public var descent = null;
	  		public var min = null;
	  		public var max = null;
			}

			function getInfo() {
				var history = SensorHistory.getElevationHistory({
			    :period => Keg.screenWidth,
			    :order  => 1 // oldest first
			  });

			  var ascent = 0;
			  var descent = 0;
			  var min = 0;
			  var max = 0;

			  if (history != null) {
			    var lastHeight = null;

			    while (true) {
			      var next = history.next();

			      if (next != null) {
			        if (next.data != null) {
			          var altitude = next.data.toFloat();

			          if (lastHeight == null) {
			            lastHeight = altitude;
			            min = altitude;
			            max = altitude;
			          }

			          if (altitude > lastHeight) {
			            ascent += -1 * (lastHeight - altitude);
			          } else {
			            descent += (lastHeight - altitude);
			          }

			          if (altitude < min) {
			          	min = altitude;
			          } else if (altitude > max) {
			          	max = altitude;
			          }

			          lastHeight = altitude;
			        }
			      } else {
			        break;
			      }
			    }
			  }

			  if (Elevation.instance == null) {
		    	Elevation.instance = new Elevation.ElevationInfo();
		    }

		    Elevation.instance.ascent = new Elevation.ElevationVariationInfo(ascent);
		    Elevation.instance.descent = new Elevation.ElevationVariationInfo(descent);
		    Elevation.instance.min = new Elevation.ElevationExtremityInfo(min);
		    Elevation.instance.max = new Elevation.ElevationExtremityInfo(max);

		    return Elevation.instance;
			}
		}
	}
}
