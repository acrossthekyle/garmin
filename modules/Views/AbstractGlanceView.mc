using Toybox.Graphics;
using Toybox.Lang;
using Toybox.Math;
using Toybox.System;
using Toybox.WatchUi;
using Keg.History;
using Keg.Pixel;

module Keg
{
	module Views
	{
		(:glance)
		class AbstractGlanceView extends WatchUi.GlanceView
		{
			public var center = 0;
		  public var height = 0;
		  public var width = 0;

		  public var screenWidth = 260;

			public var alphaFontAscent = 0;
		  public var alphaFontDescent = 0;
		  public var alphaFontHeight = 0;

		  public var numericFontAscent = 0;
		  public var numericFontDescent = 0;
		  public var numericFontHeight = 0;

		  public var plotY = 0;

		  public var historyTop = 0;
		  public var historyMiddle = 0;
		  public var historyHeight = 0;

		  public var title = "";
		  public var sensor = "";
		  public var sensorUnits = null;

		  public var history = null;
		  public var historyColor = null;

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
		    GlanceView.initialize();

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

		    self.screenWidth = System.getDeviceSettings().screenWidth;

		    self.alphaFontAscent = Graphics.getFontAscent(18);
		    self.alphaFontDescent = Graphics.getFontDescent(18);
		    self.alphaFontHeight = dc.getFontHeight(18);

		    self.numericFontAscent = Graphics.getFontAscent(19);
		    self.numericFontDescent = Graphics.getFontDescent(19);
		    self.numericFontHeight = dc.getFontHeight(19);

		    self.plotY = ((self.alphaFontAscent - self.alphaFontDescent) + ((self.height - self.numericFontAscent + self.numericFontDescent - 1) - (self.alphaFontAscent - self.alphaFontDescent))/2);

		    self.historyTop = self.plotY + Pixel.scale(12);
		    self.historyMiddle = self.historyTop + (self.height - self.historyTop)/2;
		    self.historyHeight = self.height - self.historyTop;

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
		    GlanceView.onUpdate(dc);

		    if (self.hasAntiAlias) {
		      dc.setAntiAlias(true);
		    }

		    // Reset the screen to a blank canvas
		    dc.clearClip();
		    dc.setColor(0x000000, 0x000000);
		    dc.fillRectangle(0, 0, self.width, self.height);

		    self.onIterate(dc);

		    // // // // // // // // // // // //
			  // // // // // // // // // // // //
			  // // // // // // // // // // // //
			  //
			  //                            TITLE
			  //
			  // // // // // // // // // // // //
			  // // // // // // // // // // // //
			  // // // // // // // // // // // //

		    dc.setColor(0xFFFFFF, -1);
		    dc.drawText(
		      0,
		      0 - self.alphaFontDescent + Pixel.scale(2),
		      18,
		      self.title.toUpper(),
		      2
		    );

		    // // // // // // // // // // // //
		    // // // // // // // // // // // //
		    // // // // // // // // // // // //
		    //
		    //                   SENSOR READING
		    //
		    // // // // // // // // // // // //
		    // // // // // // // // // // // //
		    // // // // // // // // // // // //

		    if (self.sensor != null) {
		      dc.drawText(
		        0,
		        self.height - self.numericFontAscent - Pixel.scale(2),
		        19,
		        self.sensor,
		        2
		      );
		    }

		    // // // // // // // // // // // //
		    // // // // // // // // // // // //
		    // // // // // // // // // // // //
		    //
		    //                     SENSOR UNITS
		    //
		    // // // // // // // // // // // //
		    // // // // // // // // // // // //
		    // // // // // // // // // // // //

		    if (self.screenWidth > 240 && self.sensorUnits != null) {
		      dc.drawText(
		        self.sensor == null ? 0 : (dc.getTextWidthInPixels(self.sensor, 19) + Pixel.scale(5)),
		        self.height - self.alphaFontAscent - Pixel.scale(2),
		        18,
		        self.sensorUnits,
		        2
		      );
		    }

		    // // // // // // // // // // // //
		    // // // // // // // // // // // //
		    // // // // // // // // // // // //
		    //
		    //                          HISTORY
		    //
		    // // // // // // // // // // // //
		    // // // // // // // // // // // //
		    // // // // // // // // // // // //

		    if (self.history != null) {
		      dc.setColor(self.historyColor, -1);
		      dc.setPenWidth(Pixel.scale(2));

		      var history = History.getHistory(
		        self.history,
		        Math.floor(
		          self.width - (
		            dc.getTextWidthInPixels(
		              self.sensor,
		              19
		            ) +
		            Pixel.scale(5) +
		            (
		              dc.getTextWidthInPixels(self.sensorUnits, 18) + Pixel.scale(5)
		            )
		          )
		        ).toNumber()
		      );

		      if (history != null) {
		        var historyMinimum = history.getMin();
		        var historyMaximum = history.getMax();

		        if (historyMinimum == null) {
		          historyMinimum = 0;
		        }

		        if (historyMaximum == null) {
		          historyMaximum = 0;
		        }

		        var historyR = historyMaximum - historyMinimum;
		        var historyLastPoint = null;
		        var historyX = width;

		        while (true) {
		          var next = history.next();

		          if (next != null) {
		            var value = 0.0;

		            if (next.data != null) {
		              value = next.data.toFloat();
		            }

		            var y = self.height;

		            if (value > 0) {
		              /* Scale value to fit graph area */
		              y = (
		                historyR > 0
		                  ? self.height - ((self.historyHeight - 0.0000000) * (value - historyMinimum) / historyR + 0.0000000)
		                  : self.historyMiddle
		                );

		              y = ((0.5 * y) + (0.5 * self.historyMiddle));
		            }

		            if (historyLastPoint != null) {
		              historyX -= 1;
		            }

		            if (historyLastPoint != null) {
		              dc.drawLine(
		                historyX,
		                y,
		                historyLastPoint[0],
		                historyLastPoint[1]
		              );
		            }

		            historyLastPoint = [historyX, y];
		          } else {
		            break;
		          }
		        }
		      }
		    }

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

		  public function onGlanceLoad() {
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

		  public function getTimerInterval() {
		  	return 1000;
		  }
		}
	}
}
