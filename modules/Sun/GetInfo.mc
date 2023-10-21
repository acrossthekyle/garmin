using Toybox.Math;
using Toybox.Position;
using Toybox.System;
using Toybox.Time as T;
using Toybox.Time.Gregorian;
using Toybox.Weather;
using Keg.Time;

module Keg
{
	module Sun
	{
		var instance = null;

		(:glance)
		class SunNextEventInfo
		{
			public var minutes = 0;
			public var hours = 0;
			public var event = :sunrise;

			public function asString() {
				return self.hours + "h " + self.minutes + "m";
			}
		}

		(:glance)
		class SunEventInfo
		{
			public var minute = 0;
			public var hour = 0;
			public var degree = 0;

			public function asString() {
				return Time.format(self.hour, self.minute);
			}
		}

		(:glance)
		class SunInfo
		{
			public var nextEvent = null;
			public var sunrise = null;
			public var sunset = null;
			public var tomorrow = null;
		}

		(:glance)
		function getInfo(position, moment) {
			if (Sun.instance == null) {
				Sun.instance = new Sun.SunInfo();
			}

			if (Sun.instance.nextEvent == null) {
				Sun.instance.nextEvent = new Sun.SunNextEventInfo();
			}

			if (Sun.instance.sunrise == null) {
				Sun.instance.sunrise = new Sun.SunEventInfo();
			}

			if (Sun.instance.sunset == null) {
				Sun.instance.sunset = new Sun.SunEventInfo();
			}

			if (Sun.instance.tomorrow == null) {
				Sun.instance.tomorrow = new Sun.SunEventInfo();
			}

			if (position == null) {
				return Sun.instance;
			}

			var location = new Position.Location({
				:latitude 	=> position[0],
				:longitude 	=> position[1],
				:format 		=> :radians
			});

			var sunrise = Weather.getSunrise(location, moment);
			var sunset = Weather.getSunset(location, moment);
			var sunriseTomorrow = Weather.getSunset(location, moment.add(new T.Duration(Gregorian.SECONDS_PER_DAY)));

			if (sunrise != null) {
				sunrise = Gregorian.info(sunrise, T.FORMAT_SHORT);

				Sun.instance.sunrise.minute = sunrise.min;
				Sun.instance.sunrise.hour = sunrise.hour;
				Sun.instance.sunrise.degree = -90 - ((sunrise.hour * 60) + sunrise.min)/4;
			}

			if (sunset != null) {
				sunset = Gregorian.info(sunset, T.FORMAT_SHORT);

				Sun.instance.sunset.minute = sunset.min;
				Sun.instance.sunset.hour = sunset.hour;
				Sun.instance.sunset.degree = -90 - ((sunset.hour * 60) + sunset.min)/4;
			}

			if (sunriseTomorrow != null) {
				sunriseTomorrow = Gregorian.info(sunriseTomorrow, T.FORMAT_SHORT);

				Sun.instance.tomorrow.minute = sunriseTomorrow.min;
				Sun.instance.tomorrow.hour = sunriseTomorrow.hour;
				Sun.instance.tomorrow.degree = -90 - ((sunriseTomorrow.hour * 60) + sunriseTomorrow.min)/4;
			}

			if (
	      Sun.instance.sunrise != null &&
	      Sun.instance.sunset != null &&
	      Sun.instance.tomorrow != null
	    ) {
	    	var clock = System.getClockTime();

	      var currentMinutes = (clock.hour * 60) + clock.min;

		    var sunriseMinutes = (Sun.instance.sunrise.hour * 60) + Sun.instance.sunrise.minute;
		    var sunsetMinutes = (Sun.instance.sunset.hour * 60) + Sun.instance.sunset.minute;
		    var sunriseTomorrowSinceNextMidnightMinutes = (Sun.instance.tomorrow.hour * 60) + Sun.instance.tomorrow.minute;

		    var isBeforeSunrise = currentMinutes < sunriseMinutes;
		    var isBetweenSunriseAndSunset = currentMinutes > sunriseMinutes && currentMinutes < sunsetMinutes;
		    var isAfterSunset = currentMinutes > sunsetMinutes;

		    var minutesUntilSunrise = 0;
		    var minutesSinceSunrise = 0;
		    var minutesBetweenSunriseAndSunset = sunsetMinutes - sunriseMinutes;

		    if (isBeforeSunrise) {
		      minutesUntilSunrise = sunriseMinutes - currentMinutes;
		    } else if (isBetweenSunriseAndSunset) {
		      minutesSinceSunrise = currentMinutes - sunriseMinutes;
		    } else if (isAfterSunset) {
		      minutesUntilSunrise = (1440 - currentMinutes) + sunriseTomorrowSinceNextMidnightMinutes;
		    }

		    var hours = 0;
		    var minutes = 0;

		    if (isBetweenSunriseAndSunset) {
		      var minutesUntilSunset = (minutesBetweenSunriseAndSunset - minutesSinceSunrise).abs();

		      hours = ((minutesUntilSunset * 60)/3600).abs();
		      minutes = Math.round((((minutesUntilSunset / 60.0) - hours.toNumber()) * 60).abs()).toNumber();

		      Sun.instance.nextEvent.event = :sunset;
		    } else {
		      hours = ((minutesUntilSunrise * 60)/3600).abs();
		      minutes = Math.round((((minutesUntilSunrise / 60.0) - hours.toNumber()) * 60).abs()).toNumber();

		      Sun.instance.nextEvent.event = :sunrise;
		    }

		    Sun.instance.nextEvent.hours = hours;
		    Sun.instance.nextEvent.minutes = minutes;
	    }

			return Sun.instance;
		}
	}
}
