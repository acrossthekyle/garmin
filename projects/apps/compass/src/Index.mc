using Keg.Compass;
using Keg.Compass.Abc;
using Keg.Compass.Dial;
using Keg.Setting;
using Keg.Views;

class Index extends Views.AbstractAppView
{
  public function initialize() {
    Views.AbstractAppView.initialize();
  }

  public function onIterate(dc) {
    var compass = Compass.getInfo();

    Abc.render(dc, compass.asString());

    Dial.render(dc, compass.degrees);
  }

  public function getTimerInterval() {
    return [100, 250, 500, 1000][Setting.getValue("Compass_RefreshRate", 3)];
  }
}
