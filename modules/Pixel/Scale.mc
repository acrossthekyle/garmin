using Toybox.Math;

module Keg
{
	module Pixel
	{
		(:glance)
		function scale(pixels) {
		  if (screenWidth <= 260 && pixels == 1) {
		    return 1;
		  }

		  return Math.floor(screenWidth * (pixels/260.0));
		}
	}
}
