using Toybox.Weather;
using Keg.I18n;
using Keg.Watchface.Icons;

module Keg
{
	module Watchface
	{
		module Data
		{
			module WeatherCurrentTemperature
			{
				var instance = null;

				class WeatherCurrentTemperatureInfo extends Data.DataInfo
				{
					public var unitsLabel = "--/--";

					public function getIcon() {
						return Icons.getIcon(:Drawable_Temperature);
					}

					public function getLabel() {
						return I18n.t(:Complications_Label_WeatherCurrentTemperature);
					}

					public function getUnitsLabel() {
						return self.unitsLabel;
					}

					public function asString() {
						return (Data.isTemperatureMetric ? self.value : ((self.value * 9/5) + 32)).toFloat().format("%.1f");
					}
				}

				function getInfo(options) {
					if (WeatherCurrentTemperature.instance == null) {
						WeatherCurrentTemperature.instance = new WeatherCurrentTemperature.WeatherCurrentTemperatureInfo();
					}

					WeatherCurrentTemperature.instance.units = (Data.isTemperatureMetric ? "°C" : "°F");

					var info = Weather.getCurrentConditions();

					var high = null;
					var low = null;

					if (info != null) {
						if (info.temperature != null) {
				  		WeatherCurrentTemperature.instance.value = info.temperature;
				  	}

				  	if (info.highTemperature != null) {
				  		high = (Data.isTemperatureMetric ? info.highTemperature : ((info.highTemperature * 9/5) + 32)).toFloat().format("%.1f");
				  	}

				  	if (info.lowTemperature != null) {
				  		low = (Data.isTemperatureMetric ? info.lowTemperature : ((info.lowTemperature * 9/5) + 32)).toFloat().format("%.1f");
				  	}
					}

					WeatherCurrentTemperature.instance.unitsLabel = (high == null ? "--" : high) + "/" + (low == null ? "--" : low);

					return WeatherCurrentTemperature.instance;
				}
			}
		}
	}
}
