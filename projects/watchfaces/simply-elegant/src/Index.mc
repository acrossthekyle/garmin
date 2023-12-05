using Keg.Fonts;
using Keg.Fonts.Coordinates;
using Keg.Pixel;
using Keg.Setting;
using Keg.Utilities.Circle;
using Keg.Views;
using Keg.Watchface.Data;
using Keg.Watchface.Icons;

class Index extends Views.AbstractWatchFaceView
{
  public var cacheKeys = [
    "Top",
    "Bottom"
  ];

  private var clockAmPmColor = 0xFF0000;
  private var clockAmPmEnabled = false;
  private var clockEnlarge = false;
  private var clockHoursColor = 0xFF0000;
  private var clockMinutesColor = 0xFF0000;
  private var clockSecondsColor = 0xFF0000;
  private var clockSecondsEnabled = true;
  private var complicationsBottomColor = 0xFF0000;
  private var complicationsBottomType = 0;
  private var complicationsFontSize = 14;
  private var complicationsTopColor = 0xFF0000;
  private var complicationsTopType = 0;
  private var gpsLatitude = 0.0;
  private var gpsLongitude = 0.0;
  private var unitsPressure = 0;

  public function initialize() {
    Views.AbstractWatchFaceView.initialize();
  }

  public function onSettingsReady() {
    self.clockAmPmColor = Setting.getValue("Clock_AmPmColor", 0xFFFFFF);
    self.clockAmPmEnabled = Setting.getValue("Clock_AmPmEnabled", false);
    self.clockEnlarge = Setting.getValue("Clock_Enlarge", false);
    self.clockHoursColor = Setting.getValue("Clock_HoursColor", 0xFFFFFF);
    self.clockMinutesColor = Setting.getValue("Clock_MinutesColor", 0xFF0000);
    self.clockSecondsColor = Setting.getValue("Clock_SecondsColor", 0xFF0000);
    self.clockSecondsEnabled = Setting.getValue("Clock_SecondsEnabled", true);
    self.complicationsBottomColor = Setting.getValue("Complications_BottomColor", 0xFF0000);
    self.complicationsBottomType = Setting.getValue("Complications_BottomType", 3);
    self.complicationsTopColor = Setting.getValue("Complications_TopColor", 0xFF0000);
    self.complicationsTopType = Setting.getValue("Complications_TopType", 17);
    self.gpsLatitude = Setting.getValue("GPS_Latitude", 0.0);
    self.gpsLongitude = Setting.getValue("GPS_Latitude", 0.0);
    self.unitsPressure = Setting.getValue("Units_Pressure", 0);

    if (
      [
        "descentmk2",
        "descentmk2s",
        "enduro",
        "fenix6",
        "fenix6pro",
        "fenix6s",
        "fenix6spro",
        "fenix6xpro",
        "fenix7",
        "fenix7s",
        "fenix7x",
        "marqadventurer",
        "marqathlete",
        "marqaviator",
        "marqcaptain",
        "marqcommander",
        "marqdriver",
        "marqexpedition",
        "marqgolfer"
      ].indexOf(Setting.getValue("Device_ID", "")) > -1
    ) {
      self.complicationsFontSize = 13;
    }
  }

  public function onAlwaysOn(dc) {
    self.clock(dc, false, true);
  }

  public function onIteratePartial(dc) {
    self.clock(dc, true, false);
  }

  public function onIterate(dc) {
    self.icons(dc);

    var top = Data.getInfo({
      :type           => self.complicationsTopType,
      :key            => self.cacheKeys[0],
      :pressureIndex  => self.unitsPressure,
      :dateIndex      => :custom,
      :latitude       => self.gpsLatitude,
      :longitude      => self.gpsLongitude,
    });

    self.complication(dc, top, self.complicationsTopColor, 68);

    var bottom = Data.getInfo({
      :type           => self.complicationsBottomType,
      :key            => self.cacheKeys[1],
      :pressureIndex  => self.unitsPressure,
      :dateIndex      => :custom,
      :latitude       => self.gpsLatitude,
      :longitude      => self.gpsLongitude,
    });

    self.complication(dc, bottom, self.complicationsBottomColor, 215);

    self.clock(dc, false, false);

    dc.setPenWidth(Pixel.scale(2));
    dc.setColor(0x555555, -1);
    dc.drawLine(
      Pixel.scale(20),
      Pixel.scale(90),
      Pixel.scale(240),
      Pixel.scale(90)
    );
    dc.drawLine(
      Pixel.scale(20),
      Pixel.scale(168),
      Pixel.scale(240),
      Pixel.scale(168)
    );
  }

