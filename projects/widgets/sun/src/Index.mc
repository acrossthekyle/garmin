using Toybox.Graphics;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Keg.Clock;
using Keg.Gps;
using Keg.I18n;
using Keg.Moon;
using Keg.Pagination;
using Keg.Pixel;
using Keg.Setting;
using Keg.Sun;
using Keg.Sun.Twilight;
using Keg.Utilities.Circle;
using Keg.Views;

class Index extends Views.AbstractWidgetView
{
  public var onSelectSelf;

  private var i18nLocationAcquiring = "";
  private var i18nLocationInvalid = "";
  private var i18nToday = "";
  private var i18nSunrise = "";
  private var i18nSunset = "";
  private var i18nNextEventIn = "";
  private var i18nTwilight = "";

  private var location = null;

  private var paginating = false;

  private var moment = Time.now();
  private var momentAsDateString = "";

  private var arcOffset = 105;

  private var color_twilight = 0xAA5500; // orange
  private var color_daylight = 0xFFAA00; // yellow
  private var color_skylight = 0x0055AA; // blue

  private var useLargerFont = false;

  public function initialize() {
    Views.AbstractWidgetView.initialize();
  }

  public function onAppLoad() {
    Pagination.setPages(0);

    self.location = Gps.locate(
      Setting.getValue("GPS_Enabled", true),
      [
        Setting.getValue("GPS_Latitude", 0.0),
        Setting.getValue("GPS_Longitude", 0.0)
      ]
    );
  }

  public function onSettingsChanged() {
    self.location = Gps.locate(
      Setting.getValue("GPS_Enabled", true),
      [
        Setting.getValue("GPS_Latitude", 0.0),
        Setting.getValue("GPS_Longitude", 0.0)
      ]
    );
  }

  public function onReady(dc) {
    self.arcOffset = (self.center - Pixel.scale(9));

    self.i18nLocationAcquiring = I18n.t(:Location_Acquiring).toUpper();
    self.i18nLocationInvalid = I18n.t(:Location_InvalidLong).toUpper();
    self.i18nToday = I18n.t(:SunTimes_Today).toUpper();
    self.i18nSunrise = I18n.t(:SunTimes_Sunrise).toUpper();
    self.i18nSunset = I18n.t(:SunTimes_Sunset).toUpper();
    self.i18nNextEventIn = I18n.t(:SunTimes_NextEventIn).toUpper();
    self.i18nTwilight = I18n.t(:Twilight).toUpper();

    self.useLargerFont = Setting.getValue("UX_LargerFontEnabled", false);
  }

