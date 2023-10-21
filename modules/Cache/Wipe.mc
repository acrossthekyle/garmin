using Toybox.Application.Storage;

module Keg
{
	module Cache
	{
		function wipe(keys) {
		  for (var i = 0; i < keys.size(); ++i) {
		    Storage.setValue(keys[i] + expiresOnSuffix, null);
		    Storage.setValue(keys[i], null);
		  }
		}
	}
}
