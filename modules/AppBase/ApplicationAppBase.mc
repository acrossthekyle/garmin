using Toybox.Application;
using Toybox.Timer;
using Toybox.WatchUi;

class App extends Application.AppBase
{
	private var timer = null;
	private var timerInterval = 1000;

  public function initialize() {
    AppBase.initialize();
  }

  public function getInitialView() {
    var view = new $.Index();

		self.timerInterval = view.method(:getTimerInterval).invoke();

		self.timer = new Timer.Timer();
    self.timer.start(
      self.method(:onTimer),
      self.timerInterval,
      true
    );

    view.method(:onAppLoad).invoke();

    return [view, new $.AppController(view)];
	}

  public function onSettingsChanged() {
    if (self.timer != null) {
      self.timer.stop();
      self.timer.start(
      	self.method(:onTimer),
      	self.timerInterval,
      	true
      );
    }

    WatchUi.requestUpdate();
  }

  public function onStop(state) {
    if (self.timer != null) {
      self.timer.stop();
      self.timer = null;
    }
  }

  public function onTimer() {
    WatchUi.requestUpdate();
  }
}
