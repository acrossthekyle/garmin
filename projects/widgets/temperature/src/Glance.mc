using Keg.Device;
using Keg.I18n;
using Keg.Pixel;
using Keg.Setting;
using Keg.Temperature;
using Keg.Views;

(:glance)
class Glance extends Views.AbstractGlanceView
{
  public var history = :getTemperatureHistory;
  public var historyColor = 0xFFAA00;

  public function initialize() {
    Views.AbstractGlanceView.initialize();
  }

  public function onReady(dc) {
    self.title = I18n.t(:Temperature);
  }

  public function onIterate(dc) {
    var temperature = Temperature.getInfo();

    self.sensor = temperature.asString();
    self.sensorUnits = "°" + temperature.unit;

    var icon = :cold;
    var thermometerColor = 0xFFFFFF;
    var thermometerPercentage = 1;

    if (temperature.isCore) {
      if (temperature.value > 37.5) {
        thermometerColor = 0xFF0000;
      } else if (temperature.value > 35.0 && temperature.value <= 37.5) {
        thermometerColor = 0xFFAA00;
      } else if (temperature.value <= 35.0) {
        thermometerColor = 0x00AAFF;
      }

      thermometerPercentage = temperature.value/42.2222;
    } else {
      if (temperature.value <= 0) {
        thermometerColor = 0x00AAFF;
      } else if (temperature.value > 0 && temperature.value <= 15.5556) {
        thermometerColor = 0x00AA00;
      } else if (temperature.value > 15.5556 && temperature.value <= 32.2222) {
        thermometerColor = 0xFFAA00;
      } else if (temperature.value > 32.2222) {
        thermometerColor = 0xFF0000;
      }

      thermometerPercentage = temperature.value/48.8889;
    }

    // Meter
  	dc.setColor(0x555555, -1);
    dc.fillRoundedRectangle(
      0,
      self.plotY,
      self.width,
      Pixel.scale(8),
      Pixel.scale(5)
    );

    dc.setColor(thermometerColor, -1);
    dc.fillRoundedRectangle(
      0,
      self.plotY,
      self.width * (thermometerPercentage <= 0 ? 0 : thermometerPercentage),
      Pixel.scale(8),
      Pixel.scale(5)
    );
  }
}
