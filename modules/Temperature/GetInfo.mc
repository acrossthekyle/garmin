using Toybox.Math;
using Toybox.Sensor;
using Toybox.SensorHistory;
using Toybox.System;
using Keg.Device;
using Keg.Setting;

module Keg
{
	module Temperature
	{
		var instance = null;

		(:glance)
		class TemperatureCoreInfo
		{
			public var value = null;

			public function asString() {
				return Temperature.format(self.value);
			}
		}

		(:glance)
		class TemperatureInfo
		{
			public var core = null;
			public var value = null;
			public var unit = "C";

			public function asString() {
				return Temperature.format(self.value);
			}
		}

		(:glance)
		function getInfo() {
			var isMetric = System.getDeviceSettings().temperatureUnits == 0;
			var adjustment = Setting.getValue("Temperature_Adjustment", 3.0);

			var sensor = Sensor.getInfo();
			var celsius = null;

			if (sensor.temperature == null) {
				var i = SensorHistory.getTemperatureHistory({
		      :period => 1,
		      :order  => null // newest first
		    });

		    if (i != null) {
		      var n = i.next();

		      if (n != null) {
		        if (n.data != null) {
		          celsius = n.data.toFloat();
		        }
		      }
		    }
			} else {
				celsius = sensor.temperature.toFloat();
			}

			var core = null;

			if (Device.isOnWrist()) {
				core = Math.ceil((0.64 * 37.0) + (0.36 * celsius)).toFloat();
				core = (isMetric ? core : ((core * 9/5) + 32)) + adjustment;
				core = isMetric ? core : ((core - 32) * 5/9);
		  }

			if (Temperature.instance == null) {
	    	Temperature.instance = new Temperature.TemperatureInfo();
	    }

	    if (Temperature.instance.core == null) {
	    	Temperature.instance.core = new Temperature.TemperatureCoreInfo();
	    }

			Temperature.instance.value = celsius;
	    Temperature.instance.unit = isMetric ? "C" : "F";
	    Temperature.instance.core.value = core;

	    return Temperature.instance;
		}
	}
}
