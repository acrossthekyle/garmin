using Toybox.Weather;
using Keg.I18n;
using Keg.Watchface.Icons;

module Keg
{
	module Watchface
	{
		module Data
		{
			module WeatherPrecipitationChance
			{
				var instance = null;

				class WeatherPrecipitationChanceInfo extends Data.DataInfo
				{
					public var units = "%";

					public function getIcon() {
						return Icons.getIcon(:Drawable_Rain);
					}

					public function getLabel() {
						return I18n.t(:Complications_Label_WeatherPrecipitationChance);
					}
				}

				function getInfo(options) {
					if (WeatherPrecipitationChance.instance == null) {
						WeatherPrecipitationChance.instance = new WeatherPrecipitationChance.WeatherPrecipitationChanceInfo();
					}

					var info = Weather.getCurrentConditions();

					if (info != null) {
						if (info.precipitationChance != null) {
				  		WeatherPrecipitationChance.instance.value = info.precipitationChance;
				  	}
					}

					return WeatherPrecipitationChance.instance;
				}
			}
		}
	}
}
