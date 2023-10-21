using Toybox.System;

module Keg
{
	module Watchface
	{
		module Data
		{
			var isMeridean = !System.getDeviceSettings().is24Hour;
			var isAltitudeMetric = System.getDeviceSettings().elevationUnits == 0;
			var isDistanceMetric = System.getDeviceSettings().distanceUnits == 0;
			var isTemperatureMetric = System.getDeviceSettings().temperatureUnits == 0;

			class DataInfo
			{
				public var value = null;
				public var units = null;
				public var prefix = null;

				public function getIcon() {
					return null;
				}

				public function getLabel() {
					return null;
				}

				public function getUnitsLabel() {
					return null;
				}

				public function asString() {
					return self.value.format("%d");
				}
			}
		}
	}
}
