using Toybox.WatchUi;

class AppController extends WatchUi.BehaviorDelegate
{
	public var view;

  public function initialize(view) {
    BehaviorDelegate.initialize();

    self.view = view;
  }

  public function onBack() {
    return self.view.method(:onExit).invoke();
  }
}
