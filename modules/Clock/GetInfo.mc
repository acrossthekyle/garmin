using Toybox.System;

module Keg
{
	module Clock
	{
		var instance = null;

		(:glance)
		class ClockInfo
		{
			public var minutesSinceMidnight = 0;
			public var secondsUntilMidnight = 0;
		}

		(:glance)
		function getInfo() {
			if (self.instance == null) {
				self.instance = new Clock.ClockInfo();
			}

			self.instance.minutesSinceMidnight = (Clock.time.hour * 60) + Clock.time.min;
			self.instance.secondsUntilMidnight = (1440 - self.instance.minutesSinceMidnight) * 60;

			return self.instance;
		}
	}
}
