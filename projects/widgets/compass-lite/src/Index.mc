using Keg.Compass;
using Keg.Compass.Abc;
using Keg.Compass.Dial;
using Keg.Pagination;
using Keg.Setting;
using Keg.Views;

class Index extends Views.AbstractWidgetView
{
  public function initialize() {
    Views.AbstractWidgetView.initialize();
  }

  public function onAppLoad() {
    Pagination.setPages(0);
  }

  public function onIterate(dc) {
    var compass = Compass.getInfo();

    Abc.render(dc, compass.asString());

    Dial.render(dc, compass.degrees);
  }

  public function getTimerInterval() {
    return [100, 250, 500, 1000][Setting.getValue("Compass_RefreshRate", 3)];
  }

  public function selectView() {
    return false;
  }
}
