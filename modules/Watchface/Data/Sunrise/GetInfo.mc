using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Weather;
using Keg.Cache;
using Keg.I18n;
using Keg.Watchface.Icons;
using Keg.Watchface.Location;

module Keg
{
	module Watchface
	{
		module Data
		{
			module Sunrise
			{
				var instance = null;

				class SunriseInfo extends Data.DataInfo
				{
					public function getIcon() {
						return Icons.getIcon(:Drawable_Sunrise);
					}

					public function getLabel() {
						return I18n.t(:Complications_Label_Sunrise);
					}

					public function getUnitsLabel() {
						return I18n.t(:Complications_Label_Today);
					}

					public function asString() {
						return self.value;
					}
				}

				function getInfo(options) {
					if (Sunrise.instance == null) {
						Sunrise.instance = new Sunrise.SunriseInfo();
					}

					var data = Cache.fetch(options.get(:key));

					if (data == null) {
						var location = Location.getLocation(options.get(:latitude), options.get(:longitude));

					  if (location != null) {
					    var sunrise = Weather.getSunrise(location, Time.now());

					    if (sunrise != null) {
					      var grego = Gregorian.info(sunrise, Time.FORMAT_SHORT);

					      var hour = grego.hour;
					      var minute = grego.min.format(grego.min < 10 ? "%02d" : "%d");

					      if (Data.isMeridean) {
					        hour = hour > 12 ? hour - 12 : hour;
					      }

					      data = hour.format(hour < 10 ? "%02d" : "%d") + ":" + minute;
					    }
					  }

					  Cache.save(options.get(:key), null, :today, data);
					}

					Sunrise.instance.value = data;

					return Sunrise.instance;
				}
			}
		}
	}
}
