using Toybox.Activity;
using Keg.I18n;
using Keg.Watchface.Icons;

module Keg
{
	module Watchface
	{
		module Data
		{
			module Speed
			{
				var instance = null;

				class SpeedInfo extends Data.DataInfo
				{
					public function getIcon() {
						return Icons.getIcon(:Drawable_Speed);
					}

					public function getLabel() {
						return I18n.t(:Complications_Label_Speed);
					}
				}

				function getInfo(options) {
					if (Speed.instance == null) {
						Speed.instance = new Speed.SpeedInfo();
					}

					Speed.instance.units = (Data.isDistanceMetric ? "kph" : "mph");

					var info = Activity.getActivityInfo();

					if (info != null) {
				  	if (info.currentSpeed != null) {
				  		Speed.instance.value = info.currentSpeed.toFloat() * (Data.isDistanceMetric ? 3.6 : 2.237);
				  	}
				  }

				  return Speed.instance;
				}
			}
		}
	}
}
