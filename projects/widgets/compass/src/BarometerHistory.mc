using Toybox.WatchUi;
using Keg.Barometer;
using Keg.Views;

class BarometerHistory extends Views.AbstractHistoryView
{
	public var page = 3;

  public function initialize() {
    Views.AbstractHistoryView.initialize();
  }

  public function onInitialize() {
    self.icon = WatchUi.loadResource(Rez.Drawables.BarometerIcon);
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
    return new $.Deviation();
  }

  public function previousView() {
    return new $.ElevationHistory();
  }
}
