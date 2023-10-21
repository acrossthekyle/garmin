using Toybox.WatchUi;

class WidgetController extends WatchUi.BehaviorDelegate
{
	public var view;

  public function initialize(view) {
    BehaviorDelegate.initialize();

    self.view = view;
  }

  public function onSelect() {
    if (!Keg.opened) {
      Keg.opened = true;

      self.view.method(:onSelect).invoke();

      var next = self.view.method(:selectView).invoke();

      if (next == null) {
        next = new $.Index();
      }

      if (next != false && next != null) {
        WatchUi.pushView(
          next,
          new $.WidgetController(next),
          0
        );
      }
    } else {
      self.view.method(:onTrigger).invoke();
    }

    return true;
  }

  public function onNextPage() {
    if (Keg.opened) {
      self.view.method(:onNavigate).invoke(:next);

      var handled = self.view.method(:onNext).invoke();

      if (!handled) {
        var next = self.view.method(:nextView).invoke();

        if (next != null) {
          WatchUi.switchToView(
            next,
            new $.WidgetController(next),
            0
          );
        }
      }
    }

    return Keg.opened;
  }

  public function onPreviousPage() {
    if (Keg.opened) {
      self.view.method(:onNavigate).invoke(:previous);

      var handled = self.view.method(:onPrevious).invoke();

      if (!handled) {
        var next = self.view.method(:previousView).invoke();

        if (next != null) {
          WatchUi.switchToView(
            next,
            new $.WidgetController(next),
            0
          );
        }
      }
    }

    return Keg.opened;
  }

  public function onBack() {
    Keg.opened = false;

    return self.view.method(:onExit).invoke();
  }
}
