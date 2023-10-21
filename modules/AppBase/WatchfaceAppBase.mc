using Toybox.Application;
using Toybox.WatchUi;

class App extends Application.AppBase
{
  public var view = null;

	public function initialize() {
    AppBase.initialize();
  }

  public function getInitialView() {
    self.view = new $.Index();

		self.view.method(:onAppLoad).invoke();

    return [self.view, new $.WatchfaceController(self.view)];
	}

  public function onSettingsChanged() {
    self.view.method(:onSettingsChanged).invoke();

    WatchUi.requestUpdate();
  }
}
