using Toybox.ActivityMonitor;
using Keg.I18n;
using Keg.Watchface.Icons;

module Keg
{
	module Watchface
	{
		module Data
		{
			module TimeToRecovery
			{
				var instance = null;

				class TimeToRecoveryInfo extends Data.DataInfo
				{
					public var units = "h";

					public function getIcon() {
						return Icons.getIcon(:Drawable_Activity);
					}

					public function getLabel() {
						return I18n.t(:Complications_Label_RecoveryTime);
					}
				}

				function getInfo(options) {
					if (TimeToRecovery.instance == null) {
						TimeToRecovery.instance = new TimeToRecovery.TimeToRecoveryInfo();
					}

					var info = ActivityMonitor.getInfo();

					if (info != null) {
						if (info has :timeToRecovery) {
							if (info.timeToRecovery != null) {
				    		TimeToRecovery.instance.value = info.timeToRecovery;
				    	}
						}
					}

					return TimeToRecovery.instance;
				}
			}
		}
	}
}
