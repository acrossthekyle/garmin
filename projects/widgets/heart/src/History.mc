using Toybox.WatchUi;
using Keg.Heart;
using Keg.Views;

class History extends Views.AbstractHistoryView
{
  public function initialize() {
    Views.AbstractHistoryView.initialize();
  }

  public function onInitialize() {
    self.icon = WatchUi.loadResource(Rez.Drawables.HeaderIcon);
    self.type = :getHeartRateHistory;
    self.color = 0xFF0000;
    self.shade = 0x550000;
  }

  public function onIterate(dc) {
    self.current = Heart.getInfo().asString();
  }

  public function format(value) {
    return Heart.format(value);
  }

  public function nextView() {
    return new $.Resting();
  }

  public function previousView() {
    return new $.Index();
  }
}
