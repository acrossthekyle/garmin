using Toybox.Math;
using Toybox.System;
using Toybox.WatchUi;
using Keg.Cache;
using Keg.I18n;
using Keg.Setting;
using Keg.Sleep;

module Keg
{
	module Views
	{
		class AbstractWatchFaceView extends WatchUi.WatchFace
		{
		  public var center = 0;
		  public var height = 0;
		  public var width = 0;

		  public var canPartiallyUpdate = (WatchUi.WatchFace has :onPartialUpdate);
		  public var canShowSeconds = true;
		  public var hasBatteryInDays = false;
		  public var isAmoled = false;
		  public var isInactive = false;
		  public var isInLowBatteryMode = false;
		  public var isInLowPowerMode = false;
		  public var isInSleepMode = false;
		  public var isMeridean = false;
		  public var shouldNotRender = false;

		  public var batteryEnabled = false;
		  public var hasNotifications = false;
		  public var isPhoneConnected = false;
		  public var hasAlarms = false;
		  public var doNotDisturb = false;

		  public var am = true;
		  public var pm = false;
		  public var hour = 0;
		  public var hourAngle = 0;
		  public var minute = 0;
		  public var minuteAngle = 0;
		  public var second = 0;
		  public var secondAngle = 0;

		  public var batteryPercent = 0;
		  public var batteryRemaining = "0%";
		  public var batteryRemainingAbbreviated = "0%";

		  public var i18nDay = "";
	    public var i18nDays = "";

	    public var cacheKeys = [];

		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  //
		  //                    INSTANTIATION
		  //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //

		  public function initialize() {
		    WatchFace.initialize();

		    var settings = System.getDeviceSettings();
		    var stats = System.getSystemStats();

		    self.isMeridean = !settings.is24Hour;
		    self.isAmoled = settings.requiresBurnInProtection;
		    self.hasBatteryInDays = (stats has :batteryInDays);

		    self.onContinuousUpdate();
		  }

		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  //
		  //                        ON LAYOUT
		  //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //

		  public function onLayout(dc) {
		    self.height = dc.getHeight();
		    self.width = dc.getWidth();
		    self.center = self.width/2;

		    self.i18nDay = I18n.t(:System_BatteryDay).toUpper();
		    self.i18nDays = I18n.t(:System_BatteryDays).toUpper();

		    self.onPeriodicUpdate();
		    self.onReady(dc);
		    self.onSettingsReady();
		  }

		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  //
		  //              ON BURN-IN DETECTED
		  //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //

		  public function onPowerBudgetExceeded() {
		    self.canPartiallyUpdate = false;

		    if (self.isAmoled) {
		      self.shouldNotRender = true;
		    }
		  }

		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  //
		  //                         ON SLEEP
		  //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //

		  public function onEnterSleep() {
		    self.isInactive = true;

		    if (!self.isAmoled) {
		      self.shouldNotRender = Setting.getValue("MIP_RaiseToWakeEnabled", false);
		    } else {
		      self.shouldNotRender = !self.canPartiallyUpdate;
		    }

		    if (Setting.getValue("Clock_SecondsOnlyWhenActiveEnabled", true)) {
		    	self.canShowSeconds = false;
		    }

		    WatchUi.requestUpdate();
		  }

		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  //
		  //                      ON ACTIVATE
		  //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //

		  public function onExitSleep() {
		    self.isInactive = false;
		    self.shouldNotRender = false;

		    if (Setting.getValue("Clock_SecondsOnlyWhenActiveEnabled", true)) {
		    	self.canShowSeconds = true;
		    }

		    WatchUi.requestUpdate();
		  }

		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  //
		  //     APPLICATION SETTINGS CHANGED
		  //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //

		  public function onSettingsChanged() {
		  	self.onSettingsReady();

		    Cache.wipe(self.cacheKeys);
		  }

		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  //
		  //                   PARTIAL UPDATE
		  //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //

		  public function onPartialUpdate(dc) {
		    // If in low-power mode, or if it is a MIP device with raise-to-wake
		    // enabled, then do not do updates every second (partial updates).
		    if (self.isInLowPowerMode || (Setting.getValue("MIP_RaiseToWakeEnabled", false) && !self.isAmoled)) {
		      return;
		    }

		    self.onContinuousUpdate();

		    dc.setAntiAlias(true);

		    self.onIteratePartial(dc);
		  }

		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  //
		  //                        ON UPDATE
		  //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //

