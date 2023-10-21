using Toybox.Lang;
using Toybox.UserProfile;
using Toybox.WatchUi;
using Keg.Heart;
using Keg.Heart.Variability;
using Keg.I18n;
using Keg.Pixel;
using Keg.Utilities.Circle;
using Keg.Views;

public function onSensorData(data) {
  Variability.setData(data);
}

class Index extends Views.AbstractWidgetView
{
  private var title = "";

  private var zones = null;
  private var zonesIcon = null;

  public function initialize() {
    Views.AbstractWidgetView.initialize();
  }

  public function onReady(dc) {
    self.title = I18n.t(:HeartRate).toUpper();

    self.zones = UserProfile.getHeartRateZones(0);
    self.zonesIcon = WatchUi.loadResource(Rez.Drawables.ZoneIcon);
  }

  public function onIterate(dc) {
    var heartRate = Heart.getInfo();

    if (self.zonesIcon != null) {
      dc.drawBitmap(
        self.center - self.zonesIcon.getWidth()/2,
        self.center - Pixel.scale(50) - self.zonesIcon.getHeight()/2,
        self.zonesIcon
      );
    }

    var zone = 0;

    if (heartRate.value != null) {
      if (heartRate.value >= self.zones[0] && heartRate.value < self.zones[1]) {
        zone = 1;
      } else if (heartRate.value >= self.zones[1] && heartRate.value < self.zones[2]) {
        zone = 2;
      } else if (heartRate.value >= self.zones[2] && heartRate.value < self.zones[3]) {
        zone = 3;
      } else if (heartRate.value >= self.zones[3] && heartRate.value < self.zones[4]) {
        zone = 4;
      } else if (heartRate.value >= self.zones[4]) {
        zone = 5;
      }
    }

    var arcRadii = Pixel.scale(55);
    var arcCenterOffset = Pixel.scale(52);
    var arcEndCapRadii = Pixel.scale(6);

    dc.setPenWidth(Pixel.scale(13));

    var arcStart = 258;
    var arcStop = 210;

    var arcFillStart = 102;
    var arcFillStop = 150;

    for (var i = 0; i < 5; ++i) {
      if (i == 0 && (zone > 0 || (heartRate.value != null && zone < 1))) {
        dc.setColor(0xFF0000, -1);
      } else {
        if (zone > i) {
          dc.setColor(0xFF0000, -1);
        } else {
          dc.setColor(0x550000, -1);
        }
      }

      dc.drawArc(
        self.center,
        self.center - arcCenterOffset,
        arcRadii,
        1,
        arcStart,
        arcStop
      );

      dc.fillCircle(
        Circle.calculateRadialPoint(
          self.center,
          (arcFillStart > 360 ? arcFillStart - 360 : arcFillStart),
          arcRadii,
          :xc
        ),
        Circle.calculateRadialPoint(
          self.center - arcCenterOffset,
          (arcFillStart > 360 ? arcFillStart - 360 : arcFillStart),
          arcRadii,
          :yc
        ),
        arcEndCapRadii
      );

      dc.fillCircle(
        Circle.calculateRadialPoint(
          self.center,
          (arcFillStop > 360 ? arcFillStop - 360 : arcFillStop),
          arcRadii,
          :xc
        ),
        Circle.calculateRadialPoint(
          self.center - arcCenterOffset,
          (arcFillStop > 360 ? arcFillStop - 360 : arcFillStop),
          arcRadii,
          :yc
        ),
        arcEndCapRadii
      );

      arcStart -= 72;
      arcStop -= 72;

      arcFillStart += 72;
      arcFillStop += 72;
    }

    dc.setColor(0xFF0000, -1);
    dc.drawText(
      self.center,
      Pixel.scale(167),
      11,
      self.title,
      1 | 4
    );

    dc.setColor(0xFFFFFF, -1);
    dc.drawText(
      self.center,
      Pixel.scale(203),
      15,
      heartRate.asString(),
      1 | 4
    );
    dc.drawText(
      self.center,
      Pixel.scale(239),
      10,
      "bpm",
      1 | 4
    );
  }

  public function onAppLoad() {
    Pagination.setPages(4);

    if (
      Toybox has :Sensor &&
      Toybox.Sensor has :HeartRateData &&
      Toybox.Sensor has :registerSensorDataListener
    ) {
      Toybox.Sensor.registerSensorDataListener(new Lang.Method($, :onSensorData), {
        :period => 4,
        :heartBeatIntervals => {
          :enabled => true
        }
      });
    }
  }

  public function nextView() {
    return new $.History();
  }

  public function previousView() {
    return new $.Hrv();
  }
}
