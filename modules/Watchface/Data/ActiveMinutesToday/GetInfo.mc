using Toybox.ActivityMonitor;
using Toybox.Math;
using Keg.I18n;
using Keg.Watchface.Icons;

module Keg
{
	module Watchface
	{
		module Data
		{
			module ActiveMinutesToday
			{
				var instance = null;

				class ActiveMinutesTodayInfo extends Data.DataInfo
				{
					public function getIcon() {
						return Icons.getIcon(:Drawable_Activity);
					}

					public function getLabel() {
						return I18n.t(:Complications_Label_Active);
					}

					public function getUnitsLabel() {
						return I18n.t(:Complications_Label_Today);
					}

					public function asString() {
						if (self.value >= 6000) {
				      return Math.floor(self.value/60).format("%d") + "h";
				    }

				    if (self.value > 60) {
				      return Math.floor(self.value/60).format("%d") + "h";
				    }

				    return self.value.format("%d");
					}
				}

				function getInfo(options) {
					if (ActiveMinutesToday.instance == null) {
						ActiveMinutesToday.instance = new ActiveMinutesToday.ActiveMinutesTodayInfo();
					}

					var info = ActivityMonitor.getInfo();

				  if (info != null) {
				  	if (info.activeMinutesDay != null) {
				    	ActiveMinutesToday.instance.value = info.activeMinutesDay.total;

				    	if (info.activeMinutesDay.total > 60) {
					      ActiveMinutesToday.instance.units = (info.activeMinutesDay.total % 60) + "m";
					    } else {
					    	ActiveMinutesToday.instance.units = "m";
					    }
				    }
				  }

				  return ActiveMinutesToday.instance;
				}
			}
		}
	}
}
