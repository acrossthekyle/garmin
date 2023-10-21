using Toybox.Weather;
using Keg.I18n;
using Keg.Watchface.Icons;

module Keg
{
	module Watchface
	{
		module Data
		{
			module WeatherWindSpeed
			{
				var instance = null;

				class WeatherWindSpeedInfo extends Data.DataInfo
				{
					public var units = "%";

					public function getIcon() {
						return Icons.getIcon(:Drawable_Wind);
					}

					public function getLabel() {
						return I18n.t(:Complications_Label_WeatherWindSpeed);
					}
				}

				function getInfo(options) {
					if (WeatherWindSpeed.instance == null) {
						WeatherWindSpeed.instance = new WeatherWindSpeed.WeatherWindSpeedInfo();
					}

					WeatherWindSpeed.instance.units = (Data.isDistanceMetric ? "kph" : "mph");

					var info = Weather.getCurrentConditions();

					if (info != null) {
						if (info.windSpeed != null) {
				  		WeatherWindSpeed.instance.value = info.windSpeed.toFloat() * (Data.isDistanceMetric ? 3.6 : 2.237);
				  	}
					}

					return WeatherWindSpeed.instance;
				}
			}
		}
	}
}
