using Toybox.Application.Properties;
using Toybox.Graphics;
using Keg.Setting;

module Keg
{
	module Fonts
	{
		class FontAdjustments
		{
			public var ascent = 0;
			public var descent = 0;
			public var height = 0;

			public function initialize(name, size) {
				if (size == 9 || size == 11) {
					self.ascent = Setting.getValue("Font_" + name + "AscentAdjustment", 0);
				}

				self.descent = Graphics.getFontDescent(size) + Setting.getValue("Font_" + name + "DescentAdjustment", 0);
			  self.height = Graphics.getFontAscent(size) - self.descent;
			}
		}
	}
}
