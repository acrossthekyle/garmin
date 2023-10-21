using Toybox.WatchUi;

class WatchfaceController extends WatchUi.WatchFaceDelegate
{
	public var view;

  public function initialize(view) {
    WatchFaceDelegate.initialize();

    self.view = view;
  }

  public function onPowerBudgetExceeded(info) {
    self.view.onPowerBudgetExceeded();
  }
}
