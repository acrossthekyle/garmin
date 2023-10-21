using Toybox.ActivityMonitor;
using Keg.I18n;
using Keg.Watchface.Icons;

module Keg
{
	module Watchface
	{
		module Data
		{
			module Calories
			{
				var instance = null;

				class CaloriesInfo extends Data.DataInfo
				{
					public var units = "kCal";

					public function getIcon() {
						return Icons.getIcon(:Drawable_Calories);
					}

					public function getLabel() {
						return I18n.t(:Complications_Label_Calories);
					}

					public function asString() {
						return (self.value/self.divisor).format(self.precision);
					}
				}

				function getInfo(options) {
					if (Calories.instance == null) {
						Calories.instance = new Calories.CaloriesInfo();
					}

					var info = ActivityMonitor.getInfo();

					if (info != null) {
						if (info.calories != null) {
							Calories.instance.value = info.calories;
						}
					}

					return Calories.instance;
				}
			}
		}
	}
}
