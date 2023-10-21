using Toybox.WatchUi;

module Keg
{
	module I18n
	{
		(:glance)
		function t(id) {
			try {
				return WatchUi.loadResource($.Rez.Strings[id]);
			} catch (ex) {
				return "";
			}
		}
	}
}
