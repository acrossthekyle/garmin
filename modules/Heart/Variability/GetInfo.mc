using Toybox.Math;

module Keg
{
	module Heart
	{
		module Variability
		{
			var data = null;
			var instance = null;

			class VariabilityInfo
			{
				public var value = null;

				public function asString() {
				  return Heart.format(self.value);
				}
			}

			function getInfo() {
				var hrv = null;
				var ints = [];

				if (Variability.data != null) {
					if (Variability.data has :heartRateData && Variability.data.heartRateData != null) {
			      ints = Variability.data.heartRateData.heartBeatIntervals;
			    }
				}

		    if (ints.size() > 0) {
		      var c = ints.size() - 1;

		      if (c > 0) {
		        var sum = 0.0;

		        for (var i = 0; i < c; ++i) {
		          var next = i + 1;

		          if (next <= c) {
		            sum += Math.pow(
		              (
		              	ints[i]
		              	-
		              	ints[next]
		              ),
		              2
		            );
		          }
		        }

		        if (sum > 0) {
		          hrv = Math.sqrt(
		          	sum/c
		          );
		        }
		      }
		    }

		    if (Variability.instance == null) {
		    	Variability.instance = new Variability.VariabilityInfo();
		    }

		    Variability.instance.value = hrv;

		    return Variability.instance;
			}
		}
	}
}
