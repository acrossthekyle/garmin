using Toybox.Activity;
using Toybox.Math;
using Toybox.SensorHistory;
using Toybox.Time;

module Keg
{
	module Barometer
	{
		var instance = null;

		(:glance)
		class BarometerAmbientInfo
		{
			var unit = "";

			function asString() {
				return Barometer.format(Activity.getActivityInfo().ambientPressure);
			}
		}

		(:glance)
		class BarometerInfo
		{
			var ambient = null;
			var value = 0;
			var unit = "";

			function asString() {
				return Barometer.format(self.value);
			}
		}

		(:glance)
		function getInfo() {
			var value = null;

			var i = SensorHistory.getPressureHistory({
		    :period => 1,
		    :order  => null // newest first
		  });

		  if (i != null) {
		    var n = i.next();

		    if (n != null) {
		      if (n.data != null) {
		        value = n.data.toFloat();
		      }
		    }
		  }

		  if (Barometer.instance == null) {
	    	Barometer.instance = new Barometer.BarometerInfo();
	    }

	    var uom = ["hPa", "inHg", "mmHg", "mBar"][Barometer.getIndex()];

	    Barometer.instance.value = value;
	    Barometer.instance.unit = uom;
	    Barometer.instance.ambient = new Barometer.BarometerAmbientInfo();
	    Barometer.instance.ambient.unit = uom;

	    return Barometer.instance;
		}
	}
}
