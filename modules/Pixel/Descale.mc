using Toybox.Math;

module Keg
{
	module Pixel
	{
		function descale(pixels) {
		  if (screenWidth <= 260 && pixels == 1) {
		    return 1;
		  }

		  return Math.ceil(260.0 * (pixels/screenWidth));
		}
	}
}
