using Toybox.ActivityMonitor;
using Keg.I18n;
using Keg.Watchface.Icons;

module Keg
{
	module Watchface
	{
		module Data
		{
			module FloorsAscended
			{
				var instance = null;

				class FloorsAscendedInfo extends Data.DataInfo
				{
					public function getIcon() {
						return Icons.getIcon(:Drawable_FloorsAscended);
					}

					public function getLabel() {
						return I18n.t(:Complications_Label_Floors);
					}

					public function getUnitsLabel() {
						return I18n.t(:Complications_Label_Ascended);
					}
				}

				function getInfo(options) {
					if (FloorsAscended.instance == null) {
						FloorsAscended.instance = new FloorsAscended.FloorsAscendedInfo();
					}

					var info = ActivityMonitor.getInfo();

					if (info != null) {
						if (info.floorsClimbed != null) {
				  		FloorsAscended.instance.value = info.floorsClimbed;
				  	}
					}

					return FloorsAscended.instance;
				}
			}
		}
	}
}
