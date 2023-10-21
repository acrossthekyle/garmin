using Toybox.System;
using Toybox.WatchUi;

module Keg
{
	module Views
	{
		class AbstractDataFieldView extends WatchUi.DataField
		{
		  public var center = 0;
		  public var height = 0;
		  public var width = 0;

		  public var deviceHeight = 0;
		  public var deviceWidth = 0;

		  public var computedInfo = null;

		  private var canRender = true;

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
		    DataField.initialize();

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
		  	// Width and Height of the data field size chosen by the user
		    self.width = dc.getWidth();
		    self.height = dc.getHeight();

		    self.center = self.width/2;

		    var settings = System.getDeviceSettings();

		    // Width and Height of the screen size
		    self.deviceHeight = settings.screenHeight;
		    self.deviceWidth = settings.screenWidth;

		    // If the data field size chosen by the user is not the entire
		    // size of the screen then do not render the data field.
		    if (self.width < self.deviceWidth || self.height < self.deviceHeight) {
		      self.canRender = false;
		    } else {
		      self.canRender = true;
		    }

		    self.hasAntiAlias = dc has :setAntiAlias;

		    self.onReady(dc);
		  }

		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  //
		  //                       ON COMPUTE
		  //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //

		  public function compute(info) {
		    self.computedInfo = info;
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

		    if (!self.canRender) {
		      dc.setColor(0xFFFFFF, -1);
		      dc.drawText(self.center, self.center, 16, "-", 1 | 4);

		      return;
		    }

		    self.onIterate(dc);

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
		}
	}
}
