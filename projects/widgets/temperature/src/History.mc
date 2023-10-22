using Toybox.WatchUi;
using Keg.Temperature;
using Keg.Views;

class History extends Views.AbstractHistoryView
{
  public function initialize() {
    Views.AbstractHistoryView.initialize();
  }

  public function onInitialize() {
    self.icon = WatchUi.loadResource(Rez.Drawables.HeaderIcon);
    self.type = :getTemperatureHistory;
    self.color = 0xFFAA00;
    self.shade = 0xAA5500;
  }

  public function onIterate(dc) {
    self.current = Temperature.getInfo().asString();
  }

  public function format(value) {
    if (Temperature.shouldBeConvertedToCore()) {
      value = Temperature.toCore(value);
    }

    return Temperature.format(value);
  }

  public function nextView() {
    return new $.Index();
  }

  public function previousView() {
    return new $.Index();
  }
}
