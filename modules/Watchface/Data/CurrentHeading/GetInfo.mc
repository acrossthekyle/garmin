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
			module CurrentHeading
			{
				var instance = null;

				class CurrentHeadingInfo extends Data.DataInfo
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
						return self.value + "°";
					}
				}

				function getInfo(options) {
					if (CurrentHeading.instance == null) {
						CurrentHeading.instance = new CurrentHeading.CurrentHeadingInfo();
					}

					var info = Activity.getActivityInfo();

				  if (info != null) {
				  	if (info.currentHeading != null) {
				  		var radians = info.currentHeading + Math.PI/180;

				      if (radians < 0) {
				        radians = 2 * Math.PI + radians;
				      }

				      var degrees = Math.toDegrees(radians).toNumber().format("%d").toCharArray();

				      var digits = ["0", "0", "0"];
				      var x = 2;

				      for (var i = degrees.size() - 1; i >= 0; --i) {
				        digits[x] = degrees[i];

				        --x;
				      }

				      var value = "";

				      for (var k = 0; k < 3; ++k) {
				        value += digits[k];
				      }

				      CurrentHeading.instance.value = value;
				  	}
				  }

				  return CurrentHeading.instance;
				}
			}
		}
	}
}
