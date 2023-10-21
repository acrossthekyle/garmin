using Toybox.ActivityMonitor;
using Keg.I18n;
using Keg.Watchface.Icons;

module Keg
{
	module Watchface
	{
		module Data
		{
			module RespirationRate
			{
				var instance = null;

				class RespirationRateInfo extends Data.DataInfo
				{
					public var units = "brpm";

					public function getIcon() {
						return Icons.getIcon(:Drawable_Respiration);
					}

					public function getLabel() {
						return I18n.t(:Complications_Label_RespirationRate);
					}
				}

				function getInfo(options) {
					if (RespirationRate.instance == null) {
						RespirationRate.instance = new RespirationRate.RespirationRateInfo();
					}

					var info = ActivityMonitor.getInfo();

					if (info != null) {
						if (info.respirationRate != null) {
				  		RespirationRate.instance.value = info.respirationRate;
				  	}
					}

					return RespirationRate.instance;
				}
			}
		}
	}
}
