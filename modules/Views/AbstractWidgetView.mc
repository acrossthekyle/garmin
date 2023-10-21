using Toybox.Application;
using Toybox.Math;
using Toybox.WatchUi;
using Keg.Pagination;

module Keg
{
	module Views
	{
		class AbstractWidgetView extends WatchUi.View
		{
			public var center = 0;
		  public var height = 0;
		  public var width = 0;

		  public var page = 1;

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

		    Pagination.reset();

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

		    Pagination.render(dc, self.page);

		    if (self.hasAntiAlias) {
		      dc.setAntiAlias(false);
		    }
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
		  //                 CONTROLLER HOOKS
		  //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //

		  public function onSelect() {
		    //
		  }

		  public function onPrevious() {
		    return false;
		  }

		  public function onNext() {
		    return false;
		  }

		  public function onExit() {
		  	return false;
		  }

		  public function onTrigger() {
		  	//
		  }

		  public function onNavigate(direction) {
		  	//
		  }

		  public function selectView() {
		  	return null;
		  }

		  public function nextView() {
		  	return null;
		  }

		  public function previousView() {
		  	return null;
		  }
		}
	}
}
