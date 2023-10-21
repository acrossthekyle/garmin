using Toybox.System;
using Keg.Setting;

module Keg
{
	module Temperature
	{
		(:glance)
		function format(value) {
			if (value == null) {
		    return "--";
		  }

		  var isMetric = System.getDeviceSettings().temperatureUnits == 0;

		  return (
		    isMetric ? value.toFloat() : ((value * 9/5) + 32)
		  ).toFloat().format("%.1f");
		}
	}
}
