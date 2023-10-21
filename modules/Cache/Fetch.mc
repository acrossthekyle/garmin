using Toybox.Application.Storage;
using Toybox.Time;

module Keg
{
	module Cache
	{
		function fetch(id) {
		  var expiresOn = Storage.getValue(id + expiresOnSuffix);
		  var data = Storage.getValue(id);

		  var now = Time.now().value();

		  var expired = expiresOn == null ? true : now >= expiresOn;

		  if (data == null) {
		    expired = true;
		  }

		  if (expired) {
		    return null;
		  }

		  return data;
		}
	}
}
