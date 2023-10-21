using Toybox.Activity;
using Toybox.UserProfile;
using Keg.I18n;
using Keg.Watchface.Icons;

module Keg
{
	module Watchface
	{
		module Data
		{
			module HeartRateZone
			{
				var instance = null;

				class HeartRateZoneInfo extends Data.DataInfo
				{
					public var units = "/5";

					public function getIcon() {
						return Icons.getIcon(:Drawable_HeartRate);
					}

					public function getLabel() {
						return I18n.t(:Complications_Label_HeartRateZone);
					}
				}

				function getInfo(options) {
					if (HeartRateZone.instance == null) {
						HeartRateZone.instance = new HeartRateZone.HeartRateZoneInfo();
					}

					var zones = UserProfile.getHeartRateZones(0);

					var info = Activity.getActivityInfo();

					var zone = 1;

				  if (info != null) {
				  	if (info.currentHeartRate != null) {
				  		if (info.currentHeartRate >= zones[0] && info.currentHeartRate < zones[1]) {
				        zone = 1;
				      } else if (info.currentHeartRate >= zones[1] && info.currentHeartRate < zones[2]) {
				        zone = 2;
				      } else if (info.currentHeartRate >= zones[2] && info.currentHeartRate < zones[3]) {
				        zone = 3;
				      } else if (info.currentHeartRate >= zones[3] && info.currentHeartRate < zones[4]) {
				        zone = 4;
				      } else if (info.currentHeartRate >= zones[4]) {
				        zone = 5;
				      }
				  	}
				  }

				  HeartRateZone.instance.value = zone;

				  return HeartRateZone.instance;
				}
			}
		}
	}
}
