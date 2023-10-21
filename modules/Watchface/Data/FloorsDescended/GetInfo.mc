using Toybox.ActivityMonitor;
using Keg.I18n;
using Keg.Watchface.Icons;

module Keg
{
	module Watchface
	{
		module Data
		{
			module FloorsDescended
			{
				var instance = null;

				class FloorsDescendedInfo extends Data.DataInfo
				{
					public function getIcon() {
						return Icons.getIcon(:Drawable_FloorsDescended);
					}

					public function getLabel() {
						return I18n.t(:Complications_Label_Floors);
					}

					public function getUnitsLabel() {
						return I18n.t(:Complications_Label_Descended);
					}
				}

				function getInfo(options) {
					if (FloorsDescended.instance == null) {
						FloorsDescended.instance = new FloorsDescended.FloorsDescendedInfo();
					}

					var info = ActivityMonitor.getInfo();

					if (info != null) {
						if (info.floorsDescended != null) {
				  		FloorsDescended.instance.value = info.floorsDescended;
				  	}
					}

					return FloorsDescended.instance;
				}
			}
		}
	}
}
