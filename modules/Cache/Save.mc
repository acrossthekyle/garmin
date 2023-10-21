using Toybox.Application.Storage;
using Toybox.Time;
using Keg.Clock;

module Keg
{
	module Cache
	{
		function save(id, duration, time, data) {
		  var now = Time.now().value();

		  var expiresOn = 0;

	    if (time == :minutes) {
	      expiresOn = now + (60 * duration);
	    } else if (time == :days) {
	      expiresOn = now + (86400 * duration);
	    } else if (time == :today) {
	    	expiresOn = now + Clock.getInfo().secondsUntilMidnight;
	    }

	    Storage.setValue(id + expiresOnSuffix, expiresOn);
	    Storage.setValue(id, data);
	  }
	}
}
