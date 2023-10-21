using Toybox.Math;
using Keg.Pixel;

module Keg
{
	module Pagination
	{
		var seconds = 0;

		function render(dc, page) {
			if (self.pages == 0) {
				return;
			}

			if (Keg.opened == false) {
				return;
			}

			if (self.seconds <= 0) {
	  		return;
			}

	  	var d = 10;
	  	var h = ((d * self.pages)/2) - 5;

	  	dc.setPenWidth(Pixel.scale(2));
	    dc.setColor(0xFFFFFF, -1);

	  	for (var i = 0; i < self.pages; ++i) {
	  		if ((i + 1) == page) {
	  			dc.fillCircle(
	  				screenCenter + Math.round(Math.cos(Math.toRadians((h - (i * d)))) * -(screenCenter - Pixel.scale(15))),
			      screenCenter + Math.round(Math.sin(Math.toRadians((h - (i * d)))) * -(screenCenter - Pixel.scale(15))),
			      Pixel.scale(6)
			    );
				} else {
					dc.drawCircle(
						screenCenter + Math.round(Math.cos(Math.toRadians((h - (i * d)))) * -(screenCenter - Pixel.scale(15))),
			      screenCenter + Math.round(Math.sin(Math.toRadians((h - (i * d)))) * -(screenCenter - Pixel.scale(15))),
		        Pixel.scale(5)
		      );
				}
	  	}

	  	--self.seconds;
		}
	}
}
