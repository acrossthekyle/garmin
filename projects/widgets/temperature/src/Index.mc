using Keg.Device;
using Keg.I18n;
using Keg.Pagination;
using Keg.Pixel;
using Keg.Setting;
using Keg.Temperature;
using Keg.Views;

var THERMOMETER_Y = 36;
var THERMOMETER_HEIGHT = 60;

class Index extends Views.AbstractWidgetView
{
  private var title = "";

  private var thermometerIcon = null;
  private var thermometerColdIcon = null;
  private var thermometerCoolIcon = null;
  private var thermometerWarmIcon = null;
  private var thermometerHotIcon = null;

  public function initialize() {
    Views.AbstractWidgetView.initialize();
  }

  public function onAppLoad() {
    Pagination.setPages(2);
  }

  public function onReady(dc) {
    self.title = I18n.t(:Temperature).toUpper();

    self.thermometerIcon = new Rez.Drawables.Thermometer();
    self.thermometerColdIcon = new Rez.Drawables.ThermometerCold();
    self.thermometerCoolIcon = new Rez.Drawables.ThermometerCool();
    self.thermometerWarmIcon = new Rez.Drawables.ThermometerWarm();
    self.thermometerHotIcon = new Rez.Drawables.ThermometerHot();
  }

  public function onIterate(dc) {
    var temperature = Temperature.getInfo();

    var icon = :cold;
    var percentage = 0;

    if (temperature.isCore) {
    	if (temperature.value > 37.5) {
        icon = :hot;
      } else if (temperature.value > 35.0 && temperature.value <= 37.5) {
        icon = :warm;
      }

      percentage = temperature.value/42.2222;
    } else {
    	if (temperature.value > 0 && temperature.value <= 15.5556) {
        icon = :cool;
      } else if (temperature.value > 15.5556 && temperature.value <= 32.2222) {
        icon = :warm;
      } else if (temperature.value > 32.2222) {
        icon = :hot;
      }

      percentage = temperature.value/48.8889;
    }

    self.setThermometerY(percentage);

    self.thermometerIcon.draw(dc);

    if (icon == :cold) {
      self.thermometerColdIcon.draw(dc);
    } else if (icon == :cool) {
      self.thermometerCoolIcon.draw(dc);
    } else if (icon == :warm) {
      self.thermometerWarmIcon.draw(dc);
    } else if (icon == :hot) {
      self.thermometerHotIcon.draw(dc);
    }

    dc.setColor(0xFFAA55, -1);
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
      temperature.asString(),
      1 | 4
    );

    dc.drawText(
      self.center + (dc.getTextWidthInPixels(temperature.asString(), 15)/2) + Pixel.scale(2),
      Pixel.scale(203),
      11,
      "°" + temperature.unit,
      2 | 4
    );
  }

  private function setThermometerY(percentage) {
    var top = 24;
    var bottom = 80;

    if (self.width == 218) {
      top = 24;
      bottom = 80;
    } else if (self.width == 240) {
      top = 39;
      bottom = 95;
    } else if (self.width == 260) {
      top = 36;
      bottom = 96;
    } else if (self.width == 280) {
      top = 41;
      bottom = 108;
    } else if (self.width == 360) {
      top = 40;
      bottom = 136;
    } else if (self.width == 390) {
      top = 47;
      bottom = 147;
    } else if (self.width == 416) {
      top = 53;
      bottom = 158;
    } else if (self.width == 454) {
      top = 53;
      bottom = 158;
    }

    $.THERMOMETER_Y = (bottom - ((bottom - top) * percentage));
    $.THERMOMETER_HEIGHT = (bottom - $.THERMOMETER_Y) + 15;
  }

  public function nextView() {
    return new $.History();
  }

  public function previousView() {
    return new $.History();
  }
}
