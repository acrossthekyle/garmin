using Toybox.ActivityMonitor;
using Keg.I18n;
using Keg.Watchface.Icons;

module Keg
{
	module Watchface
	{
		module Data
		{
			module Distance
			{
				var instance = null;

				class DistanceInfo extends Data.DataInfo
				{
					public var precision = "%d";

					public function getIcon() {
						return Icons.getIcon(:Drawable_Distance);
					}

					public function getLabel() {
						return I18n.t(:Complications_Label_Distance);
					}

					public function asString() {
						return self.value.format(self.precision);
					}
				}

				function getInfo(options) {
					if (Distance.instance == null) {
						Distance.instance = new Distance.DistanceInfo();
					}

					Distance.instance.units = (Data.isDistanceMetric ? "m" : "ft");

					var info = ActivityMonitor.getInfo();

					Distance.instance.precision = "%d";

				  if (info != null) {
				  	if (info.distance != null) {
				  		Distance.instance.value = info.distance;

					    if (Data.isDistanceMetric) {
					      Distance.instance.value = Distance.instance.value/100.0;
					    } else {
					      Distance.instance.value = Distance.instance.value/30.48;
					    }

					    var divider = Data.isDistanceMetric ? 1000.0 : 5280.0;

					    if (Distance.instance.value >= divider) {
					      Distance.instance.value = Distance.instance.value/divider;

					      Distance.instance.units = Data.isDistanceMetric ? "km" : "mi";
					      Distance.instance.precision = "%.1f";
					    }
				  	}
				  }

					return Distance.instance;
				}
			}
		}
	}
}
