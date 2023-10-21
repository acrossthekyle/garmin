using Toybox.System;
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
			module SunriseSunset
			{
				var instance = null;

				class SunriseSunsetInfo extends Data.DataInfo
				{
					public var isSunrise = false;
					public var isSunriseTomorrow = false;

					public function getIcon() {
						return self.isSunrise || self.isSunriseTomorrow
							? Icons.getIcon(:Drawable_Sunrise)
							: Icons.getIcon(:Drawable_Sunset);
					}

					public function getLabel() {
						return self.isSunrise || self.isSunriseTomorrow
							? I18n.t(:Complications_Label_Sunrise)
							: I18n.t(:Complications_Label_Sunset);
					}

					public function getUnitsLabel() {
						return self.isSunriseTomorrow
						  ? I18n.t(:Complications_Label_Tomorrow)
						  : I18n.t(:Complications_Label_Today);
					}

					public function asString() {
						return self.value;
					}
				}

				function getInfo(options) {
					if (SunriseSunset.instance == null) {
						SunriseSunset.instance = new SunriseSunset.SunriseSunsetInfo();
					}

					var data = Cache.fetch(options.get(:key));

					if (data == null) {
						var location = Location.getLocation(options.get(:latitude), options.get(:longitude));

					  if (location != null) {
					    var sunrise = Weather.getSunrise(location, Time.now());
					    var sunset = Weather.getSunset(location, Time.now());
					    var sunriseTomorrow = Weather.getSunrise(location, Time.now().add(new Time.Duration(Gregorian.SECONDS_PER_DAY)));

					    if (sunrise != null && sunset != null && sunriseTomorrow != null) {
					      var sunriseGregorian = Gregorian.info(sunrise, Time.FORMAT_SHORT);
					      var sunsetGregorian = Gregorian.info(sunset, Time.FORMAT_SHORT);
					      var sunriseTomorrowGregorian = Gregorian.info(sunriseTomorrow, Time.FORMAT_SHORT);

					      data = [
					        [sunriseGregorian.hour, sunriseGregorian.min],
					        [sunsetGregorian.hour, sunsetGregorian.min],
					        [sunriseTomorrowGregorian.hour, sunriseTomorrowGregorian.min]
					      ];
					    }
					  }

					  Cache.save(options.get(:key), null, :today, data);
					}

					SunriseSunset.instance.icon = null;

  				var sunrise = null;
				  var sunset = null;
				  var sunriseTomorrow = null;

				  var label = null;
				  var unitsLabel = null;

				  var clock = System.getClockTime();

				  if (data != null) {
				    sunrise = data[0];
				    sunset = data[1];
				    sunriseTomorrow = data[2];

				    var currentMinutes = (clock.hour * 60) + clock.min;
				    var sunriseMinutes = (sunrise[0] * 60) + sunrise[1];
				    var sunsetMinutes = (sunset[0] * 60) + sunset[1];

				    var isBeforeSunrise = currentMinutes < sunriseMinutes;
				    var isBetweenSunriseAndSunset = currentMinutes > sunriseMinutes && currentMinutes < sunsetMinutes;
				    var isAfterSunset = currentMinutes > sunsetMinutes;

				    var hour = null;
				    var minute = null;

				    if (isBeforeSunrise) {
				      SunriseSunset.instance.isSunrise = true;
				      SunriseSunset.instance.isSunriseTomorrow = false;

				      hour = sunrise[0];
				      minute = sunrise[1].format(sunrise[1] < 10 ? "%02d" : "%d");

				      if (Data.isMeridean) {
				        hour = hour > 12 ? hour - 12 : hour;
				      }
				    } else if (isBetweenSunriseAndSunset) {
				    	SunriseSunset.instance.isSunrise = false;
				    	SunriseSunset.instance.isSunriseTomorrow = false;

				      hour = sunset[0];
				      minute = sunset[1].format(sunset[1] < 10 ? "%02d" : "%d");

				      if (Data.isMeridean) {
				        hour = hour > 12 ? hour - 12 : hour;
				      }
				    } else if (isAfterSunset) {
				    	SunriseSunset.instance.isSunrise = true;
				    	SunriseSunset.instance.isSunriseTomorrow = true;

				      hour = sunriseTomorrow[0];
				      minute = sunriseTomorrow[1].format(sunriseTomorrow[1] < 10 ? "%02d" : "%d");

				      if (Data.isMeridean) {
				        hour = hour > 12 ? hour - 12 : hour;
				      }
				    }

				    if (hour != null && minute != null) {
				      SunriseSunset.instance.value = (hour.format(hour < 10 ? "%02d" : "%d") + ":" + minute);
				    }
				  }

				  return SunriseSunset.instance;
				}
			}
		}
	}
}