  public function onIterate(dc) {
    var clock = Clock.getInfo();
    var sun = Sun.getInfo(self.location.radians, self.moment);
    var twilight = Twilight.getInfo(self.location.radians, self.moment, Setting.getValue("Twilight_Level", 2));

    /* default arc */
    dc.setPenWidth(Pixel.scale(10));
    dc.setColor(0x555555, -1);
    dc.drawArc(
      self.center,
      self.center,
      self.arcOffset,
      1,
      0,
      360
    );

    if (self.location.acquiring == true || self.location.error == true) {
      dc.setColor(0xFFFFFF, -1);
      dc.drawText(
        self.center,
        self.center,
        9,
        Graphics.fitTextToArea(
          (self.location.acquiring == true ? self.i18nLocationAcquiring : self.i18nLocationInvalid),
          9,
          Pixel.scale(170),
          Pixel.scale(200),
          false
        ),
        1 | 4
      );
    }

    if (self.location.located == true) {
      if (self.paginating) {
        dc.setColor(0xFFFFFF, -1);
        dc.fillPolygon([
          [self.center - Pixel.scale(8), Pixel.scale(44)],
          [self.center, Pixel.scale(36)],
          [self.center + Pixel.scale(8), Pixel.scale(44)]
        ]);
        dc.fillPolygon([
          [self.center - Pixel.scale(8), Pixel.scale(220)],
          [self.center, Pixel.scale(228)],
          [self.center + Pixel.scale(8), Pixel.scale(220)]
        ]);
      } else {
        var isNight =
          clock.minutesSinceMidnight < ((sun.sunrise.hour * 60) + sun.sunrise.minute) ||
          clock.minutesSinceMidnight > ((sun.sunset.hour * 60) + sun.sunset.minute);

        dc.setColor(isNight ? self.color_skylight : self.color_daylight, -1);
        dc.fillCircle(self.center, Pixel.scale(39), Pixel.scale((!isNight ? 5 : 8)));
        dc.setPenWidth(Pixel.scale(2));

        if (!isNight) {
          for (var i = 0; i < 8; ++i) {
            dc.drawLine(
              Circle.calculateRadialPoint(
                self.center,
                (i * 45),
                Pixel.scale(9),
                :xc
              ),
              Circle.calculateRadialPoint(
                Pixel.scale(39),
                (i * 45),
                Pixel.scale(9),
                :yc
              ),
              Circle.calculateRadialPoint(
                self.center,
                (i * 45),
                Pixel.scale(11),
                :xc
              ),
              Circle.calculateRadialPoint(
                Pixel.scale(39),
                (i * 45),
                Pixel.scale(11),
                :yc
              )
            );
          }
        }

        self.drawMoon(dc);
      }

      dc.setColor(0xFFFFFF, -1);
      dc.drawText(
        self.center,
        Pixel.scale(70),
        self.useLargerFont ? 11 : 10,
        self.paginating
          ? self.momentAsDateString
          : self.i18nToday,
        1 | 4
      );

      dc.setPenWidth(Pixel.scale(10));
      dc.setColor(self.color_daylight, -1);
      dc.drawArc(
        self.center,
        self.center,
        self.arcOffset,
        1,
        sun.sunrise.degree,
        sun.sunset.degree
      );

      dc.setColor(self.color_skylight, -1);
      dc.drawArc(
        self.center,
        self.center,
        self.arcOffset,
        1,
        twilight.dusk.degree,
        twilight.dawn.degree
      );

      dc.setColor(self.color_twilight, -1);
      dc.drawArc(
        self.center,
        self.center,
        self.arcOffset,
        1,
        sun.sunset.degree,
        twilight.dusk.degree
      );
      dc.drawArc(
        self.center,
        self.center,
        self.arcOffset,
        1,
        twilight.dawn.degree,
        sun.sunrise.degree
      );

      dc.setColor(0xAAAAAA, -1);
      dc.drawText(
        Pixel.scale(80),
        Pixel.scale(97),
        self.useLargerFont ? 10 : 9,
        self.i18nSunrise,
        1 | 4
      );
      dc.drawText(
        Pixel.scale(180),
        Pixel.scale(97),
        self.useLargerFont ? 10 : 9,
        self.i18nSunset,
        1 | 4
      );

      dc.setColor(0xFFFFFF, -1);
      dc.drawText(
        Pixel.scale(80),
        Pixel.scale(125),
        self.useLargerFont ? 14 : 13,
        sun.sunrise.asString(),
        1 | 4
      );
      dc.drawText(
        Pixel.scale(180),
        Pixel.scale(125),
        self.useLargerFont ? 14 : 13,
        sun.sunset.asString(),
        1 | 4
      );

      dc.setColor(0xAAAAAA, -1);
      dc.drawText(
        self.center,
        Pixel.scale(161),
        self.useLargerFont ? 10 : 9,
        Setting.getValue("Time_NextEventEnabled", false) ? self.i18nNextEventIn : self.i18nTwilight,
        1 | 4
      );

      if (Setting.getValue("Time_NextEventEnabled", false) == true) {
        dc.drawText(
          self.center,
          Pixel.scale(185),
          self.useLargerFont ? 12 : 11,
          self.paginating ? "--" : self.i18nNextEventIn,
          1 | 4
        );
      } else {
        dc.drawText(
          Pixel.scale(93),
          Pixel.scale(185),
          self.useLargerFont ? 12 : 11,
          twilight.dawn.asString(),
          1 | 4
        );
        dc.drawText(
          Pixel.scale(167),
          Pixel.scale(185),
          self.useLargerFont ? 12 : 11,
          twilight.dusk.asString(),
          1 | 4
        );
      }
    }

    dc.setPenWidth(Pixel.scale(2));
    dc.setColor(0x000000, -1);

    for (var i = 0; i < 24; ++i) {
      dc.drawLine(
        Circle.calculateRadialPoint(
          self.center,
          (i * 15) + 270,
          Pixel.scale(4),
          :x
        ),
        Circle.calculateRadialPoint(
          self.center,
          (i * 15) + 270,
          Pixel.scale(4),
          :y
        ),
        Circle.calculateRadialPoint(
          self.center,
          (i * 15) + 270,
          Pixel.scale(14),
          :x
        ),
        Circle.calculateRadialPoint(
          self.center,
          (i * 15) + 270,
          Pixel.scale(14),
          :y
        )
      );
    }

    var clockTimeDegrees = clock.minutesSinceMidnight/4;

    var markerLineX1 = Circle.calculateRadialPoint(
      self.center,
      clockTimeDegrees - 90,
      Pixel.scale(4),
      :x
    );
    var markerLineY1 = Circle.calculateRadialPoint(
      self.center,
      clockTimeDegrees - 90,
      Pixel.scale(4),
      :y
    );
    var markerLineX2 = Circle.calculateRadialPoint(
      self.center,
      clockTimeDegrees - 90,
      Pixel.scale(14),
      :x
    );
    var markerLineY2 = Circle.calculateRadialPoint(
      self.center,
      clockTimeDegrees - 90,
      Pixel.scale(14),
      :y
    );

    dc.setColor(0x000000, -1);
    dc.setPenWidth(Pixel.scale(11));
    dc.drawLine(markerLineX1, markerLineY1, markerLineX2, markerLineY2);

    dc.setColor(0xFFFFFF, -1);
    dc.setPenWidth(Pixel.scale(7));
    dc.drawLine(markerLineX1, markerLineY1, markerLineX2, markerLineY2);
  }

