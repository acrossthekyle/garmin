using Toybox.Application;
using Toybox.WatchUi;

class App extends Application.AppBase
{
  public function initialize() {
    AppBase.initialize();
  }

  public function getInitialView() {
    var view = new $.Index();

		view.method(:onAppLoad).invoke();

    return [view];
	}

  public function onSettingsChanged() {
    WatchUi.requestUpdate();
  }
}
