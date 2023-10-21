using Toybox.Application;
using Toybox.System;
using Toybox.Timer;
using Toybox.WatchUi;

(:glance {{annotation}})
class App extends Application.AppBase
{
	private var view = null;
	private var timer = null;
	private var timerInterval = 1000;

  public function initialize() {
    AppBase.initialize();
  }

  public function getInitialView() {
    if ($ has :BackgroundService) {
  		Toybox.Background.registerForTemporalEvent(new Toybox.Time.Duration(3600));
  	}

		var settings = System.getDeviceSettings();

    if (settings has :isGlanceModeEnabled && settings.isGlanceModeEnabled) {
      Keg.opened = true;
    }

    settings = null;

		self.view = new $.Index();

		self.timerInterval = self.view.method(:getTimerInterval).invoke();

		self.timer = new Timer.Timer();
    self.timer.start(
      self.method(:onTimer),
      self.timerInterval,
      true
    );

    self.view.method(:onAppLoad).invoke();

    return [self.view, new $.WidgetController(self.view)];
	}

  public function getGlanceView() {
    var glance = new $.Glance();

    self.timerInterval = glance.method(:getTimerInterval).invoke();

    self.timer = new Timer.Timer();
    self.timer.start(
      self.method(:onTimer),
      self.timerInterval,
      true
    );

    glance.method(:onGlanceLoad).invoke();

    return [glance];
  }

  public function getServiceDelegate() {
  	if ($ has :BackgroundService) {
  		return [new $.BackgroundService()];
  	}

    return false;
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

    if (self.view != null) {
      self.view.method(:onSettingsChanged).invoke();
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
    if (self.view != null) {
      self.view.method(:onTimer).invoke();
    }

    WatchUi.requestUpdate();
  }
}
