using Toybox.Activity;
using Toybox.Math;
using Toybox.SensorHistory;
using Toybox.Time;
using Keg.Setting;

module Keg
{
	module Barometer
	{
		(:glance)
		function getIndex() {
			return Setting.getValue("Barometer_UnitOfMeasurement", 0);
		}

		(:glance)
		function format(value) {
			if (value == null) {
		    return "--";
		  }

		  var index = self.getIndex();
			var divisor = [100, 3386, 133, 100][index];
			var precision = index == 1 ? "%.3f" : "%.1f";

		  return (value/divisor).format(precision);
		}
	}
}
