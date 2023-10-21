using Toybox.Math;
using Keg.Barometer;
using Keg.Barometer.BarometricTendency;
using Keg.I18n;
using Keg.Pagination;
using Keg.Pixel;
using Keg.Setting;
using Keg.Utilities.Circle;
using Keg.Views;

class Index extends Views.AbstractWidgetView
{
  private var title;

  private var sunIcon = null;
  private var cloudSunIcon = null;
  private var cloudIcon = null;
  private var rainCloudIcon = null;
  private var rainIcon = null;

  public function initialize() {
    Views.AbstractWidgetView.initialize();
  }

  public function onAppLoad() {
    Pagination.setPages(2);
  }

  public function onReady(dc) {
    self.title = I18n.t(:Barometer);

    self.sunIcon = new Rez.Drawables.Sun();
    self.cloudSunIcon = new Rez.Drawables.CloudSun();
    self.cloudIcon = new Rez.Drawables.Cloud();
    self.rainCloudIcon = new Rez.Drawables.RainCloud();
    self.rainIcon = new Rez.Drawables.Rain();
  }

  public function onIterate(dc) {
    var barometer = Barometer.getInfo();

    var trend = BarometricTendency.getInfo().value;

    self.sunIcon.draw(dc);
    self.cloudSunIcon.draw(dc);
    self.cloudIcon.draw(dc);
    self.rainCloudIcon.draw(dc);
    self.rainIcon.draw(dc);

    if (barometer.value != null) {
      var degree = 0;

      if (barometer.value.toFloat() > 104500.0) {
        degree = 180;
      } else if (barometer.value.toFloat() >= 97500.0 && barometer.value.toFloat() <= 104500.0) {
        degree = 180.0 * ((barometer.value.toFloat() - 97500.0)/(104500.0 - 97500.0));
      }

      if (Setting.getValue("UX_MeterHandStyle", 0) == 0) {
        var mx1 = Circle.calculateRadialPoint(self.center, degree, Pixel.scale(141), :x);
        var my1 = Circle.calculateRadialPoint(self.center, degree, Pixel.scale(141), :y) - Pixel.scale(25);
        var mx2 = Circle.calculateRadialPoint(self.center, degree, Pixel.scale(40), :x);
        var my2 = Circle.calculateRadialPoint(self.center, degree, Pixel.scale(40), :y) - Pixel.scale(25);

        var x = center + (Pixel.scale(110) * Math.cos(Math.toRadians(degree)));
        var y = center + (Pixel.scale(110) * Math.sin(Math.toRadians(degree)));

        dc.setColor(0x000000, -1);
        dc.setPenWidth(Pixel.scale(5));
        dc.drawLine(mx1, my1, mx2, my2);
        dc.setColor(0xFFFFFF, -1);
        dc.setPenWidth(Pixel.scale(3));
        dc.drawLine(mx1, my1, mx2, my2);
        dc.fillCircle(
          self.center,
          Pixel.scale(105),
          Pixel.scale(10)
        );
      } else {
        dc.setColor(0xFFFFFF, -1);
        dc.fillPolygon(
          self.generateHandTriangleCoordinates(
            [self.center, Pixel.scale(105)],
            Math.toRadians(degree - 90),
            Pixel.scale(91),
            Pixel.scale(-81),
            Pixel.scale(10)
          )
        );
        dc.fillPolygon(
          self.generateHandArmCoordinates(
            [self.center, Pixel.scale(105)],
            Math.toRadians(degree - 90),
            Pixel.scale(82),
            0,
            Pixel.scale(10)
          )
        );
        dc.setColor(0x000000, -1);
        dc.fillCircle(
          self.center,
          Pixel.scale(105),
          Pixel.scale(16)
        );
        dc.setColor(0xFFFFFF, -1);
        dc.fillCircle(
          self.center,
          Pixel.scale(105),
          Pixel.scale(10)
        );
      }
    }

    if (trend != null) {
      dc.setPenWidth(Pixel.scale(3));
      dc.setColor(0xFFFFFF, -1);
      dc.drawLine(
        Pixel.scale(trend[0]),
        Pixel.scale(trend[1]),
        Pixel.scale(trend[2]),
        Pixel.scale(trend[3])
      );
      dc.drawLine(
        Pixel.scale(trend[4]),
        Pixel.scale(trend[5]),
        Pixel.scale(trend[6]),
        Pixel.scale(trend[7])
      );
      dc.fillPolygon(
        [
          [Pixel.scale(trend[8]), Pixel.scale(trend[9])],
          [Pixel.scale(trend[10]), Pixel.scale(trend[11])],
          [Pixel.scale(trend[12]), Pixel.scale(trend[13])],
        ]
      );
    }

    dc.setColor(0x0055FF, -1);
    dc.drawText(
      self.center,
      Pixel.scale(169),
      11,
      self.title.toUpper(),
      1 | 4
    );


    dc.setColor(0xFFFFFF, -1);
    dc.drawText(
      self.center,
      Pixel.scale(205),
      15,
      barometer.asString(),
      1 | 4
    );
    dc.drawText(
      self.center,
      Pixel.scale(239),
      10,
      barometer.unit,
      1 | 4
    );
  }

  private function generateHandTriangleCoordinates(centerPoint, angle, handLength, tailLength, width) {
    var coords = [
      [-(width / 2), tailLength],
      [width/2 - (width/2), -handLength],
      [width / 2, tailLength]
    ];

    var sides = 3;

    var result = new [sides];
    var cos = Math.cos(angle);
    var sin = Math.sin(angle);

    // Transform the coordinates
    for (var i = 0; i < sides; i++) {
      var x = (coords[i][0] * cos) - (coords[i][1] * sin) + 0.5;
      var y = (coords[i][0] * sin) + (coords[i][1] * cos) + 0.5;

      result[i] = [centerPoint[0] + x, centerPoint[1] + y];
    }

    return result;
  }

  private function generateHandArmCoordinates(centerPoint, angle, handLength, tailLength, width) {
    var coords = [
      [-(width / 2), tailLength],
      [-(width/2), -handLength],
      [width / 2, -handLength],
      [width / 2, tailLength]
    ];

    var sides = 4;

    var result = new [sides];
    var cos = Math.cos(angle);
    var sin = Math.sin(angle);

    // Transform the coordinates
    for (var i = 0; i < sides; i++) {
      var x = (coords[i][0] * cos) - (coords[i][1] * sin) + 0.5;
      var y = (coords[i][0] * sin) + (coords[i][1] * cos) + 0.5;

      result[i] = [centerPoint[0] + x, centerPoint[1] + y];
    }

    return result;
  }

  public function nextView() {
    return new $.History();
  }

  public function previousView() {
    return new $.History();
  }
}
