module Keg
{
	module Heart
	{
		(:glance)
		function format(value) {
		  if (value == null) {
		    return "--";
		  }

		  return value.format("%d");
		}
	}
}
