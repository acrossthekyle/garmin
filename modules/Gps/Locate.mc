using Toybox.Position;

module Keg
{
	module Gps
	{
		var instance = null;

		(:glance)
		class LocationInfo
		{
			public var acquiring = false;
			public var error = false;
			public var located = false;

			public var radians = null;

			public function asArray() {
				return self.radians;
			}

			function onLocationAcquired(info) {
				var positionAsRadians = info.position.toRadians();

				self.acquiring = false;
				self.error = false;
				self.located = false;

		    if (positionAsRadians != null) {
		      self.radians = positionAsRadians;

		      if (self.radians[0] != self.radians[1]) {
		        var latLong = info.position.toDegrees();

		        self.located = true;

		        return;
		      }
		    }

		    self.error = true;
			}
		}

		(:glance)
		function locate(useGps, fromSettings) {
			if (Gps.instance == null) {
				Gps.instance = new Gps.LocationInfo();
			}

			Gps.instance.radians = null;
			Gps.instance.acquiring = false;
			Gps.instance.error = false;
			Gps.instance.located = false;

			var position = Position.getInfo();

	    if (
	      position.accuracy != 0 &&
	      position.accuracy != null &&
	      position.position != null &&
	      useGps == true
	    ) {
	      Gps.instance.radians = position.position.toRadians();

	      // If the set of radians do not match eachother then do not continue.
	      // If they do match then continue because this is an invalid location.
	      if (Gps.instance.radians[0] != Gps.instance.radians[1]) {
	      	Gps.instance.located = true;

	        return Gps.instance;
	      }

	      Gps.instance.radians = null;
	    }

	    if (
	    	Gps.instance.radians == null &&
	    	fromSettings[0] != 0.0 &&
	    	fromSettings[1] != 0.0
	    ) {
	      Gps.instance.located = true;

	      Gps.instance.radians = new Position.Location(
	        {
	          :latitude   => fromSettings[0],
	          :longitude  => fromSettings[1],
	          :format     => :degrees
	        }
	      ).toRadians();

	      return Gps.instance;
	    }

	    if (Gps.instance.radians == null && useGps == true) {
	      Gps.instance.acquiring = true;

	      Position.enableLocationEvents(
	        Position.LOCATION_ONE_SHOT,
	        Gps.instance.method(:onLocationAcquired)
	      );

	      return Gps.instance;
	    }

	    Gps.instance.error = true;

	    return Gps.instance;
		}
	}
}
