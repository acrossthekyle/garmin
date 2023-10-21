using Toybox.WatchUi;
using Keg.Altitude;
using Keg.Views;

class ElevationHistory extends Views.AbstractHistoryView
{
  public function initialize() {
    Views.AbstractHistoryView.initialize();
  }

  public function onInitialize() {
    self.icon = WatchUi.loadResource(Rez.Drawables.HeaderIcon);
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
    return new $.AscentDescent();
  }

  public function previousView() {
    return new $.Index();
  }
}