  private function drawMoon(dc) {
    var moon = Moon.getInfo(self.moment);

    var y = 223;
    var radius = 9;
    var diameter = radius * 2;
    var crescent = .33;

    if (moon.phase > 28.53058770576 || moon.phase <= 1.0) {
      // new moon
      dc.setColor(0x000000, -1);
      dc.fillCircle(self.center, Pixel.scale(y), Pixel.scale(radius));
    } else if (moon.phase > 1.0 && moon.phase <= 6.38264692644001) {
      dc.setColor(0xFFFFFF, -1);
      dc.fillCircle(self.center, Pixel.scale(y), Pixel.scale(radius));

      // waxing crescent
      dc.setColor(0x000000, -1);
      dc.fillCircle(Pixel.scale(130 - (diameter * crescent)), Pixel.scale(y), Pixel.scale(radius));
    } else if (moon.phase > 6.38264692644001 && moon.phase <= 8.38264692644) {
      dc.setColor(0xFFFFFF, -1);
      dc.fillCircle(self.center, Pixel.scale(y), Pixel.scale(radius));

      // first quarter
      dc.setColor(0x000000, -1);
      dc.fillRectangle(Pixel.scale(130 - radius - 3), Pixel.scale(y - radius - 1), Pixel.scale(radius + 4), Pixel.scale(diameter + 3));
    } else if (moon.phase > 8.38264692644 && moon.phase <= 13.76529385288) {
      // waxing gibbous
      dc.setColor(0xFFFFFF, -1);
      dc.fillCircle(self.center, Pixel.scale(y), Pixel.scale(radius));

      dc.setPenWidth(Pixel.scale(diameter));
      dc.setColor(0x000000, -1);
      dc.drawCircle(Pixel.scale(130 + (diameter * crescent)), Pixel.scale(y), Pixel.scale(diameter));
    } else if (moon.phase > 13.76529385288 && moon.phase <= 15.76529385288) {
      // full
      dc.setColor(0xFFFFFF, -1);
      dc.fillCircle(self.center, Pixel.scale(y), Pixel.scale(radius));
    } else if (moon.phase > 15.76529385288 && moon.phase <= 21.14794077932) {
      // waning gibbous
      dc.setColor(0xFFFFFF, -1);
      dc.fillCircle(self.center, Pixel.scale(y), Pixel.scale(radius));

      dc.setPenWidth(Pixel.scale(diameter));
      dc.setColor(0x000000, -1);
      dc.drawCircle(Pixel.scale(130 - (diameter * crescent)), Pixel.scale(y), Pixel.scale(diameter));
    } else if (moon.phase > 21.14794077932 && moon.phase <= 23.14794077932) {
      // third quarter
      dc.setColor(0xFFFFFF, -1);
      dc.fillCircle(self.center, Pixel.scale(y), Pixel.scale(radius));

      dc.setColor(0x000000, -1);
      dc.fillRectangle(Pixel.scale(130), Pixel.scale(y - radius - 1), Pixel.scale(radius + 3), Pixel.scale(diameter + 3));
    } else if (moon.phase > 23.14794077932 && moon.phase <= 28.53058770576) {
      dc.setColor(0xFFFFFF, -1);
      dc.fillCircle(self.center, Pixel.scale(y), Pixel.scale(radius));

      // waning crescent
      dc.setColor(0x000000, -1);
      dc.fillCircle(Pixel.scale(130 + (diameter * crescent)), Pixel.scale(y), Pixel.scale(radius));
    }
  }

  private function timeTravel(direction) {
    if (direction == :forwards) {
      self.moment = self.moment.add(new Time.Duration(86400));
    } else if (direction == :backwards) {
      self.moment = self.moment.subtract(new Time.Duration(86400));
    } else {
      self.moment = Time.now();
    }

    var momentDate = Gregorian.info(self.moment, Time.FORMAT_MEDIUM);
    var nowDate = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);

    self.momentAsDateString = Lang.format(
      "$1$, $2$ $3$",
      [
        momentDate.day_of_week,
        momentDate.month,
        momentDate.day
      ]
    ).toUpper();

    if (self.paginating == false) {
      var monthsMatch = momentDate.month.equals(nowDate.month);
      var daysMatch = momentDate.day == nowDate.day;

      if (!monthsMatch || !daysMatch) {
        self.paginating = true;
      }
    }
  }

  public function onSelect() {
    self.paginating = true;

    self.momentAsDateString = self.i18nToday;
  }

  public function onPrevious() {
    self.timeTravel(:forwards);

    return true;
  }

  public function onNext() {
    self.timeTravel(:backwards);

    return true;
  }

  public function onExit() {
    if (self.paginating) {
      self.paginating = false;

      self.timeTravel(:now);

      return true;
    }

    return false;
  }

  public function selectView() {
    return self;
  }
}
