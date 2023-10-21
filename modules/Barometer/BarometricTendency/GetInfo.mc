using Toybox.Math;
using Toybox.SensorHistory;
using Toybox.Time;
using Toybox.Lang;
using Keg.Cache;

module Keg
{
	module Barometer
	{
		module BarometricTendency
		{
			var instance = null;

			class BarometricTendencyInfo
			{
				public var value = new [14]b;
			}

			function getInfo() {
				var data = Cache.fetch("Barometer");

				if (data == null) {
					var iterator = SensorHistory.getPressureHistory({
				    :period => screenWidth,
				    :order  => 1
				  });

				  if (iterator != null) {
				    var next = iterator.next();
				    var size = 0;

				    while (next != null) {
				      if (next has :data && next.data != null) {
				        size += 1;
				      }

				      next = iterator.next();
				    }

				    if (size > 0) {
				      iterator = SensorHistory.getPressureHistory({
				        :period => screenWidth,
				        :order  => 1
				      });

				      var time = iterator.getOldestSampleTime();

				      if (time != null) {
				        time = (Math.ceil((Time.now().value() - time.value())/60.0/60.0))/2.0;

				        var h = Math.floor(size/2.0).toNumber();

				        var old = null;
				        var mid = null;
				        var rec = null; // newest

				        next = iterator.next();

				        while (next != null) {
				          if (next has :data && next.data != null) {
				            var pa = next.data.toFloat();

				            if (old == null) {
				              old = pa;
				            }

				            if (size <= h && mid == null) {
				              mid = pa;
				            }

				            rec = pa;

				            size -= 1;
				          }

				          next = iterator.next();
				        }

				        if (old != null && mid != null && rec != null) {
				          var barometer = new [14]b;

				          old = old/100.0; // convert to mb
				          mid = mid/100.0; // convert to mb
				          rec = rec/100.0; // convert to mb

				          var diff = mid - old;

				          if (diff.abs() < 1) {
				            barometer[0] = 118;
				            barometer[1] = 130;
				            barometer[2] = 130;
				            barometer[3] = 130;
				          } else {
				            if (diff >= 0) {
				              barometer[0] = 118;
				              barometer[1] = 142;
				              barometer[2] = 130;
				              barometer[3] = 130;
				            } else {
				              barometer[0] = 118;
				              barometer[1] = 118;
				              barometer[2] = 130;
				              barometer[3] = 130;
				            }
				          }

				          diff = rec - mid;

				          if (diff.abs() < 1) {
				            barometer[4] = 130;
				            barometer[5] = 130;
				            barometer[6] = 142;
				            barometer[7] = 130;

				            barometer[8] = 142;
				            barometer[9] = 123;
				            barometer[10] = 150;
				            barometer[11] = 130;
				            barometer[12] = 142;
				            barometer[13] = 138;
				          } else {
				            if (diff >= 0) {
				              barometer[4] = 130;
				              barometer[5] = 130;
				              barometer[6] = 142;
				              barometer[7] = 118;

				              barometer[8] = 134;
				              barometer[9] = 116;
				              barometer[10] = 145;
				              barometer[11] = 116;
				              barometer[12] = 145;
				              barometer[13] = 127;
				            } else {
				              barometer[4] = 130;
				              barometer[5] = 130;
				              barometer[6] = 142;
				              barometer[7] = 142;

				              barometer[8] = 144;
				              barometer[9] = 134;
				              barometer[10] = 144;
				              barometer[11] = 144;
				              barometer[12] = 134;
				              barometer[13] = 144;
				            }
				          }

				          data = barometer;
				        }
				      }
				    }
				  }

					Cache.save("Barometer", 15, :minutes, data);
				}

				if (BarometricTendency.instance == null) {
	    		BarometricTendency.instance = new BarometricTendency.BarometricTendencyInfo();
	    	}

	    	BarometricTendency.instance.value = data;

				return BarometricTendency.instance;
			}
		}
	}
}
