using Toybox.Sensor;

module Keg
{
	module Device
	{
		(:glance)
		function isOnWrist() {
			return Sensor.getInfo().heartRate != null;
		}
	}
}
