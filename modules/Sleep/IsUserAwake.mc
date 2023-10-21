using Toybox.System;
using Toybox.UserProfile;

module Keg
{
	module Sleep
	{
		function isUserAwake() {
			var clockTime = System.getClockTime();
		  var profile = UserProfile.getProfile();

		  if (profile.sleepTime != null && profile.wakeTime != null) {
		    var clockTimeInSecondsSinceMidnight = clockTime.hour * 60 * 60;
		    		clockTimeInSecondsSinceMidnight += clockTime.min * 60;
		    		clockTimeInSecondsSinceMidnight += clockTime.sec;

		    var sleepTimeInSeconds = profile.sleepTime.value();
		    var wakeTimeInSeconds = profile.wakeTime.value();

		    var hasAwoken = clockTimeInSecondsSinceMidnight >= wakeTimeInSeconds;
		    var hasNotAwoken = clockTimeInSecondsSinceMidnight < wakeTimeInSeconds;
		    var hasGoneToSleep = clockTimeInSecondsSinceMidnight >= sleepTimeInSeconds;
		    var hasNotGoneToSleep = clockTimeInSecondsSinceMidnight < sleepTimeInSeconds;

		    // If the user is within the user-defined non-awake hours.
		    if (
		      (hasAwoken && hasGoneToSleep) ||
		      (hasNotAwoken && hasNotGoneToSleep)
		    ) {
		      return false;
		    }
		  }

		  // User is awake
		  return true;
		}
	}
}
