using Toybox.Position;

module Keg
{
	module Watchface
	{
		module Location
		{
			function getLocation(latitude, longitude) {
			  var location = Position.getInfo().position;

			  if (location != null) {
			    var degrees = location.toDegrees();

			    if (degrees[0].toFloat() == 180.000000 && degrees[1].toFloat() == 180.000000) {
			      location = null;
			    }
			  }

			  if (location == null) {
			    if (latitude != 0.0000000 && longitude != 0.0000000) {
			      location = new Position.Location(
			        {
			          :latitude   => latitude,
			          :longitude  => longitude,
			          :format     => :degrees
			        }
			      );
			    }
			  }

			  return location;
			}
		}
	}
}
