using Toybox.Lang;
using Toybox.SensorHistory;

module Keg
{
	module History
	{
		(:glance)
		function getHistory(type, period) {
			return (new Lang.Method(SensorHistory, type)).invoke({
		    :period => period, // usually screen width
		    :order  => null // always newest first
		  });
		}
	}
}
