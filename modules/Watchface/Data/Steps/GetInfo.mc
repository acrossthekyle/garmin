using Toybox.ActivityMonitor;
using Keg.I18n;
using Keg.Watchface.Icons;

module Keg
{
	module Watchface
	{
		module Data
		{
			module Steps
			{
				var instance = null;

				class StepsInfo extends Data.DataInfo
				{
					public function getIcon() {
						return Icons.getIcon(:Drawable_Steps);
					}

					public function getLabel() {
						return I18n.t(:Complications_Label_Steps);
					}

					public function getUnitsLabel() {
						return I18n.t(:Complications_Label_Today);
					}
				}

				function getInfo(options) {
					if (Steps.instance == null) {
						Steps.instance = new Steps.StepsInfo();
					}

					var info = ActivityMonitor.getInfo();

					if (info != null) {
						if (info.steps != null) {
				  		Steps.instance.value = info.steps;
				  	}
					}

					return Steps.instance;
				}
			}
		}
	}
}
