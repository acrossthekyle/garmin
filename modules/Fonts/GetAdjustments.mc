module Keg
{
	module Fonts
	{
		var extraTiny = null;
		var tiny = null;
		var small = null;
		var medium = null;
		var large = null;
		var numberSmall = null;
		var numberMedium = null;
		var numberHot = null;
		var numberThai = null;

		function getAdjustments(font) {
			if (font == :extraTiny || font == 9) {
				try {
					if (self.extraTiny == null) {
						self.extraTiny = new Fonts.FontAdjustments("ExtraTiny", 9);
					}
				} catch (e) {
					// do nothing
				}

				return self.extraTiny;
			}

			if (font == :tiny || font == 10) {
				try {
					if (self.tiny == null) {
						self.tiny = new Fonts.FontAdjustments("Tiny", 10);
					}
				} catch (e) {
					// do nothing
				}

				return self.tiny;
			}

			if (font == :small || font == 11) {
				try {
					if (self.small == null) {
						self.small = new Fonts.FontAdjustments("Small", 11);
					}
				} catch (e) {
					// do nothing
				}

				return self.small;
			}

			if (font == :medium || font == 12) {
				try {
					if (self.medium == null) {
						self.medium = new Fonts.FontAdjustments("Medium", 12);
					}
				} catch (e) {
					// do nothing
				}

				return self.medium;
			}

			if (font == :large || font == 13) {
				try {
					if (self.large == null) {
						self.large = new Fonts.FontAdjustments("Large", 13);
					}
				} catch (e) {
					// do nothing
				}

				return self.large;
			}

			if (font == :numberSmall || font == 14) {
				try {
					if (self.numberSmall == null) {
						self.numberSmall = new Fonts.FontAdjustments("NumberSmall", 14);
					}
				} catch (e) {
					// do nothing
				}

				return self.numberSmall;
			}

			if (font == :numberMedium || font == 15) {
				try {
					if (self.numberMedium == null) {
						self.numberMedium = new Fonts.FontAdjustments("NumberMedium", 15);
					}
				} catch (e) {
					// do nothing
				}

				return self.numberMedium;
			}

			if (font == :numberHot || font == 16) {
				try {
					if (self.numberHot == null) {
						self.numberHot = new Fonts.FontAdjustments("NumberHot", 16);
					}
				} catch (e) {
					// do nothing
				}

				return self.numberHot;
			}

			try {
				if (self.numberThai == null) {
					self.numberThai = new Fonts.FontAdjustments("NumberThaiHot", 17);
				}
			} catch (e) {
				// do nothing
			}

			return self.numberThai;
		}
	}
}
