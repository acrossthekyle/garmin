using Toybox.Sensor;
using Toybox.UserProfile;

module Keg
{
	module Heart
	{
		var instance = null;

		(:glance)
		class HeartRestingInfo
		{
			public var value = null;

			public function asString() {
				return Heart.format(self.value);
			}
		}

		(:glance)
		class HeartInfo
		{
			public var value = null;
			public var resting = null;

			public function asString() {
			  return Heart.format(self.value);
			}
		}

		(:glance)
		function getInfo() {
			var rate = Sensor.getInfo().heartRate;

			var profile = UserProfile.getProfile();

			var restingRate = null;

			if (profile has :averageRestingHeartRate) {
		    restingRate = profile.averageRestingHeartRate;
		  }

			if (Heart.instance == null) {
	    	Heart.instance = new Heart.HeartInfo();
	    }

	    Heart.instance.value = rate;

	    if (Heart.instance.resting == null) {
	    	Heart.instance.resting = new Heart.HeartRestingInfo();
	    }

	    Heart.instance.resting.value = restingRate;

	    return Heart.instance;
		}
	}
}
