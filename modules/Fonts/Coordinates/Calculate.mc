using Keg.Pixel;

module Keg
{
	module Fonts
	{
		module Coordinates
		{
			var instance = null;

			class FontCoordinates
			{
				public var actual = 0;
	      public var top = 0;
	      public var middle = 0;
	      public var bottom = 0;
			}

			function calculate(alignment, coordinate, adjustments) {
				if (Coordinates.instance == null) {
					Coordinates.instance = new Coordinates.FontCoordinates();
				}

				Coordinates.instance.actual = Pixel.descale((Pixel.scale(coordinate)));

			  if (alignment == :top) {
			  	Coordinates.instance.top = Pixel.descale((Pixel.scale(coordinate) - adjustments.descent));
			  	Coordinates.instance.middle = Pixel.descale((Pixel.scale(coordinate) + (adjustments.height/2)));
			  	Coordinates.instance.bottom = Pixel.descale((Pixel.scale(coordinate) + adjustments.height));
			  } else if (alignment == :middle) {
			  	Coordinates.instance.top = Pixel.descale((Pixel.scale(coordinate) - (adjustments.height/2)));
			  	Coordinates.instance.middle = Pixel.descale((Pixel.scale(coordinate) - adjustments.descent - (adjustments.height/2)));
			  	Coordinates.instance.bottom = Pixel.descale((Pixel.scale(coordinate) + (adjustments.height/2)));
			  } else {
			  	Coordinates.instance.top = Pixel.descale((Pixel.scale(coordinate) - adjustments.height));
			  	Coordinates.instance.middle = Pixel.descale((Pixel.scale(coordinate) - (adjustments.height/2)));
			  	Coordinates.instance.bottom = Pixel.descale((Pixel.scale(coordinate) - adjustments.descent - adjustments.height));
			  }

			  return Coordinates.instance;
			}
		}
	}
}
