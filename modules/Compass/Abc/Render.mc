using Keg.Altitude;
using Keg.I18n;
using Keg.Pixel;
using Keg.Setting;
using Keg.Barometer.BarometricTendency;

module Keg
{
	module Compass
	{
		module Abc
		{
			function render(dc, compass) {
				var altitude = Altitude.getInfo();
		    var barometer = BarometricTendency.getInfo().value;

		    var elevation = altitude.asString();

				dc.setColor(0xFFFFFF, -1);
			  dc.drawText(
			    screenCenter,
			    Pixel.scale(69),
			    14,
			    compass,
			    1 | 4
			  );
			  dc.drawText(
			    screenCenter + dc.getTextWidthInPixels(compass, 14)/2 + 7,
			    Pixel.scale(62),
			    13,
			    "°",
			    1 | 4
			  );

			  dc.setColor(0x555555, -1);
			  dc.setPenWidth(Pixel.scale(3));
			  dc.drawLine(
			    Pixel.scale(60),
			    Pixel.scale(93),
			    Pixel.scale(200),
			    Pixel.scale(93)
			  );

			  dc.setColor(0xAAAAAA, -1);
			  dc.drawText(
			    screenCenter,
			    Pixel.scale(107),
			    9,
			    I18n.t(:Altitude).toUpper(),
			    1 | 4
			  );
			  dc.setColor(0xFFFFFF, -1);
			  dc.drawText(
			    screenCenter,
			    Pixel.scale(139),
			    15,
			    elevation,
			    1 | 4
			  );

			  if (Setting.getValue("Altitude_UnitsEnabled", true)) {
			    dc.drawText(
			      screenCenter + dc.getTextWidthInPixels(elevation, 15)/2 + Pixel.scale(10),
			      Pixel.scale(139),
			      10,
			      altitude.unit,
			      1 | 4
			    );
			  }

			  dc.setColor(0x555555, -1);
			  dc.setPenWidth(Pixel.scale(3));
			  dc.drawLine(
			    Pixel.scale(60),
			    Pixel.scale(165),
			    Pixel.scale(200),
			    Pixel.scale(165)
			  );

			  dc.setColor(0xAAAAAA, -1);
			  dc.drawText(
			    screenCenter,
			    Pixel.scale(178),
			    9,
			    I18n.t(:Barometer).toUpper(),
			    1 | 4
			  );

			  if (barometer != null) {
			    var to = Pixel.scale(76);

			    dc.setPenWidth(Pixel.scale(3));
			    dc.setColor(0xFFFFFF, -1);
			    dc.drawLine(
			      Pixel.scale(barometer[0]),
			      Pixel.scale(barometer[1]) + to,
			      Pixel.scale(barometer[2]),
			      Pixel.scale(barometer[3]) + to
			    );
			    dc.drawLine(
			      Pixel.scale(barometer[4]),
			      Pixel.scale(barometer[5]) + to,
			      Pixel.scale(barometer[6]),
			      Pixel.scale(barometer[7]) + to
			    );
			    dc.fillPolygon(
			      [
			        [Pixel.scale(barometer[8]), Pixel.scale(barometer[9]) + to],
			        [Pixel.scale(barometer[10]), Pixel.scale(barometer[11]) + to],
			        [Pixel.scale(barometer[12]), Pixel.scale(barometer[13]) + to],
			      ]
			    );
			  }
			}
		}
	}
}
