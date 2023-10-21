using Toybox.Activity;
using Keg.I18n;
using Keg.Watchface.Icons;

module Keg
{
	module Watchface
	{
		module Data
		{
			module HeartRate
			{
				var instance = null;

				class HeartRateInfo extends Data.DataInfo
				{
					public var units = "bpm";

					public function getIcon() {
						return Icons.getIcon(:Drawable_HeartRate);
					}

					public function getLabel() {
						return I18n.t(:Complications_Label_Floors);
					}

					public function getUnitsLabel() {
						return I18n.t(:Complications_Label_HeartRate);
					}
				}

				function getInfo(options) {
					if (HeartRate.instance == null) {
						HeartRate.instance = new HeartRate.HeartRateInfo();
					}

					var info = Activity.getActivityInfo();

					if (info != null) {
						if (info.currentHeartRate != null) {
				  		HeartRate.instance.value = info.currentHeartRate;
				  	}
					}

					return HeartRate.instance;
				}
			}
		}
	}
}
