using Toybox.Weather;
using Keg.I18n;
using Keg.Watchface.Icons;

module Keg
{
	module Watchface
	{
		module Data
		{
			module WeatherRelativeHumidity
			{
				var instance = null;

				class WeatherRelativeHumidityInfo extends Data.DataInfo
				{
					public var units = "%";

					public function getIcon() {
						return Icons.getIcon(:Drawable_Humidity);
					}

					public function getLabel() {
						return I18n.t(:Complications_Label_WeatherRelativeHumidity);
					}
				}

				function getInfo(options) {
					if (WeatherRelativeHumidity.instance == null) {
						WeatherRelativeHumidity.instance = new WeatherRelativeHumidity.WeatherRelativeHumidityInfo();
					}

					var info = Weather.getCurrentConditions();

					if (info != null) {
						if (info.relativeHumidity != null) {
				  		WeatherRelativeHumidity.instance.value = info.relativeHumidity;
				  	}
					}

					return WeatherRelativeHumidity.instance;
				}
			}
		}
	}
}
