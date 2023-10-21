using Toybox.UserProfile;
using Keg.Heart;
using Keg.I18n;
using Keg.Pixel;
using Keg.Views;

(:glance)
class Glance extends Views.AbstractGlanceView
{
  public var history = :getHeartRateHistory;
  public var historyColor = 0xFF0000;

  public var sensorUnits = "BPM";

  private var zones = [];
  private var zonesFifth = 0;
  private var zonesWidth = 0;

  public function initialize() {
    Views.AbstractGlanceView.initialize();
  }

  public function onInitialize() {
    self.zones = UserProfile.getHeartRateZones(0);
  }

  public function onReady(dc) {
    self.title = I18n.t(:HeartRate);

    self.zonesFifth = self.width/5;
    self.zonesWidth = (self.width/5) - Pixel.scale(4);
  }

  public function onIterate(dc) {
    var heart = Heart.getInfo();

  	self.sensor = heart.asString();

    var zone = 0;

    if (heart.value != null) {
      if (heart.value >= self.zones[0] && heart.value < self.zones[1]) {
        zone = 1;
      } else if (heart.value >= self.zones[1] && heart.value < self.zones[2]) {
        zone = 2;
      } else if (heart.value >= self.zones[2] && heart.value < self.zones[3]) {
        zone = 3;
      } else if (heart.value >= self.zones[3] && heart.value < self.zones[4]) {
        zone = 4;
      } else if (heart.value >= self.zones[4]) {
        zone = 5;
      }
    }

  	for (var i = 0; i < 5; ++i) {
      if (i == 0 && (zone > 0 || (!self.sensor.equals("--") && zone < 1))) {
        dc.setColor(0xFF0000, -1);
      } else {
        if (zone > i) {
          dc.setColor(0xFF0000, -1);
        } else {
          dc.setColor(0x550000, -1);
        }
      }

      dc.fillRoundedRectangle(
        i * self.zonesFifth,
        self.plotY,
        self.zonesWidth,
        Pixel.scale(12),
        Pixel.scale(5)
      );
    }
  }
}
