using Toybox.ActivityMonitor;
using Keg.I18n;
using Keg.Watchface.Icons;

module Keg
{
	module Watchface
	{
		module Data
		{
			module FloorsTotal
			{
				var instance = null;

				class FloorsTotalInfo extends Data.DataInfo
				{
					public function getIcon() {
						return Icons.getIcon(:Drawable_FloorsTotal);
					}

					public function getLabel() {
						return I18n.t(:Complications_Label_Floors);
					}

					public function getUnitsLabel() {
						return I18n.t(:Complications_Label_Total);
					}
				}

				function getInfo(options) {
					if (FloorsTotal.instance == null) {
						FloorsTotal.instance = new FloorsTotal.FloorsTotalInfo();
					}

					var info = ActivityMonitor.getInfo();

					if (info != null) {
						if (info.floorsClimbed != null && info.floorsDescended != null) {
				  		FloorsTotal.instance.value = (info.floorsClimbed + info.floorsDescended);
				  	}
					}

					return FloorsTotal.instance;
				}
			}
		}
	}
}
