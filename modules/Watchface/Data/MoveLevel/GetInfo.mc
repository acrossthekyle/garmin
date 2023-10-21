using Toybox.ActivityMonitor;
using Keg.I18n;
using Keg.Watchface.Icons;

module Keg
{
	module Watchface
	{
		module Data
		{
			module MoveLevel
			{
				var instance = null;

				class MoveLevelInfo extends Data.DataInfo
				{
					public var units = "/5";

					public function getIcon() {
						return Icons.getIcon(:Drawable_Activity);
					}

					public function getLabel() {
						return I18n.t(:Complications_Label_MoveLevel);
					}
				}

				function getInfo(options) {
					if (MoveLevel.instance == null) {
						MoveLevel.instance = new MoveLevel.MoveLevelInfo();
					}

					var info = ActivityMonitor.getInfo();

					var amount = 0;

					if (info != null) {
						if (info.moveBarLevel != null) {
							amount = info.moveBarLevel;
						}
					}

					MoveLevel.instance.value = amount;

					return MoveLevel.instance;
				}
			}
		}
	}
}