  private function icons(dc) {
    var icons = [];

    if (self.isPhoneConnected) {
      icons.add(Icons.getIcon(:Drawable_Bluetooth));
    }

    if (self.hasNotifications) {
      icons.add(Icons.getIcon(:Drawable_Notification));
    }

    if (self.hasAlarms) {
      icons.add(Icons.getIcon(:Drawable_Alarm));
    }

    if (self.doNotDisturb) {
      icons.add(Icons.getIcon(:Drawable_DoNotDisturb));
    }

    var iconsCount = icons.size();

    if (iconsCount > 0) {
      var iconWidth = icons[0].getWidth();
      var iconHeight = icons[0].getHeight();

      var gap = Pixel.scale(7);

      var y = Pixel.scale(229);
      var x = (
        Pixel.scale(130) -
        (
          (
            gap + (iconsCount * (iconWidth + gap))
          ) / 2
        )
      ) + gap;

      for (var i = 0; i < iconsCount; ++i) {
        dc.drawBitmap(x, y, icons[i]);

        x += (iconWidth + gap);
      }
    }

    if (self.batteryEnabled) {
      var iconX = Pixel.scale(130) - (Pixel.scale(22)/2);
      var textX = Pixel.scale(130);
      var iconY = Pixel.scale(10) - (Pixel.scale(12)/2);
      var textY = Fonts.snap(:top, 18, Fonts.getAdjustments(9));

      dc.setColor(0xFFFFFF, -1);
      dc.setPenWidth(Pixel.scale(1));
      dc.drawRoundedRectangle(
        iconX,
        iconY,
        Pixel.scale(22),
        Pixel.scale(12),
        Pixel.scale(2)
      );

      if (self.batteryPercent <= .25) {
        dc.setColor(0xFF0000, -1);
      } else {
        dc.setColor(0xFFFFFF, -1);
      }

      dc.fillRoundedRectangle(
        iconX + Pixel.scale(2),
        iconY + Pixel.scale(2),
        Pixel.scale(18 * self.batteryPercent),
        Pixel.scale(8),
        Pixel.scale(2)
      );

      dc.setColor(0xFFFFFF, -1);
      dc.setPenWidth(Pixel.scale(2));
      dc.drawLine(
        iconX + Pixel.scale(22),
        iconY + Pixel.scale(2),
        iconX + Pixel.scale(22),
        iconY + Pixel.scale(8)
      );

      dc.setColor(0xFFFFFF, -1);
      dc.drawText(
        textX,
        textY,
        9,
        self.batteryRemaining,
        1
      );
    }
  }

  private function complication(dc, data, color, y) {
    var textCoordinates = Coordinates.calculate(:bottom, y, Fonts.getAdjustments(self.complicationsFontSize));

    dc.setColor(0xFFFFFF, -1);
    dc.drawText(
      Pixel.scale(132),
      Pixel.scale(textCoordinates.bottom),
      self.complicationsFontSize,
      data.value == null ? "--" : data.asString(),
      0
    );

    var extraTinyAdjustments = Fonts.getAdjustments(9);

    var label = data.getLabel();

    if (label != null) {
      dc.drawText(
        Pixel.scale(138),
        Fonts.snap(:top, textCoordinates.top - 1, extraTinyAdjustments),
        9,
        label.toUpper(),
        2
      );
    }

    var unitsWidth = 0;

    dc.setColor(color, -1);

    if (data.units != null) {
      unitsWidth = dc.getTextWidthInPixels(data.units, 9);

      dc.drawText(
        Pixel.scale(138),
        Fonts.snap(:bottom, y, extraTinyAdjustments),
        9,
        data.units,
        2
      );
    }

    var unitsLabel = data.getUnitsLabel();

    if (unitsLabel != null) {
      dc.drawText(
        Pixel.scale(138),
        Fonts.snap(:bottom, y, extraTinyAdjustments),
        9,
        (data.units != null ? " (" + unitsLabel.toLower() + ")" : unitsLabel),
        2
      );
    }
  }

