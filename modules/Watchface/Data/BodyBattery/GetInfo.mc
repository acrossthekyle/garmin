using Toybox.SensorHistory;
using Keg.I18n;
using Keg.Watchface.Icons;

module Keg
{
	module Watchface
	{
		module Data
		{
			module BodyBattery
			{
				var instance = null;

				class BodyBatteryInfo extends Data.DataInfo
				{
					public var units = "%";

					public function getIcon() {
						return Icons.getIcon(:Drawable_BodyBattery);
					}

					public function getLabel() {
						return I18n.t(:Complications_Label_BodyBattery);
					}
				}

				function getInfo(options) {
					if (BodyBattery.instance == null) {
						BodyBattery.instance = new BodyBattery.BodyBatteryInfo();
					}

					var history = SensorHistory.getBodyBatteryHistory({
				    :period => 1,
				    :order  => null // latest
				  });

				  if (history != null) {
				    var item = history.next();

				    if (item != null) {
				      if (item.data != null) {
				        BodyBattery.instance.value = item.data.toFloat();
				      }
				    }
				  }

				  return BodyBattery.instance;
				}
			}
		}
	}
}
