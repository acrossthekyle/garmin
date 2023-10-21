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
			module ActiveMinutesWeek
			{
				var instance = null;

				class ActiveMinutesWeekInfo extends Data.DataInfo
				{
					public function getIcon() {
						return Icons.getIcon(:Drawable_Activity);
					}

					public function getLabel() {
						return I18n.t(:Complications_Label_Active);
					}

					public function getUnitsLabel() {
						return I18n.t(:Complications_Label_Week);
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
					if (ActiveMinutesWeek.instance == null) {
						ActiveMinutesWeek.instance = new ActiveMinutesWeek.ActiveMinutesWeekInfo();
					}

					var info = ActivityMonitor.getInfo();

				  if (info != null) {
				  	if (info.activeMinutesWeek != null) {
				    	ActiveMinutesWeek.instance.value = info.activeMinutesWeek.total;

				    	if (info.activeMinutesWeek.total > 60) {
					      ActiveMinutesWeek.instance.units = (info.activeMinutesWeek.total % 60) + "m";
					    } else {
					    	ActiveMinutesWeek.instance.units = "m";
					    }
				    }
				  }

					return ActiveMinutesWeek.instance;
				}
			}
		}
	}
}
