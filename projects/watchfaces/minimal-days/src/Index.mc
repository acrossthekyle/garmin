using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.System;
using Keg.Fonts;
using Keg.Fonts.Coordinates;
using Keg.Pixel;
using Keg.Setting;
using Keg.Views;
using Keg.Watchface.Data;
using Keg.Watchface.Icons;

class Index extends Views.AbstractWatchFaceView
{
  public var cacheKeys = [
    "ComplicationsCacheDaylight"
  ];

  private var daysOfTheWeek = [];

  private var clockAmPmColor = 0xFFFFFF;
  private var clockAmPmEnabled = false;
  private var clockEnlarge = false;
  private var clockHoursColor = 0xFFFFFF;
  private var clockMinutesColor = 0xFFFFFF;
  private var clockSecondsColor = 0xFFFFFF;
  private var clockSecondsEnabled = true;
  private var gpsLatitude = 0.0;
  private var gpsLongitude = 0.0;
  private var unitsPressure = 0;
  private var unitsDate = 0;

  private var complicationsColor = 0xFFFFFF;
  private var complicationsEnlarge = true;
  private var complicationsIconEnabled = true;
  private var complicationsType = 0;
  private var daysColor = 0x0055FF;
  private var daysTextColor = 0xFFFFFF;
  private var daysTextGoalColor = 0x0055FF;
  private var daysEnlarge = true;
  private var daysGoal = 0;
  private var daysType = 0;

  public function initialize() {
    Views.AbstractWatchFaceView.initialize();
  }

  public function onReady(dc) {
    var moment = Gregorian.moment({ :year => 2000, :month => 1, :day => 2, :hour => 12, :minute => 0 });

    self.daysOfTheWeek = [
      Gregorian.info(moment, Time.FORMAT_MEDIUM).day_of_week.toCharArray()[0],
      Gregorian.info(moment.add(new Time.Duration(Gregorian.SECONDS_PER_DAY)), Time.FORMAT_MEDIUM).day_of_week.toCharArray()[0],
      Gregorian.info(moment.add(new Time.Duration(Gregorian.SECONDS_PER_DAY * 2)), Time.FORMAT_MEDIUM).day_of_week.toCharArray()[0],
      Gregorian.info(moment.add(new Time.Duration(Gregorian.SECONDS_PER_DAY * 3)), Time.FORMAT_MEDIUM).day_of_week.toCharArray()[0],
      Gregorian.info(moment.add(new Time.Duration(Gregorian.SECONDS_PER_DAY * 4)), Time.FORMAT_MEDIUM).day_of_week.toCharArray()[0],
      Gregorian.info(moment.add(new Time.Duration(Gregorian.SECONDS_PER_DAY * 5)), Time.FORMAT_MEDIUM).day_of_week.toCharArray()[0],
      Gregorian.info(moment.add(new Time.Duration(Gregorian.SECONDS_PER_DAY * 6)), Time.FORMAT_MEDIUM).day_of_week.toCharArray()[0]
    ];
  }

  public function onSettingsReady() {
    self.clockAmPmColor = Setting.getValue("Clock_AmPmColor", 0xFFFFFF);
    self.clockAmPmEnabled = Setting.getValue("clockAmPmEnabled", false);
    self.clockEnlarge = Setting.getValue("Clock_Enlarge", false);
    self.clockHoursColor = Setting.getValue("Clock_HoursColor", 0xFFFFFF);
    self.clockMinutesColor = Setting.getValue("Clock_MinutesColor", 0xFFFFFF);
    self.clockSecondsColor = Setting.getValue("Clock_SecondsColor", 0xFFFFFF);
    self.clockSecondsEnabled = Setting.getValue("Clock_SecondsEnabled", true);
    self.gpsLatitude = Setting.getValue("GPS_Latitude", 0.0);
    self.gpsLongitude = Setting.getValue("GPS_Latitude", 0.0);
    self.unitsPressure = Setting.getValue("Units_Pressure", 0);
    self.unitsDate = Setting.getValue("Units_Date", 0);

    self.complicationsColor = Setting.getValue("Complications_Color", 0xFFFFFF);
    self.complicationsEnlarge = Setting.getValue("Complications_EnlargeEnabled", true);
    self.complicationsIconEnabled = Setting.getValue("Complications_IconEnabled", true);
    self.complicationsType = Setting.getValue("Complications_Type", 3);
    self.daysColor = Setting.getValue("Days_Color", 0x0055FF);
    self.daysTextColor = Setting.getValue("Days_TextColor", 0xFFFFFF);
    self.daysTextGoalColor = Setting.getValue("Days_TextGoalColor", 0x0055FF);
    self.daysEnlarge = Setting.getValue("Days_EnlargeEnabled", true);
    self.daysGoal = Setting.getValue("Days_Goal", 0);
    self.daysType = Setting.getValue("Days_Type", 0);
  }

  public function onAlwaysOn(dc) {
    self.clock(dc, false, true);
    self.complication(dc);
  }

  public function onIteratePartial(dc) {
    self.clock(dc, true, false);
  }