  private function clock(dc, isPartial, isLowPower) {
    var fontSize = self.clockEnlarge ? 17 : 16;

    var canSeeSeconds = (self.canShowSeconds && self.clockSecondsEnabled);
    var cannotSeeSeconds = !canSeeSeconds || isLowPower;

    var fontAdjustments = Fonts.getAdjustments(fontSize);
    var fontCoordinates = Coordinates.calculate(:middle, 130, fontAdjustments);

    if (!isPartial) {
      dc.setColor(self.clockHoursColor, -1);
      dc.drawText(
        Pixel.scale(cannotSeeSeconds ? 123 : 94),
        Pixel.scale(fontCoordinates.middle),
        fontSize,
        self.hour,
        0
      );

      dc.setColor(
        (
          self.clockHoursColor == self.clockMinutesColor
            ? self.clockHoursColor
            : 0xAAAAAA
        ),
        -1
      );
      dc.drawText(
        Pixel.scale(cannotSeeSeconds ? 130 : 101),
        Fonts.snap(:middle, 130, Fonts.getAdjustments(fontSize - 1)),
        fontSize - 1,
        ":",
        1
      );

      dc.setColor(self.clockMinutesColor, -1);
      dc.drawText(
        Pixel.scale(cannotSeeSeconds ? 137 : 108),
        Pixel.scale(fontCoordinates.middle),
        fontSize,
        self.minute,
        2
      );
    }

    if (isPartial && !cannotSeeSeconds) {
      dc.setClip(Pixel.scale(192), Pixel.scale(102), Pixel.scale(56), Pixel.scale(56));
      dc.setColor(0x000000, 0x000000);
      dc.fillRectangle(
        Pixel.scale(192),
        Pixel.scale(102),
        Pixel.scale(56),
        Pixel.scale(56)
      );
    }

    if (self.clockAmPmEnabled && self.isMeridean) {
      dc.setColor(self.clockAmPmColor, -1);
      dc.drawText(
        Pixel.scale(cannotSeeSeconds ? 138 : 109) + dc.getTextWidthInPixels(self.minute, fontSize),
        Fonts.snap(:bottom, fontCoordinates.bottom, Fonts.getAdjustments(9)),
        9,
        self.pm ? "PM" : "AM",
        2
      );
    }

    if (cannotSeeSeconds) {
      return;
    }

    dc.setColor(0xAAAAAA, -1);
    dc.setPenWidth(Pixel.scale(2));
    dc.drawLine(
      Pixel.scale(192),
      Pixel.scale(130),
      Pixel.scale(207),
      Pixel.scale(130)
    );
    dc.drawLine(
      Pixel.scale(233),
      Pixel.scale(130),
      Pixel.scale(248),
      Pixel.scale(130)
    );
    dc.drawLine(
      Pixel.scale(220),
      Pixel.scale(102),
      Pixel.scale(220),
      Pixel.scale(117)
    );
    dc.drawLine(
      Pixel.scale(220),
      Pixel.scale(143),
      Pixel.scale(220),
      Pixel.scale(158)
    );

    var secondDegrees = Math.toDegrees(self.secondAngle).toNumber() - 90;

    dc.setColor(self.clockSecondsColor, -1);
    dc.fillCircle(
      Pixel.scale(220),
      Pixel.scale(130),
      Pixel.scale(2)
    );
    dc.setPenWidth(Pixel.scale(3));
    dc.drawLine(
      Circle.calculateRadialPoint(Pixel.scale(220), secondDegrees, -Pixel.scale(8), :xc),
      Circle.calculateRadialPoint(Pixel.scale(130), secondDegrees, -Pixel.scale(8), :yc),
      Circle.calculateRadialPoint(Pixel.scale(220), secondDegrees, Pixel.scale(25), :xc),
      Circle.calculateRadialPoint(Pixel.scale(130), secondDegrees, Pixel.scale(25), :yc)
    );
  }
}
