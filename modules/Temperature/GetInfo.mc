using Toybox.Sensor;
using Toybox.SensorHistory;
using Toybox.System;

module Keg
{
	module Temperature
	{
		var instance = null;

		(:glance)
		class TemperatureInfo
		{
			public var isCore = false;
			public var value = null;
			public var unit = "C";

			public function asString() {
				return Temperature.format(self.value);
			}
		}

		(:glance)
		function getInfo() {
			var isMetric = System.getDeviceSettings().temperatureUnits == 0;

			var sensor = Sensor.getInfo();
			var skin = null;

			if (sensor.temperature == null) {
				var i = SensorHistory.getTemperatureHistory({
		      :period => 1,
		      :order  => null // newest first
		    });

		    if (i != null) {
		      var n = i.next();

		      if (n != null) {
		        if (n.data != null) {
		          skin = n.data.toFloat();
		        }
		      }
		    }
			} else {
				skin = sensor.temperature.toFloat();
			}

			var core = null;

			if (Temperature.shouldBeConvertedToCore()) {
				core = Temperature.toCore(skin);
		  }

			if (Temperature.instance == null) {
	    	Temperature.instance = new Temperature.TemperatureInfo();
	    }

	    Temperature.instance.isCore = core != null;
			Temperature.instance.value = core != null ? core : skin;
	    Temperature.instance.unit = isMetric ? "C" : "F";

	    return Temperature.instance;
		}
	}
}
