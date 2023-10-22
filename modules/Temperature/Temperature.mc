using Toybox.Math;
using Toybox.System;
using Keg.Device;
using Keg.Setting;

module Keg
{
	module Temperature
	{
		(:glance)
		function shouldBeConvertedToCore() {
			return Device.isOnWrist() && Setting.getValue("Temperature_CoreEnabled", true) == true;
		}

		(:glance)
		function getAdjustment() {
			return Setting.getValue("Temperature_Adjustment", 3.0);
		}

		(:glance)
		function toCore(value) {
			var isMetric = System.getDeviceSettings().temperatureUnits == 0;

			var core = Math.ceil((0.64 * 37.0) + (0.36 * value)).toFloat();
			core = (isMetric ? core : ((core * 9/5) + 32)) + self.getAdjustment();
			core = isMetric ? core : ((core - 32) * 5/9);

			return core;
		}

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
