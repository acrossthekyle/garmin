using Toybox.Lang;

module Keg
{
	module Type
	{
		(:glance)
		function enforce(value, fallback, type) {
		  if (value != null) {
		    if (type == :boolean) {
		      return value == true;
		    }

		    if (type == :float && !(value instanceof Lang.Float)) {
		      return value.toFloat();
		    }

		    if (type == :number && !(value instanceof Lang.Number)) {
		      return value.toNumber();
		    }

		    if (type == :string && !(value instanceof Lang.String)) {
		      return value.toString();
		    }

		    return value;
		  }

		  return fallback;
		}
	}
}
