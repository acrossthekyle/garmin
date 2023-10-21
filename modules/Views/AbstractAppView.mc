using Toybox.WatchUi;

module Keg
{
	module Views
	{
		class AbstractAppView extends WatchUi.View
		{
		  public var center = 0;
		  public var height = 0;
		  public var width = 0;

		  private var hasAntiAlias = true;

		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  //
		  //                    INSTANTIATION
		  //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //

		  public function initialize() {
		    View.initialize();

		    self.onInitialize();
		  }

		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  //
		  //                        ON LAYOUT
		  //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //

		  public function onLayout(dc) {
		  	self.width = dc.getWidth();
		    self.height = dc.getHeight();
		    self.center = self.width/2;

		    self.hasAntiAlias = dc has :setAntiAlias;

		    self.onReady(dc);
		  }

		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  //
		  //                        ON UPDATE
		  //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //

		  public function onUpdate(dc) {
		    View.onUpdate(dc);

		    if (self.hasAntiAlias) {
		    	dc.setAntiAlias(true);
		    }

		    // Reset the screen to a blank canvas
		    dc.clearClip();
		    dc.setColor(0x000000, 0x000000);
		    dc.fillRectangle(0, 0, self.width, self.height);

		    self.onIterate(dc);

		    if (self.hasAntiAlias) {
			    dc.setAntiAlias(false);
			  }
		  }

		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  //
		  //                        APP HOOKS
		  //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //

		  public function onSettingsChanged() {
		  	//
		  }

		  public function onTimer() {
		  	//
		  }

		  public function getTimerInterval() {
		  	return 1000;
		  }

		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  //
		  //                  LIFECYCLE HOOKS
		  //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //

		  public function onAppLoad() {
		  	//
		  }

		  public function onInitialize() {
		    //
		  }

		  public function onReady(dc) {
		    //
		  }

		  public function onIterate(dc) {
		    //
		  }

		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  //
		  //                 CONTROLLER HOOKS
		  //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //

		  public function onExit() {
		    return false;
		  }
		}
	}
}
