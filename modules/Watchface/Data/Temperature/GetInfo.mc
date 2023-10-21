using Toybox.Activity;
using Toybox.Math;
using Toybox.SensorHistory;
using Keg.I18n;
using Keg.Watchface.Icons;

module Keg
{
	module Watchface
	{
		module Data
		{
			module Temperature
			{
				var instance = null;

				class TemperatureInfo extends Data.DataInfo
				{
					public function getIcon() {
						return Icons.getIcon(:Drawable_Temperature);
					}

					public function getLabel() {
						return I18n.t(:Complications_Label_Temperature);
					}

					public function asString() {
						return (Data.isTemperatureMetric ? self.value : ((self.value * 9/5) + 32)).toFloat().format("%.1f");
					}
				}

				function getInfo(options) {
					if (Temperature.instance == null) {
						Temperature.instance = new Temperature.TemperatureInfo();
					}

					Temperature.instance.units = (Data.isTemperatureMetric ? "°C" : "°F");

					var info = Activity.getActivityInfo();

					var isOnWrist = false;
					var temperature = null;

					if (info != null) {
						isOnWrist = info.currentHeartRate != null;
					}

					var i = SensorHistory.getTemperatureHistory({
				    :period => 1,
				    :order  => null
				  });

				  if (i != null) {
				    var n = i.next();

				    if (n != null) {
				      if (n.data != null) {
				        temperature = n.data.toFloat();
				      }
				    }
				  }

					if (temperature != null) {
						// convert to core if on wrist
						if (isOnWrist) {
							// Convert sensor reading to estimated core temperature
							temperature = Math.ceil((0.64 * 37.0) + (0.36 * temperature)).toFloat();
							// Add adjustment and convert to Fahrenheit first, if necessary
							temperature = (Data.isTemperatureMetric ? temperature : ((temperature * 9/5) + 32));
							// Convert back to metric, if necessary, after adding adjustment
							temperature = Data.isTemperatureMetric ? temperature : ((temperature - 32) * 5/9);
						}

						Temperature.instance.value = temperature;
					}

					return Temperature.instance;
				}
			}
		}
	}
}
