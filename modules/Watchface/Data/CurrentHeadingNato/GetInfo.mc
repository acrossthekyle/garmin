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
			module CurrentHeadingNato
			{
				var instance = null;

				class CurrentHeadingNatoInfo extends Data.DataInfo
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
					if (CurrentHeadingNato.instance == null) {
						CurrentHeadingNato.instance = new CurrentHeadingNato.CurrentHeadingNatoInfo();
					}

					var info = Activity.getActivityInfo();

				  if (info != null) {
				  	if (info.currentHeading != null) {
				  		var radians = info.currentHeading + Math.PI/180;

				      if (radians < 0) {
				        radians = 2 * Math.PI + radians;
				      }

				      var degrees = (Math.toDegrees(radians).toNumber() * 17.777778).format("%d").toCharArray();

				    	var digits = ["0", "0", "0", "0"];
				    	var x = 3;

				      for (var i = degrees.size() - 1; i >= 0; --i) {
				        digits[x] = degrees[i];

				        --x;
				      }

				      var value = "";

				      for (var k = 0; k < 4; ++k) {
				        value += digits[k];
				      }

				      CurrentHeadingNato.instance.value = value;
				  	}
				  }

				  return CurrentHeadingNato.instance;
				}
			}
		}
	}
}
