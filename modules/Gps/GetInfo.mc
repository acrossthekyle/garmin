using Toybox.Position;

module Keg
{
	module Gps
	{
		var instance = null;

		class GpsInfo
		{
			var accuracy = null;
			var latitude = 0;
			var longitude = 0;
		}

		function getInfo() {
			var position = Position.getInfo();

			var accuracy = null;
			var latitude = 0;
			var longitude = 0;

		  if (position != null) {
		    if (position.accuracy != null) {
		      accuracy = position.accuracy;
		    }

		    if (position.position != null) {
		      var positionDegrees = position.position.toDegrees();

		      latitude = positionDegrees[0];
			    longitude = positionDegrees[1];
		    }
		  }

		  if (Gps.instance == null) {
	    	Gps.instance = new Gps.GpsInfo();
	    }

	    Gps.instance.accuracy = accuracy;
	    Gps.instance.latitude = latitude;
	    Gps.instance.longitude = longitude;

	    return Gps.instance;
		}
	}
}