  public function onIterate(dc) {
    dc.setColor(self.daysColor, -1);
    dc.setPenWidth(Pixel.scale(3));
    dc.drawRoundedRectangle(
      Pixel.scale(81),
      Pixel.scale(14),
      Pixel.scale(46),
      Pixel.scale(232),
      Pixel.scale(30)
    );

    var activityInfo = ActivityMonitor.getInfo();

    var current = Gregorian.info(Time.now(), Time.FORMAT_SHORT).day_of_week;

    var start = System.getDeviceSettings().firstDayOfWeek;

    var days = new [7];

    for (var i = 0; i < 7; ++i) {
      days[i] = self.daysOfTheWeek[start - 1];

      start += 1;

      if (start == 8) {
        start = 1;
      }
    }

    // If weeks starts on Monday then subtract 1 from day_of_week
    if (start == 2) {
      current -= 1;

      if (current == 0) {
        current = 7;
      }
    }
    // If weeks starts on Saturday then add 1 to day_of_week
    else if (start == 7) {
      current += 1;

      if (current > 7) {
        current = 1;
      }
    }

    var daysHistory = ActivityMonitor.getHistory();
    var daysHistorySize = daysHistory.size();

    var daysX = Pixel.scale(104);
    var daysY = Pixel.scale(36);
    var daysSize = self.daysEnlarge ? 11 : 9;

    var isToday = false;
    var isGreaterThanToday = false;

    daysHistory = daysHistory.slice(0, current - 1).reverse();

    var drewGoal = null;

    for (var i = 0; i < 7; ++i) {
      isToday = current == (i + 1);
      isGreaterThanToday = (i + 1) > current;
      drewGoal = false;

      if (!isGreaterThanToday && (i <= (daysHistorySize - 1))) {
        drewGoal = self.renderGoal(
          dc,
          isToday,
          !isToday && daysHistorySize > 0 ? daysHistory[i] : null,
          activityInfo,
          daysX,
          daysY
        );
      }

      if (!drewGoal) {
        dc.setColor(self.daysTextColor, -1);
        dc.drawText(
          daysX,
          daysY,
          daysSize,
          days[i],
          1 | 4
        );
      }

      if (isToday) {
        dc.setColor(self.daysColor, -1);
        dc.fillPolygon([
          [Pixel.scale(126), daysY - Pixel.scale(7)],
          [Pixel.scale(118), daysY],
          [Pixel.scale(126), daysY + Pixel.scale(7)]
        ]);
      }

      daysY += Pixel.scale(31.25);
    }

    self.clock(dc, false, false);

    self.icons(dc);

    self.complication(dc);
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

      if (self.clockEnlarge) {
        var gap = Pixel.scale(6);

        var y = Pixel.scale(198);
        var x = Pixel.scale(231) - iconWidth;

        for (var i = 0; i < iconsCount; ++i) {
          dc.drawBitmap(x, y, icons[i]);

          x -= (iconWidth + gap);
        }
      } else {
        var gap = Pixel.scale(12);

        var x = Pixel.scale(142) - (icons[0].getWidth()/2);
        var y = (
          Pixel.scale(130) -
          (
            (
              gap + (iconsCount * (iconHeight + gap))
            ) / 2
          )
        ) + gap;

        for (var i = 0; i < iconsCount; ++i) {
          dc.drawBitmap(x, y, icons[i]);

          y += (iconHeight + gap);
        }
      }
    }

