using Keg.Barometer;
using Keg.I18n;
using Keg.Pixel;
using Keg.Views;

(:glance)
class Glance extends Views.AbstractGlanceView
{
  public var history = :getPressureHistory;
  public var historyColor = 0x0055FF;

  private var pressureFourth = 0;
  private var pressureSixteenth = 0;

  public function initialize() {
    Views.AbstractGlanceView.initialize();
  }

  public function onReady(dc) {
    self.title = I18n.t(:Barometer);

    self.pressureFourth = self.width/4.0;
    self.pressureSixteenth = self.width/16.0;
  }

  public function onIterate(dc) {
    var barometer = Barometer.getInfo();

    var pressurePercentage = 0;

    if (barometer.value != null) {
      if (barometer.value > 104500.0) {
        pressurePercentage = 1;
      } else if (barometer.value >= 97500.0 && barometer.value <= 104500.0) {
        pressurePercentage = ((barometer.value - 97500.0)/(104500.0 - 97500.0));
      }
    }

    self.sensor = barometer.asString();
    self.sensorUnits = barometer.unit;

    // Meter

    dc.setColor(0xFFFFFF, -1);
    dc.setPenWidth(Pixel.scale(1));
    dc.drawLine(0, self.plotY, self.width, self.plotY);

    dc.setPenWidth(Pixel.scale(2));
    dc.drawLine(1, self.plotY - Pixel.scale(5), 1, self.plotY + Pixel.scale(5));
    dc.drawLine(self.width - 1, self.plotY - Pixel.scale(5), self.width - 1, self.plotY + Pixel.scale(5));

    for (var i = 0; i < 4; ++i) {
      dc.drawLine(
        i * self.pressureFourth,
        self.plotY - Pixel.scale(3),
        i * self.pressureFourth,
        self.plotY + Pixel.scale(3)
      );
    }

    dc.setPenWidth(Pixel.scale(1));

    for (var i = 0; i < 16; ++i) {
      dc.drawLine(
        i * self.pressureSixteenth,
        self.plotY - Pixel.scale(2),
        i * self.pressureSixteenth,
        self.plotY + Pixel.scale(2)
      );
    }

    dc.setColor(0x0055FF, -1);
    dc.setPenWidth(Pixel.scale(5));
    dc.drawLine(
      self.width * (pressurePercentage <= 0 ? 0 : pressurePercentage) - (pressurePercentage >= .99 ? Pixel.scale(5) : 0),
      self.plotY - Pixel.scale(4),
      self.width * (pressurePercentage <= 0 ? 0 : pressurePercentage) - (pressurePercentage >= .99 ? Pixel.scale(5) : 0),
      self.plotY + Pixel.scale(4)
    );
  }
}
