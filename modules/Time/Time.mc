using Toybox.System;

module Keg
{
	module Time
	{
		var is24Hour = System.getDeviceSettings().is24Hour;

		(:glance)
		function format(hour, minute) {
		  if (hour == null || minute == null) {
		    return "--:--";
		  }

		  hour = self.is24Hour ? hour : (hour > 12 ? hour - 12 : hour);

		  return hour.format(hour < 10 ? "%02d" : "%d") + ":" + minute.format(minute < 10 ? "%02d" : "%d");
		}
	}
}
