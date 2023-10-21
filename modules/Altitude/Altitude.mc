using Toybox.Math;
using Toybox.System;
using Keg.Setting;

module Keg
{
	module Altitude
	{
		var activityInfo = null;

		(:glance)
		function format(value) {
			if (value == null) {
		    return "--";
		  }

		  var precision = ["%d", "%.1f", "%.2f"][Setting.getValue("Altitude_Precision", 0)];

		  if (System.getDeviceSettings().elevationUnits == 0) {
		    return value.toFloat().format(precision);
		  }

		  return Math.ceil(value.toFloat() * 3.28084).toFloat().format(precision);
		}
	}
}
