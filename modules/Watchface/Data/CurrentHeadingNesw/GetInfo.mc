using Toybox.Activity;
using Toybox.Math;
using Keg.I18n;
using Keg.Watchface.Icons;

module Keg
{
	module Watchface
	{
		module Data
		{
			module CurrentHeadingNesw
			{
				var instance = null;

				class CurrentHeadingNeswInfo extends Data.DataInfo
				{
					public function getIcon() {
						return Icons.getIcon(:Drawable_Compass);
					}

					public function getLabel() {
						return I18n.t(:Complications_Label_Heading);
					}

					public function getUnitsLabel() {
						return I18n.t(:Complications_Label_HeadingTrueNorth);
					}

					public function asString() {
						return self.value;
					}
				}

				function getInfo(options) {
					if (CurrentHeadingNeswInfo.instance == null) {
						CurrentHeadingNeswInfo.instance = new CurrentHeadingNeswInfo.CurrentHeadingNeswInfo();
					}

					var info = Activity.getActivityInfo();

				  if (info != null) {
				  	if (info.currentHeading != null) {
				      var radians = info.currentHeading + Math.PI/180;

				      if (radians < 0) {
				        radians = 2 * Math.PI + radians;
				      }

				    	var degrees = Math.toDegrees(radians).toNumber();

				      CurrentHeadingNeswInfo.instance.value = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"][(Math.round((degrees/22.5) + 0.5).toNumber() % 16)];
				    }
				  }

				  return CurrentHeadingNeswInfo.instance;
				}
			}
		}
	}
}
