using Toybox.WatchUi;
using Keg.Altitude;
using Keg.Views;

class ElevationHistory extends Views.AbstractHistoryView
{
	public var page = 2;

  public function initialize() {
    Views.AbstractHistoryView.initialize();
  }

  public function onInitialize() {
    self.icon = WatchUi.loadResource(Rez.Drawables.ElevationIcon);
    self.type = :getElevationHistory;
    self.color = 0x55FF00;
    self.shade = 0x005500;
  }

  public function onIterate(dc) {
    self.current = Altitude.getInfo().asString();
  }

  public function format(value) {
    return Altitude.format(value);
  }

  public function nextView() {
    return new $.BarometerHistory();
  }

  public function previousView() {
    return new $.Index();
  }
}
