using Keg.Watchface.Data.ActiveMinutesToday;
using Keg.Watchface.Data.ActiveMinutesWeek;
using Keg.Watchface.Data.Altitude;
using Keg.Watchface.Data.AmbientPressure;
using Keg.Watchface.Data.BodyBattery;
using Keg.Watchface.Data.Calories;
using Keg.Watchface.Data.CurrentHeading;
using Keg.Watchface.Data.CurrentHeadingNato;
using Keg.Watchface.Data.CurrentHeadingNesw;
using Keg.Watchface.Data.Date;
using Keg.Watchface.Data.Distance;
using Keg.Watchface.Data.FloorsAscended;
using Keg.Watchface.Data.FloorsDescended;
using Keg.Watchface.Data.FloorsTotal;
using Keg.Watchface.Data.HeartRate;
using Keg.Watchface.Data.HeartRateZone;
using Keg.Watchface.Data.MoveLevel;
using Keg.Watchface.Data.RespirationRate;
using Keg.Watchface.Data.SeaLevelPressure;
using Keg.Watchface.Data.Speed;
using Keg.Watchface.Data.Steps;
using Keg.Watchface.Data.Sunrise;
using Keg.Watchface.Data.SunriseSunset;
using Keg.Watchface.Data.Sunset;
using Keg.Watchface.Data.Temperature;
using Keg.Watchface.Data.TimeToRecovery;
using Keg.Watchface.Data.WeatherCurrentTemperature;
using Keg.Watchface.Data.WeatherFeelsLike;
using Keg.Watchface.Data.WeatherHighLow;
using Keg.Watchface.Data.WeatherPrecipitationChance;
using Keg.Watchface.Data.WeatherRelativeHumidity;
using Keg.Watchface.Data.WeatherWindSpeed;

module Keg
{
	module Watchface
	{
		module Data
		{
			function getInfo(options) {
				var type = options.get(:type);

			  if (type == 1) {
			    return ActiveMinutesToday.getInfo(options);
			  }

			  if (type == 2) {
			    return ActiveMinutesWeek.getInfo(options);
			  }

			  if (type == 3) {
			    return Altitude.getInfo(options);
			  }

			  if (type == 4) {
			    return AmbientPressure.getInfo(options);
			  }

			  if (type == 5) {
			    return BodyBattery.getInfo(options);
			  }

			  if (type == 6) {
			    return Calories.getInfo(options);
			  }

			  if (type == 7) {
			    return CurrentHeading.getInfo(options);
			  }

			  if (type == 8) {
			    return CurrentHeadingNato.getInfo(options);
			  }

			  if (type == 9) {
			    return CurrentHeadingNesw.getInfo(options);
			  }

			  if (type == 10) {
			    return Date.getInfo(options);
			  }

			  if (type == 11) {
			    return Sunrise.getInfo(options);
			  }

			  if (type == 12) {
			    return Sunset.getInfo(options);
			  }

			  if (type == 13) {
			    return SunriseSunset.getInfo(options);
			  }

			  if (type == 14) {
			    return Distance.getInfo(options);
			  }

			  if (type == 15) {
			    return FloorsAscended.getInfo(options);
			  }

			  if (type == 16) {
			    return FloorsDescended.getInfo(options);
			  }

			  if (type == 17) {
			    return FloorsTotal.getInfo(options);
			  }

			  if (type == 18) {
			    return HeartRate.getInfo(options);
			  }

			  if (type == 19) {
			    return HeartRateZone.getInfo(options);
			  }

			  if (type == 20) {
			    return MoveLevel.getInfo(options);
			  }

			  if (type == 21) {
			    return RespirationRate.getInfo(options);
			  }

			  if (type == 22) {
			    return SeaLevelPressure.getInfo(options);
			  }

			  if (type == 23) {
			    return Speed.getInfo(options);
			  }

			  if (type == 24) {
			    return Steps.getInfo(options);
			  }

			  if (type == 25) {
			    return Temperature.getInfo(options);
			  }

			  if (type == 26) {
			    return TimeToRecovery.getInfo(options);
			  }

			  if (type == 27) {
			    return WeatherFeelsLike.getInfo(options);
			  }

			  if (type == 28) {
			    return WeatherHighLow.getInfo(options);
			  }

			  if (type == 29) {
			    return WeatherPrecipitationChance.getInfo(options);
			  }

			  if (type == 30) {
			    return WeatherRelativeHumidity.getInfo(options);
			  }

			  if (type == 31) {
			    return WeatherCurrentTemperature.getInfo(options);
			  }

			  if (type == 32) {
			    return WeatherWindSpeed.getInfo(options);
			  }

			  if (options.hasKey(:customMethod)) {
			    return options.get(:customMethod).invoke(options);
			  }

			  return null;
			}
		}
	}
}