    if (self.batteryEnabled) {
      var hoursWidth = dc.getTextWidthInPixels(self.hour, self.clockEnlarge ? 17 : 16);
      var minutesWidth = dc.getTextWidthInPixels(self.minute, self.clockEnlarge ? 17 : 16);

      var iconX = Pixel.scale(self.clockEnlarge ? 235 : 233) - (hoursWidth > minutesWidth ? hoursWidth : minutesWidth);
      var textX = iconX;
      var iconY = Pixel.scale(self.clockEnlarge ? 42 : 40) - Pixel.scale(12)/2;
      var textY = Fonts.snap(:top, self.clockEnlarge ? 50 : 48, Fonts.getAdjustments(9));

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
        2
      );
    }
  }

  private function complication(dc) {
    var data = Data.getInfo({
      :type           => self.complicationsType,
      :key            => self.cacheKeys[0],
      :pressureIndex  => self.unitsPressure,
      :dateIndex      => self.unitsDate,
      :latitude       => self.gpsLatitude,
      :longitude      => self.gpsLongitude,
    });

    var mainFontSize = self.complicationsEnlarge ? 12 : 11;
    var mainFontAdjustments = Fonts.getAdjustments(mainFontSize);
    var mainFontCoordinates = Coordinates.calculate(:middle, 130, mainFontAdjustments);
    var secondaryFontSize = mainFontSize - 2;
    var secondaryFontAdjustments = Fonts.getAdjustments(secondaryFontSize);

    var icon = data.getIcon();

    if (data.prefix != null) {
      dc.setColor(self.complicationsColor, -1);
      dc.drawText(
        Pixel.scale(40),
        (Fonts.snap(:bottom, 130, secondaryFontAdjustments) - mainFontAdjustments.height),
        secondaryFontSize,
        data.prefix,
        1
      );

      if (icon != null && self.complicationsIconEnabled) {
        dc.drawBitmap(
          (Pixel.scale(40) - (icon.getWidth()/2)),
          (Fonts.snap(:bottom, 130, mainFontAdjustments) - mainFontAdjustments.height) - secondaryFontAdjustments.height,
          icon
        );
      }
    } else if (icon != null && self.complicationsIconEnabled) {
      dc.drawBitmap(
        (Pixel.scale(40) - (icon.getWidth()/2)),
        (Fonts.snap(:bottom, mainFontCoordinates.top, mainFontAdjustments)),
        icon
      );
    }

    dc.setColor(self.complicationsColor, -1);
    dc.drawText(
      Pixel.scale(40),
      Pixel.scale(mainFontCoordinates.middle),
      mainFontSize,
      data.value == null ? "--" : data.asString(),
      1
    );

    if (data.units != null) {
      dc.drawText(
        Pixel.scale(40),
        Fonts.snap(:top, mainFontCoordinates.bottom + 8, Fonts.getAdjustments(9)),
        9,
        data.units,
        1
      );
    }
  }

  private function clock(dc, isPartial, isLowPower) {
    var largeFont = self.clockEnlarge ? 17 : 16;
    var largeFontAdjustments = Fonts.getAdjustments(largeFont);

    var smallFont = 11;
    var smallFontAdjustments = Fonts.getAdjustments(smallFont);

    if (!isPartial) {
      dc.setColor(self.clockHoursColor, -1);
      dc.drawText(
        Pixel.scale(231),
        Fonts.snap(:bottom, 123, largeFontAdjustments),
        largeFont,
        self.hour,
        0
      );

      dc.setColor(self.clockMinutesColor, -1);
      dc.drawText(
        Pixel.scale(231),
        Fonts.snap(:top, 137, largeFontAdjustments),
        largeFont,
        self.minute,
        0
      );
    }

    if (isLowPower) {
      return;
    }

    if (!isPartial && self.clockAmPmEnabled && self.isMeridean) {
      dc.setColor(self.clockAmPmColor, -1);
      dc.drawText(
        Pixel.scale(232),
        Fonts.snap(:bottom, 123, Fonts.getAdjustments(9)),
        9,
        self.pm ? "PM" : "AM",
        2
      );
    }

    if (!(self.canShowSeconds && self.clockSecondsEnabled)) {
      return;
    }

    var secondsY = Fonts.snap(:top, 137, smallFontAdjustments);

    if (isPartial) {
      var secondsWidth = dc.getTextWidthInPixels(self.second, smallFont);

      dc.setClip(
        Pixel.scale(232),
        secondsY,
        secondsWidth,
        smallFontAdjustments.height + Pixel.scale(12)
      );
      dc.setColor(0x000000, 0x000000);
      dc.fillRectangle(
        Pixel.scale(232),
        secondsY,
        secondsWidth,
        smallFontAdjustments.height + Pixel.scale(12)
      );
    }

    dc.setColor(self.clockSecondsColor, -1);
    dc.drawText(
      Pixel.scale(232),
      secondsY,
      smallFont,
      self.second,
      2
    );
  }

  private function renderGoal(dc, isToday, historyDayOf, activityInfo, x, y) {
    if (self.daysType == 0) {
      return false;
    }

    var percentage = 0;
    var source = (isToday ? activityInfo : historyDayOf);
    var type = self.daysType;
    var goal = self.daysGoal;

    if (source != null) {
      if (type == 1) {
        percentage = (source.steps || 0)/(source.stepGoal == null ? 1.0 : source.stepGoal.toFloat());
      } else if (type == 2) {
        percentage = (source.floorsClimbed || 0)/(source.floorsClimbedGoal == null ? 1.0 : source.floorsClimbedGoal.toFloat());
      } else if (type == 3) {
        source = isToday ? activityInfo.activeMinutesDay : historyDayOf.activeMinutes;

        if (source != null && activityInfo.activeMinutesWeekGoal != null) {
          percentage = source.total/(activityInfo.activeMinutesWeekGoal/7.0);
        }
      } else if (type == 4) {
        if (goal > 0 && source.calories != null) {
          percentage = source.calories/goal.toFloat();
        }
      } else if (type == 5) {
        if (goal > 0 && source.distance != null) {
          percentage = source.distance/goal.toFloat();
        }
      }
    }

    source = null;

    if (percentage > 1) {
      percentage = 1;
    }

    if (percentage > 0) {
      var radius = 0;

      if (percentage >= .33 && percentage < .66) {
        radius = 6;
      } else if (percentage >= .66 && percentage <= .99) {
        radius = 9;
      } else if (percentage >= 1) {
        radius = 12;
      }

      if (radius > 0) {
        dc.setColor(self.daysTextGoalColor, -1);
        dc.fillCircle(
          x,
          y,
          Pixel.scale(radius)
        );

        percentage = null;

        return true;
      }

      radius = null;
    }

    percentage = null;

    return false;
  }
}
