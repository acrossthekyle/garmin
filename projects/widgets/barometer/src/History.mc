using Toybox.WatchUi;
using Keg.Barometer;
using Keg.Views;

class History extends Views.AbstractHistoryView
{
  public function initialize() {
    Views.AbstractHistoryView.initialize();
  }

  public function onInitialize() {
    self.icon = WatchUi.loadResource(Rez.Drawables.HeaderIcon);
    self.type = :getPressureHistory;
    self.color = 0x0055FF;
    self.shade = 0x000055;
  }

  public function onIterate(dc) {
    self.current = Barometer.getInfo().asString();
  }

  public function format(value) {
    return Barometer.format(value);
  }

  public function nextView() {
    return new $.Index();
  }

  public function previousView() {
    return new $.Index();
  }
}