		  public function onUpdate(dc) {
		    self.onContinuousUpdate();

		    if (System.getClockTime().sec == 0) {
		      self.onPeriodicUpdate();
		    }

		    dc.setAntiAlias(true);
		    dc.clearClip();
		    dc.setColor(0x000000, 0x000000);
		    dc.fillRectangle(0, 0, 500, 500);

		    if (self.shouldNotRender) {
		      if (Setting.getValue("AOD_Enabled", true)) {
		        self.onAlwaysOn(dc);

		        dc.setPenWidth(1);
					  dc.setColor(0x000000, -1);

					  var start = System.getClockTime().min % 2 == 0 ? 1 : 0;

					  var x = start;
					  var y = start;

					  for (var i = start; i < 900; ++i) {
					    dc.drawLine(x, 0, x, 900);
					    dc.drawLine(0, y, 900, y);

					    x += 2;
					    y += 2;
					  }
		      }

		      return;
		    }

		    if (self.isInLowPowerMode) {
		      var date = Time.Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);

				  dc.setColor(0xFFFFFF, -1);
				  dc.drawText(
				    Pixel.scale(130),
				    Pixel.scale(65),
				    11,
				    Lang.format(
				      "$1$ $2$",
				      [
				        date.day_of_week,
				        date.day
				      ]
				    ).toUpper(),
				    1 | 4
				  );

				  dc.setColor(0xFFFFFF, -1);
				  dc.drawText(
				    Pixel.scale(126),
				    Pixel.scale(130),
				    17,
				    self.hour,
				    0 | 4
				  );
				  dc.setColor(0xAAAAAA, -1);
				  dc.drawText(
				    Pixel.scale(134),
				    Pixel.scale(130),
				    17,
				    self.minute,
				    2 | 4
				  );

				  var icons = [];

				  if (self.isInSleepMode) {
				    icons.add(Icons.getIcon(:Drawable_Sleep));
				  }

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

				  if (icons.size() > 0) {
				    var iconWidth = icons[0].getWidth();
				    var iconHeight = icons[0].getHeight();

				    var gap = Pixel.scale(9);

				    var x = (
				      Pixel.scale(130) -
				      (
				        (
				          gap + (icons.size() * (iconWidth + gap))
				        ) / 2
				      )
				    ) + gap;

				    var y = Pixel.scale(180);

				    for (var i = 0; i < icons.size(); ++i) {
				      dc.drawBitmap(x, y, icons[i]);

				      x += (iconWidth + gap);
				    }
				  }

				  var batteryIcon = Icons.getIcon(:Drawable_Battery);

				  dc.drawBitmap(
				    (Pixel.scale(130) - (batteryIcon.getWidth()/2)),
				    (Pixel.scale(230) - batteryIcon.getHeight()),
				    batteryIcon
				  );
				  dc.setColor(0xFFFFFF, -1);
				  dc.drawText(
				    Pixel.scale(130),
				    Fonts.snap(:top, 230, Fonts.getAdjustments(:extraTiny)),
				    9,
				    (self.batteryPercent * 100).format("%d") + "%",
				    1
				  );
		    } else {
		      self.onIterate(dc);
		    }
		  }

		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  //
		  //              UPDATE EVERY MINUTE
		  //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //

		  public function onPeriodicUpdate() {
		    var stats = System.getSystemStats();

		    self.isInLowBatteryMode = (stats.battery <= 10.0000000 ? Setting.getValue("LowBattery_Enabled", false) : false);
		    self.isInSleepMode = Setting.getValue("Sleep_Enabled", false) ? Sleep.isUserAwake() == false : false;
		    self.isInLowPowerMode = (self.isInLowBatteryMode || self.isInSleepMode);

		    self.batteryPercent = stats.battery/100.0;

		    if (self.hasBatteryInDays) {
		    	self.batteryRemaining = stats.batteryInDays.format("%d") + " " + (
	          (stats.batteryInDays < 2.0 && stats.batteryInDays > 0.9)
	            ? self.i18nDay
	            : self.i18nDays
	        );
	      } else {
	       	self.batteryRemaining = stats.battery.format("%d") + "%";
	      }
		  }

		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  //
		  //              UPDATE EVERY SECOND
		  //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //

		  public function onContinuousUpdate() {
		    var settings = System.getDeviceSettings();

		    self.batteryEnabled = Setting.getValue("System_BatteryEnabled", false);
		    self.hasNotifications = Setting.getValue("System_NotificationsEnabled", true) && settings.notificationCount > 0;
		    self.isPhoneConnected = Setting.getValue("System_BluetoothEnabled", true) && settings.phoneConnected;
		    self.hasAlarms = Setting.getValue("System_AlarmsEnabled", true) && settings.alarmCount > 0;
		    self.doNotDisturb = Setting.getValue("System_DoNotDisturbEnabled", true) && (settings has :doNotDisturb ? settings.doNotDisturb : false);

		    var time = System.getClockTime();

		    self.am = time.hour < 12;
		    self.pm = time.hour > 11;
		    self.hour = self.isMeridean
		      ? (time.hour > 12 ? time.hour - 12 : time.hour)
		      : time.hour;
		    self.hour = self.hour.format(self.hour < 10 ? "%02d" : "%d");
		    self.hourAngle = self.isMeridean
			    ? ((((time.hour % 12) * 60) + time.min) / (12 * 60.0)) * Math.PI * 2
			    : Math.toRadians((((time.hour * 60) + time.min)/4) - 180);
		    self.minute = time.min.format(time.min < 10 ? "%02d" : "%d");
		    self.minuteAngle = (time.min / 60.0) * Math.PI * 2;
		    self.second = time.sec.format(time.sec < 10 ? "%02d" : "%d");
		    self.secondAngle = (time.sec / 60.0) * Math.PI * 2;
		  }

		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  //
		  //                       VIEW HOOKS
		  //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //

		  public function onAppLoad() {
		  	//
		  }

		  public function onAlwaysOn(dc) {
		  	//
		  }

		  public function onReady(dc) {
		    //
		  }

		  public function onIteratePartial(dc) {
		    //
		  }

		  public function onIterate(dc) {
		    //
		  }

		  public function onSettingsReady(dc) {
		    //
		  }
		}
	}
}
