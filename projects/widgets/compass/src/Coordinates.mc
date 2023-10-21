using Toybox.Math;
using Toybox.Position;
using Keg.Gps;
using Keg.Pixel;
using Keg.Setting;
using Keg.Views;

class Coordinates extends Views.AbstractWidgetView
{
	public var page = 5;

  public function initialize() {
    Views.AbstractWidgetView.initialize();
  }

  public function onIterate(dc) {
    var coordinatesFormat = Setting.getValue("Coordinates_Format", 2);
    var gps = Gps.getInfo();

    for (var i = 0; i < 3; ++i) {
      dc.setColor(self.getGpsAccuracyColor(gps.accuracy, i + 1), -1);
      dc.fillRectangle(
        Pixel.scale(108 + (i * 16)),  /* x */
        Pixel.scale(67 - (i * 12)),   /* y */
        Pixel.scale(12),              /* width */
        Pixel.scale(12 + (i * 12))    /* height */
      );
    }

    if (coordinatesFormat != 3) {
      var latCardinal = (gps.latitude != null && gps.latitude >= 0 ? "N" : "S");
      var latText = self.convertCoordinate(gps.accuracy, gps.latitude, coordinatesFormat);
      var longCardinal = (gps.longitude != null && gps.longitude >= 0 ? "E" : "W");
      var longText = self.convertCoordinate(gps.accuracy, gps.longitude, coordinatesFormat);

      var latWidth = dc.getTextWidthInPixels(latCardinal + latText, 13);
      var longWidth = dc.getTextWidthInPixels(longCardinal + longText, 13);

      var finalWidth = latWidth/2;

      if (longWidth > latWidth) {
        finalWidth = longWidth/2;
      }

      var cardinalOffset = self.center - (finalWidth - Pixel.scale(5));
      var textOffset = self.center + (finalWidth + Pixel.scale(5));

      dc.setColor(0xFFFFFF, -1);
      dc.drawText(
        cardinalOffset,
        Pixel.scale(109),
        13,
        latCardinal,
        2 | 4
      );
      dc.drawText(
        cardinalOffset,
        Pixel.scale(145),
        13,
        longCardinal,
        2 | 4
      );
      dc.drawText(
        textOffset,
        Pixel.scale(109),
        13,
        latText,
        0 | 4
      );
      dc.drawText(
        textOffset,
        Pixel.scale(145),
        13,
        longText,
        0 | 4
      );
    } else {
      if (gps.latitude != null && gps.longitude != null) {
        var mgrs = new Position.Location(
          {
            :latitude   => gps.latitude,
            :longitude  => gps.longitude,
            :format     => :degrees
          }
        ).toGeoString(3).toCharArray();

        var mgrsChars = "";

        for (var i = 0; i < mgrs.size(); ++i) {
          if (mgrs[i].toNumber() == 32) {
            mgrsChars = mgrsChars + "\n";
          } else {
            mgrsChars = mgrsChars + mgrs[i].toString();
          }
        }

        dc.setColor(0xFFFFFF, -1);
        dc.drawText(
          self.center,
          Pixel.scale(150),
          13,
          mgrsChars,
          1 | 4
        );
      }
    }
  }

  private function getGpsAccuracyColor(acc, n) {
    var c = [
      0x555555, /* unavailable: grey, 0 */
      0x0055AA, /* last known: blue, 1 */
      0xFF5500, /* poor: red, 2 */
      0xFFAA00, /* usable: yellow, 3 */
      0x55FF00  /* good: green, 4 */
    ];

    if (acc == null) {
      acc = 0;
    }

    if (acc == 0 || acc == 1) {
      return c[acc];
    }

    if (n == 1) {
      return c[acc];
    }

    if (n == 2) {
      if (acc > 2) {
        return c[acc];
      }

      return c[0];
    }

    if (n == 3) {
      if (acc > 3) {
        return c[4];
      }

      return c[0];
    }
  }

  private function convertCoordinate(acc, c, format) {
    if (acc == null || c == null) {
      c = 0.000000;
    }

    /* DEG */
    if (format == 0) {
      return c.format("%.4f");
    }

    var abs = c.abs();
    var d = Math.floor(abs);
    var mnt = (abs - d).toFloat() * 60;
    var m = Math.floor(mnt);

    /* DM */
    if (format == 1) {
      return d.format("%d") + "° " + m.format("%.3f") + "'";
    }

    /* DMS */
    if (format == 2) {
      var s = (mnt - m).toFloat() * 60;

      return d.format("%d") + "° " + m.format("%d") + "' " + s.format("%d") + "''";
    }

    return c.format("%.4f");
  }

  public function nextView() {
    return new $.Index();
  }

  public function previousView() {
    return new $.Deviation();
  }
}
