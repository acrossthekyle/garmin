using Toybox.Lang;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Keg.I18n;
using Keg.Watchface.Icons;

module Keg
{
	module Watchface
	{
		module Data
		{
			module Date
			{
				var instance = null;
				var months = [
		      I18n.t(:Months_January),
		      I18n.t(:Months_February),
		      I18n.t(:Months_March),
		      I18n.t(:Months_April),
		      I18n.t(:Months_May),
		      I18n.t(:Months_June),
		      I18n.t(:Months_July),
		      I18n.t(:Months_August),
		      I18n.t(:Months_September),
		      I18n.t(:Months_October),
		      I18n.t(:Months_November),
		      I18n.t(:Months_December)
		    ];

				class DateInfo extends Data.DataInfo
				{
					public var label = null;
					public var unitsLabel = null;
					public var prefix = null;

					public function getIcon() {
						return Icons.getIcon(:Drawable_Date);
					}

					public function getLabel() {
						return self.label;
					}

					public function getUnitsLabel() {
						return self.unitsLabel;
					}

					public function asString() {
						return self.value;
					}
				}

				function getInfo(options) {
					if (Date.instance == null) {
						Date.instance = new Date.DateInfo();
					}

					var index = options.get(:dateIndex);

					if (index == :custom) {
						var grego = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
  					var gregoShort = Gregorian.info(Time.now(), Time.FORMAT_SHORT);

  					Date.instance.value = grego.day;
  					Date.instance.label = grego.day_of_week;
  					Date.instance.unitsLabel = Date.months[gregoShort.month - 1];

  					return Date.instance;
					}

				  var grego = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);

					var amount = null;
					var prefix = null;
					var units = null;

				  if (index == 0) {
				  	prefix = grego.day_of_week.toUpper();
				  	amount = grego.day;
				  } else if (index == 1) {
				  	prefix = grego.month.toUpper();
				  	amount = grego.day;
				  } else if (index == 2) {
				  	prefix = grego.month.toUpper();
				  	amount = grego.day;
				  	units = Gregorian.info(Time.now(), Time.FORMAT_SHORT).year;
				  } else if (index == 3) {
				  	prefix = grego.day;
				  	amount = grego.month;
				  	units = Gregorian.info(Time.now(), Time.FORMAT_SHORT).year;
				  }

				  Date.instance.prefix = prefix;
				  Date.instance.value = amount;
				  Date.instance.units = units;

					return Date.instance;
				}
			}
		}
	}
}
