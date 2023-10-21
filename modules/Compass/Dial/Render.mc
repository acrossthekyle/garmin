using Keg.Pixel;
using Keg.Setting;
using Keg.Utilities.Circle;

module Keg
{
	module Compass
	{
		module Dial
		{
			var nesw = ["N", "E", "S", "W"];

			function render(dc, degrees) {
				var color = Setting.getValue("Compass_Color", 0xFF0000);

				/* offset by positive 90 so that 0 is at true north */
				var neswOffset = 90 - (degrees == null ? 0.0 : degrees);

			  dc.setPenWidth(Pixel.scale(3));
			  dc.setColor(0x555555, -1);

			  for (var i = 0; i < 4; ++i) {
			    var t = (i * 90) + neswOffset;

			    dc.setColor(self.nesw[i].equals("N") ? color : 0xFFFFFF, -1);
			    dc.drawText(
			      Circle.calculateRadialPoint(screenCenter, t, Pixel.scale(13), :x),
			      Circle.calculateRadialPoint(screenCenter, t, Pixel.scale(13), :y),
			      11,
			      self.nesw[i],
			      1 | 4
			    );

			    dc.setColor(0xFFFFFF, -1);

			    for (var k = 0; k < 13; ++k) {
			      dc.drawLine(
			        Circle.calculateRadialPoint(screenCenter, (t + 15) + (k * 5), Pixel.scale(20), :x),
			        Circle.calculateRadialPoint(screenCenter, (t + 15) + (k * 5), Pixel.scale(20), :y),
			        Circle.calculateRadialPoint(screenCenter, (t + 15) + (k * 5), Pixel.scale(25), :x),
			        Circle.calculateRadialPoint(screenCenter, (t + 15) + (k * 5), Pixel.scale(25), :y)
			      );
			    }

			    dc.drawLine(
			      Circle.calculateRadialPoint(screenCenter, (t + 15), 0, :x),
			      Circle.calculateRadialPoint(screenCenter, (t + 15), 0, :y),
			      Circle.calculateRadialPoint(screenCenter, (t + 15), Pixel.scale(25), :x),
			      Circle.calculateRadialPoint(screenCenter, (t + 15), Pixel.scale(25), :y)
			    );

			    dc.drawLine(
			      Circle.calculateRadialPoint(screenCenter, (t + 45), 0, :x),
			      Circle.calculateRadialPoint(screenCenter, (t + 45), 0, :y),
			      Circle.calculateRadialPoint(screenCenter, (t + 45), Pixel.scale(25), :x),
			      Circle.calculateRadialPoint(screenCenter, (t + 45), Pixel.scale(25), :y)
			    );

			    dc.drawLine(
			      Circle.calculateRadialPoint(screenCenter, (t + 75), 0, :x),
			      Circle.calculateRadialPoint(screenCenter, (t + 75), 0, :y),
			      Circle.calculateRadialPoint(screenCenter, (t + 75), Pixel.scale(25), :x),
			      Circle.calculateRadialPoint(screenCenter, (t + 75), Pixel.scale(25), :y)
			    );

			    if (i == 3) {
			      dc.setColor(color, -1);
			      dc.setPenWidth(Pixel.scale(3));
			      dc.drawLine(
			        screenCenter,
			        0,
			        screenCenter,
			        Pixel.scale(35)
			      );
			      dc.fillPolygon([
			        [screenCenter, Pixel.scale(30)],
			        [Pixel.scale(139), Pixel.scale(42)],
			        [Pixel.scale(121), Pixel.scale(42)]
			      ]);
			    }
			  }
			}
		}
	}
}
