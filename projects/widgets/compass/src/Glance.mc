using Keg.Altitude;
using Keg.Compass;
using Keg.I18n;
using Keg.Pixel;
using Keg.Setting;
using Keg.Views;

(:glance)
class Glance extends Views.AbstractGlanceView
{
  private var compassDialGap = 0;
  private var compassDialPixelsPerDegree = 0;
  private var compassDialSpan = 0;
  private var compassDialLetters = ["N", null, "E", null, "S", null, "W", null, "N", null, "E", null, "S", null, "W", null, "N"];
  private var compassDialLetterWidth = 0;
  private var singlePixel = 1;

  public function initialize() {
    Views.AbstractGlanceView.initialize();
  }

  public function onReady(dc) {
    self.title = I18n.t(:Compass);

    self.compassDialGap = self.width / 3.25;
    self.compassDialPixelsPerDegree = 8 * self.compassDialGap / 360.0;
    self.compassDialSpan = 8 * self.compassDialGap;
    self.compassDialLetterWidth = dc.getTextWidthInPixels("W", 18) + Pixel.scale(10);

    self.singlePixel = Pixel.scale(1);
  }

  public function onIterate(dc) {
    var altitude = Altitude.getInfo();
    var altitudeUnitsEnabled = Setting.getValue("Altitude_UnitsEnabled", true);

    var compass = Compass.getInfo();

    self.sensor = compass.asString() + "°";
    self.sensorUnits = compass.nesw();

    // Complication
    var elevation = altitude.asString();
    var elevationUnits = altitude.unit.toUpper();
    var sensorUnitsLength = self.sensorUnits == null ? 0 : self.sensorUnits.length();

    if (elevation.length() > 4 && sensorUnitsLength > 2) {
      elevationUnits = "";
    }

    dc.setColor(0xFFFFFF, -1);
    dc.drawText(
      altitudeUnitsEnabled
        ? (
            self.width - dc.getTextWidthInPixels(elevationUnits, 18) - Pixel.scale(5)
          )
        : self.width,
      self.height - self.numericFontAscent - Pixel.scale(2),
      19,
      elevation,
      0
    );

    if (altitudeUnitsEnabled) {
      dc.drawText(
        self.width,
        self.height - self.alphaFontAscent - Pixel.scale(2),
        18,
        elevationUnits,
        0
      );
    }

    // Meter
    var start = 0 - (
      (compass.degrees <= 179 ? compass.degrees + 360 : compass.degrees) * self.compassDialPixelsPerDegree
    ) + (self.width / 2);

    dc.setPenWidth(self.singlePixel);
    dc.drawLine(start, self.plotY, self.compassDialSpan, self.plotY);

    for (var i = 0; i < 17; ++i) {
      if (self.compassDialLetters[i] == null) {
        dc.setColor(0x000000, -1);
        dc.fillRectangle(
          start - Pixel.scale(5),
          self.plotY - Pixel.scale(1),
          Pixel.scale(11),
          Pixel.scale(3)
        );

        dc.setColor(0xFFFFFF, -1);
        dc.fillRectangle(
          start - Pixel.scale(1),
          self.plotY - Pixel.scale(6),
          Pixel.scale(4),
          Pixel.scale(13)
        );

        dc.setPenWidth(self.singlePixel);

        var tickStart = 13;

        for (var j = 0; j < 6; ++j) {
          if (j == 3) {
            tickStart = 13;
          }

          dc.drawLine(
            start + (j < 3 ? -(Pixel.scale(tickStart)) : Pixel.scale(tickStart)),
            self.plotY - Pixel.scale((j == 1 || j == 4 ? 4 : 2)),
            start + (j < 3 ? -(Pixel.scale(tickStart)) : Pixel.scale(tickStart)),
            self.plotY + Pixel.scale((j == 1 || j == 4 ? 4 : 2))
          );

          tickStart += 10;
        }
      } else {
        dc.setColor(0x000000, -1);
        dc.fillRectangle(
          start - (self.compassDialLetterWidth/2),
          self.plotY - Pixel.scale(1),
          self.compassDialLetterWidth,
          Pixel.scale(3)
        );

        dc.setColor(0xFFFFFF, -1);
        dc.setPenWidth(Pixel.scale(2));

        for (var k = 0; k < 2; ++k) {
          dc.drawLine(
            start + (k == 0 ? -(self.compassDialLetterWidth/2) : (self.compassDialLetterWidth/2)),
            self.plotY - Pixel.scale(2),
            start + (k == 0 ? -(self.compassDialLetterWidth/2) : (self.compassDialLetterWidth/2)),
            self.plotY + Pixel.scale(2)
          );
        }

        dc.setColor(
          self.compassDialLetters[i].equals("N") ? Setting.getValue("Compass_Color", 0xFF0000) : 0xFFFFFF,
          -1
        );
        dc.drawText(
          start,
          self.plotY,
          18,
          self.compassDialLetters[i],
          1 | 4
        );
      }

      start += self.compassDialGap;
    }
  }

  public function getTimerInterval() {
    return [100, 250, 500, 1000][Setting.getValue("Compass_RefreshRate", 3)];
  }
}
