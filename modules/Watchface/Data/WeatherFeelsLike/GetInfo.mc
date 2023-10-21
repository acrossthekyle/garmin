using Toybox.Weather;
using Keg.I18n;
using Keg.Watchface.Icons;

module Keg
{
	module Watchface
	{
		module Data
		{
			module WeatherFeelsLike
			{
				var instance = null;

				class WeatherFeelsLikeInfo extends Data.DataInfo
				{
					public function getIcon() {
						return Icons.getIcon(:Drawable_Temperature);
					}

					public function getLabel() {
						return I18n.t(:Complications_Label_WeatherFeelsLike);
					}

					public function asString() {
						return (Data.isTemperatureMetric ? self.value : ((self.value * 9/5) + 32)).toFloat().format("%.1f");
					}
				}

				function getInfo(options) {
					if (WeatherFeelsLike.instance == null) {
						WeatherFeelsLike.instance = new WeatherFeelsLike.WeatherFeelsLikeInfo();
					}

					WeatherFeelsLike.instance.units = (Data.isTemperatureMetric ? "°C" : "°F");

					var info = Weather.getCurrentConditions();

					if (info != null) {
						if (info.feelsLikeTemperature != null) {
				  		WeatherFeelsLike.instance.value = info.feelsLikeTemperature;
				  	}
					}

					return WeatherFeelsLike.instance;
				}
			}
		}
	}
}
