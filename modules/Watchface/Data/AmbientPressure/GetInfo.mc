using Toybox.Activity;
using Keg.I18n;
using Keg.Watchface.Icons;

module Keg
{
	module Watchface
	{
		module Data
		{
			module AmbientPressure
			{
				var instance = null;

				class AmbientPressureInfo extends Data.DataInfo
				{
					public var icon = :Drawable_Pressure;
					public var label = :Complications_Label_Barometer;

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
					if (AmbientPressure.instance == null) {
						AmbientPressure.instance = new AmbientPressure.AmbientPressureInfo();
					}

					var index = options.get(:pressureIndex);

					var info = Activity.getActivityInfo();

					AmbientPressure.instance.divisor = [100.0, 3386.0, 133.0, 100.0][index];
					AmbientPressure.instance.precision = ["%d", "%.2f", "%d", "%d"][index];
					AmbientPressure.instance.units = ["hPa", "inHg", "mmHg", "mBar"][index];

				  if (info != null) {
				  	if (info.ambientPressure != null) {
				  		AmbientPressure.instance.value = info.ambientPressure;
				  	}
					}

					return AmbientPressure.instance;
				}
			}
		}
	}
}
