using Keg.Pixel;

module Keg
{
	module Fonts
	{
		function snap(alignment, coordinate, adjustments) {
			if (alignment == :top) {
		    return Pixel.scale(coordinate) - adjustments.descent;
		  }

		  if (alignment == :middle) {
		    return Pixel.scale(coordinate) - adjustments.descent - (adjustments.height/2);
		  }

		  return Pixel.scale(coordinate) - adjustments.descent - adjustments.height;
		}
	}
}
