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
			module Altitude
			{
				var instance = null;

				class AltitudeInfo extends Data.DataInfo
				{
					public function getIcon() {
						return Icons.getIcon(:Drawable_Altitude);
					}

					public function getLabel() {
						return I18n.t(:Complications_Label_Altitude);
					}

					public function asString() {
						return Data.isAltitudeMetric
				    	? self.value.toFloat().format("%.1f")
				    	: Math.ceil((self.value * 3.28084)).format("%d");
					}
				}

				function getInfo(options) {
					if (Altitude.instance == null) {
						Altitude.instance = new Altitude.AltitudeInfo();
					}

					Altitude.instance.units = Data.isAltitudeMetric ? "m" : "ft";

					var info = Activity.getActivityInfo();

				  if (info != null) {
				  	if (info.altitude != null) {
				  		Altitude.instance.value = info.altitude;
				    }
				  }

				  return Altitude.instance;
				}
			}
		}
	}
}
