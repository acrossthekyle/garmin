using Toybox.Activity;
using Keg.I18n;
using Keg.Watchface.Icons;

module Keg
{
	module Watchface
	{
		module Data
		{
			module SeaLevelPressure
			{
				var instance = null;

				class SeaLevelPressureInfo extends Data.DataInfo
				{
					public var divisor = 0;
					public var precision = 0;

					public function getIcon() {
						return Icons.getIcon(:Drawable_Pressure);
					}

					public function getLabel() {
						return I18n.t(:Complications_Label_Barometer);
					}

					public function asString() {
						return (self.value/self.divisor).format(self.precision);
					}
				}

				function getInfo(options) {
					if (SeaLevelPressure.instance == null) {
						SeaLevelPressure.instance = new SeaLevelPressure.SeaLevelPressureInfo();
					}

					var index = options.get(:pressureIndex);

					var info = Activity.getActivityInfo();

					SeaLevelPressure.instance.divisor = [100.0, 3386.0, 133.0, 100.0][index];
					SeaLevelPressure.instance.precision = ["%d", "%.2f", "%d", "%d"][index];
					SeaLevelPressure.instance.units = ["hPa", "inHg", "mmHg", "mBar"][index];

				  if (info != null) {
				  	if (info has :meanSeaLevelPressure) {
				  		if (info.meanSeaLevelPressure != null) {
				  			SeaLevelPressure.instance.value = info.meanSeaLevelPressure;
				    	}
				  	}
				  }

				  return SeaLevelPressure.instance;
				}
			}
		}
	}
}
