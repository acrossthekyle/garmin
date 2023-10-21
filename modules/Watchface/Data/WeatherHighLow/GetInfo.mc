using Toybox.Weather;
using Keg.I18n;
using Keg.Watchface.Icons;

module Keg
{
	module Watchface
	{
		module Data
		{
			module WeatherHighLow
			{
				var instance = null;

				class WeatherHighLowInfo extends Data.DataInfo
				{
					public var value = [0, 0];

					public function getIcon() {
						return Icons.getIcon(:Drawable_Temperature);
					}

					public function getLabel() {
						return I18n.t(:Complications_Label_WeatherHighLow);
					}

					public function asString() {
						var low = (Data.isTemperatureMetric ? self.value[0] : ((self.value[0] * 9/5) + 32)).toFloat().format("%.1f");
						var high = (Data.isTemperatureMetric ? self.value[1] : ((self.value[1] * 9/5) + 32)).toFloat().format("%.1f");

						return high + "/" + low;
					}
				}

				function getInfo(options) {
					if (WeatherHighLow.instance == null) {
						WeatherHighLow.instance = new WeatherHighLow.WeatherHighLowInfo();
					}

					WeatherFeelsLike.instance.units = (Data.isTemperatureMetric ? "°C" : "°F");

					var info = Weather.getCurrentConditions();

					if (info != null) {
						if (info.lowTemperature != null) {
				  		WeatherHighLow.instance.value[0] = info.lowTemperature;
				  	}

						if (info.highTemperature != null) {
				  		WeatherHighLow.instance.value[1] = info.highTemperature;
				  	}
					}

					return WeatherHighLow.instance;
				}
			}
		}
	}
}
