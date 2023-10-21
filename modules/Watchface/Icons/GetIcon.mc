using Toybox.WatchUi;

module Keg
{
	module Watchface
	{
		module Icons
		{
	  	var Drawable_Activity = null;
	  	var Drawable_Alarm = null;
	  	var Drawable_Altitude = null;
	  	var Drawable_Battery = null;
	  	var Drawable_Bluetooth = null;
	  	var Drawable_Calories = null;
	  	var Drawable_Compass = null;
	  	var Drawable_Date = null;
	  	var Drawable_Daylight = null;
	  	var Drawable_Distance = null;
	  	var Drawable_DoNotDisturb = null;
	  	var Drawable_FloorsTotal = null;
	  	var Drawable_FloorsAscended = null;
	  	var Drawable_FloorsDescended = null;
	  	var Drawable_HeartRate = null;
	  	var Drawable_Humidity = null;
	  	var Drawable_Notification = null;
	  	var Drawable_Pressure = null;
	  	var Drawable_Rain = null;
	  	var Drawable_Respiration = null;
	  	var Drawable_Sleep = null;
	  	var Drawable_Speed = null;
	  	var Drawable_Steps = null;
	  	var Drawable_Sunrise = null;
	  	var Drawable_Sunset = null;
	  	var Drawable_Time = null;
	  	var Drawable_Temperature = null;
	  	var Drawable_Wind = null;

			function getIcon(symbol) {
				if (Icons[symbol] == null) {
					Icons[symbol] = WatchUi.loadResource($.Rez.Drawables[symbol]);
				}

				return Icons[symbol];
			}
		}
	}
}
