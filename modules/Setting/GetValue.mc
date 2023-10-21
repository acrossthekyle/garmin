using Toybox.Application.Properties;
using Toybox.Lang;
using Keg.Type;

module Keg
{
	module Setting
	{
		(:glance)
		function getValue(name, fallback) {
			var type = :boolean;

			if (fallback instanceof Lang.Float) {
	      type = :float;
	    } else if (fallback instanceof Lang.Number) {
	      type = :number;
	    } else if (fallback instanceof Lang.String) {
	      type = :string;
	    }

	    var value = fallback;

	    try {
	    	value = Type.enforce(Properties.getValue(name), fallback, type);
	    } catch (ex) {
	    	// do nothing
	    }

			return value;
		}
	}
}
