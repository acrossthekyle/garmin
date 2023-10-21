using Toybox.Time;
using Keg.Clock;
using Keg.Gps;
using Keg.I18n;
using Keg.Pixel;
using Keg.Setting;
using Keg.Sun;
using Keg.Sun.Twilight;
using Keg.Views;

(:glance)
class Glance extends Views.AbstractGlanceView
{
  private var location = null;
  private var locationInvalid = "";
  private var locationRequired = "";

  private var sunset = "";
  private var sunrise = "";

  private var minutesPerPixel = 0;
  private var markerY = 0;

  public function initialize() {
    Views.AbstractGlanceView.initialize();
  }

  public function onGlanceLoad() {
    self.location = Gps.locate(
      Setting.getValue("GPS_Enabled", true),
      [
        Setting.getValue("GPS_Latitude", 0.0),
        Setting.getValue("GPS_Longitude", 0.0)
      ]
    );
  }

  public function onReady(dc) {
  	self.title = I18n.t(:SunTimes);

  	self.locationInvalid = I18n.t(:Location_InvalidShort);
    self.locationRequired = I18n.t(:Location_RequiredShort);
    self.sunset = I18n.t(:SunTimes_SunsetIn);
    self.sunrise = I18n.t(:SunTimes_SunriseIn);

  	self.minutesPerPixel = self.width/1440.0;
    self.markerY = self.plotY + Pixel.scale(10);
  }

  public function onIterate(dc) {
  	self.sensor = null;
  	self.sensorUnits = null;

    var clock = Clock.getInfo();
    var sun = Sun.getInfo(self.location.radians, Time.now());
    var twilight = Twilight.getInfo(self.location.radians, Time.now(), Setting.getValue("Twilight_Level", 2));

  	if (self.location.acquiring == true) {
      self.title = I18n.t(:SunTimes);
  		self.sensorUnits = self.locationRequired.toUpper();
    } else if (self.location.error == true) {
      self.title = I18n.t(:SunTimes);
  		self.sensorUnits = self.locationInvalid.toUpper();
    } else if (self.location.located == true) {
      self.title = ((sun.nextEvent.event == :sunrise ? self.sunrise : self.sunset) + " " + sun.nextEvent.asString()).toUpper();
    	self.sensor = sun.sunrise.asString();
    }

  	if (self.location.located == true) {
      dc.setColor(0xFFFFFF, -1);
  	  dc.drawText(
  	    self.width,
  	    self.height - self.numericFontAscent - Pixel.scale(2),
  	    19,
        sun.sunset.asString(),
  	    0
  	  );
  	}

    // Meter
  	dc.setColor(0x0055AA, -1);
    dc.fillRoundedRectangle(
      0,
      self.plotY,
      self.width,
      Pixel.scale(8),
      Pixel.scale(3)
    );

    if (self.location.located == true) {
    	dc.setColor(0xAA5500, -1);
      dc.fillRoundedRectangle(
        self.minutesPerPixel * ((twilight.dawn.hour * 60) + twilight.dawn.minute),
        self.plotY,
        ((self.minutesPerPixel * ((twilight.dusk.hour * 60) + twilight.dusk.minute)) - (self.minutesPerPixel * ((twilight.dawn.hour * 60) + twilight.dawn.minute))),
        Pixel.scale(8),
        Pixel.scale(3)
      );

      dc.setColor(0xFFAA00, -1);
      dc.fillRoundedRectangle(
        self.minutesPerPixel * ((sun.sunrise.hour * 60) + sun.sunrise.minute),
        self.plotY,
        ((self.minutesPerPixel * ((sun.sunset.hour * 60) + sun.sunset.minute)) - (self.minutesPerPixel * ((sun.sunrise.hour * 60) + sun.sunrise.minute))),
        Pixel.scale(8),
        Pixel.scale(3)
      );

      var markerX = self.minutesPerPixel * clock.minutesSinceMidnight;

      dc.setColor(0xFFFFFF, -1);
      dc.fillPolygon([
        [markerX, self.markerY],
        [markerX + Pixel.scale(6), self.markerY + Pixel.scale(6)],
        [markerX - Pixel.scale(6), self.markerY + Pixel.scale(6)]
      ]);
    }
  }
}
