using Toybox.Lang;
using Toybox.Math;
using Toybox.Time;
using Toybox.WatchUi;
using Keg.I18n;
using Keg.Fonts;
using Keg.History;
using Keg.Pagination;
using Keg.Pixel;
using Keg.Setting;

module Keg
{
	module Views
	{
		class AbstractHistoryView extends WatchUi.View
		{
		  public var center = 0;
		  public var height = 0;
		  public var width = 0;

		  public var icon = null;
		  public var type = null;
		  public var color = null;
		  public var shade = null;

		  public var page = 2;

		  public var current = null;

		  private var hasAntiAlias = true;

		  private var i18nMax = "";
		  private var i18nMin = "";
		  private var i18nSpan = "";

		  private var columns = 52;

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

		    self.i18nMax = I18n.t(:History_Max);
		    self.i18nMin = I18n.t(:History_Min);
		    self.i18nSpan = I18n.t(:History_Span);

		    if (self.width == 454) {
          self.columns = 75;
        } else if (self.width == 390) {
          self.columns = 65;
        } else if (self.width == 360) {
          self.columns = 60;
        } else if (self.width == 280) {
          self.columns = 56;
        } else if (self.width == 240) {
          self.columns = 48;
        } else if (self.width == 218) {
          self.columns = 43;
        }

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

		    // Reset the screen to a blank canvas
		    dc.clearClip();
		    dc.setColor(0x000000, 0x000000);
		    dc.fillRectangle(0, 0, self.width, self.height);

		    if (self.hasAntiAlias) {
		      dc.setAntiAlias(true);
		    }

		    if (self.icon != null) {
		      dc.drawBitmap(
		        self.center - self.icon.getWidth()/2,
		        Pixel.scale(15) - self.icon.getHeight()/2,
		        self.icon
		      );
		    }

		    self.onIterate(dc);

		    if (self.current != null) {
		      dc.setColor(0xFFFFFF, -1);
		      dc.drawText(
		        self.center,
		        Pixel.scale(50),
		        15,
		        self.current,
		        1 | 4
		      );
		    }

		    /* Bottom (y) of graphing area */
		    var bottom = Pixel.scale(216.0000000);

		    /* Middle (y) of graphing area */
		    var middle = Pixel.scale(148.0000000);

		    /* Top (y) of graphing area */
		    var top = Pixel.scale(80.0000000);

		    /* Height (y) of graphing area */
		    var height = Pixel.scale(135.0000000);

		    /* Minimum/Maximum */
		    var minimumX = self.width;
		    var minimumY = top;

		    var maximumX = self.width;
		    var maximumY = bottom;

		    var smooth = Setting.getValue("History_AlphaWeightEnabled", true);

		    var history = History.getHistory(self.type, self.width);

		    if (history != null) {
		      /* Number of hours */
		      var span = Math.floor((Time.now().value() - (history.getOldestSampleTime() || Time.now()).value())/60/60);

		      var minimum = history.getMin();
		      var maximum = history.getMax();

		      if (minimum == null) {
		        minimum = 0;
		      }

		      if (maximum == null) {
		        maximum = 0;
		      }

	        var thickness = self.width/self.columns;

	        /* Overall data size */
	        var size = 0;

	        var data = [];

	        while (true) {
	          var next = history.next();

	          if (next != null) {
	            data.add(next.data != null && next.when != null ? next.data.toFloat() : 0.0);

	            ++size;
	          } else {
	            break;
	          }
	        }

	        var n = self.columns;
	        var j = 0;
	        var r = maximum - minimum;

	        while (true) {
	          if (j < size) {
	            if (n == 0) {
	              n = 1;
	            }

	            /* Size of each chunk of data */
	            var chunk = Math.ceil(((size - j) / n.toFloat())).toNumber(),
	                /* Total value for this chunk */
	                sum = 0,
	                /* Default Y value */
	                y = bottom;

	            for (var i = 0; i < chunk; ++i) {
	              sum += data[j + i];
	            }

	            var value = (sum/chunk).toFloat();

	            if (value > 0) {
	              /* Scale value to fit graph area */
	              y = (
	                r > 0
	                  ? bottom - ((height - 0.0000000) * (value - minimum) / r + 0.0000000)
	                  : middle
	                );

	              if (smooth == true) {
	                /* Weight value to appear more evenly distributed vertically */
	                y = ((0.5 * y) + (0.5 * middle));
	              }

	              /* Adhere to limits */
	              if (y >= bottom) {
	                y = bottom;
	              } else if (y <= top) {
	                y = top;
	              }
	            }

	            var x = Math.floor((n * thickness) - thickness);

	            if (y < bottom) {
	              if (y < maximumY) {
	                maximumY = y;
	                maximumX = x - thickness/2;
	              } else if (y > minimumY) {
	                minimumY = y;
	                minimumX = x - thickness/2;
	              }
	            }

	            dc.setColor(self.color, -1);
	            dc.fillRectangle(
	              x,
	              y,
	              thickness,
	              self.width
	            );

	            dc.setColor(0x000000, -1);
	            dc.drawLine(
	              x,
	              y,
	              x,
	              self.width
	            );

	            j += chunk;

	            n -= 1;
	          } else {
	            break;
	          }
	        }

		      minimum = self.format(minimum);
		      maximum = self.format(maximum);

		      /* If variation exists */
		      if (minimum.equals(maximum) == false) {
		        self.renderExtremes(
		          dc,
		          maximumX,
		          maximumY,
		          maximum,
		          minimumX,
		          minimumY,
		          minimum
		        );
		      }

		      /* Number of hours */
		      dc.setColor(0xFFFFFF, -1);
		      dc.drawText(
		        self.center,
		        Pixel.scale(233),
		        9,
		        Lang.format(
		          self.i18nSpan,
		          [span <= 0 ? 1 : span]
		        ),
		        1 | 4
		      );
		    }

		    Pagination.render(dc, self.page);

		    if (self.hasAntiAlias) {
		      dc.setAntiAlias(false);
		    }
		  }

		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  //
		  //                   RENDER MIN/MAX
		  //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //
		  // // // // // // // // // // // //

		  private function renderExtremes(dc, maxX, maxY, max, minX, minY, min) {
			  /* Text height corrections */
			  var extraTinyAdjustments = Fonts.getAdjustments(:extraTiny);
			  var smallAdjustments = Fonts.getAdjustments(:small);

			  var extraTinyAscent = extraTinyAdjustments.ascent;
			  var smallAscent = smallAdjustments.ascent;

			  extraTinyAscent = Graphics.getFontAscent(9) + extraTinyAscent;
			  smallAscent = Graphics.getFontAscent(11) + smallAscent;

			  var lha = extraTinyAscent - Graphics.getFontDescent(9);
			  var lpt = dc.getFontHeight(9) - extraTinyAscent;

			  var lwma = dc.getTextWidthInPixels(self.i18nMax, 9);
			  var lwmi = dc.getTextWidthInPixels(self.i18nMin, 9);

			  var vha = (smallAscent - Graphics.getFontDescent(11));
			  var vpt = (dc.getFontHeight(11) - smallAscent);

			  var bump = null;

			  /* If [x, y] is outside of the viewable area */
			  /* https://stackoverflow.com/a/34185898 */
			  if (((Math.pow(maxX - self.center, 2) + Math.pow(maxY - self.center, 2)) > Math.pow(self.center, 2))) {
			    var maxXOffset = Math.sqrt(Math.pow(self.center, 2) - Math.pow((maxY - self.center).abs(), 2));

			    maxX = (maxX > self.center ? self.center + maxXOffset : self.center - maxXOffset);
			  }

			  if (((Math.pow(minX - self.center, 2) + Math.pow(minY - self.center, 2)) > Math.pow(self.center, 2))) {
			    var minXOffset = Math.sqrt(Math.pow(self.center, 2) - Math.pow((minY - self.center).abs(), 2));

			    minX = (minX > self.center ? self.center + minXOffset : self.center - minXOffset);
			  }

			  var maxBeyondCenter = maxX > self.center;
			  var minBeyondCenter = minX > self.center;

			  var maxOutsideViewableArea = ((Math.pow(maxX - self.center, 2) + Math.pow(maxY - self.center, 2)) < Math.pow(self.center - 25, 2)) == false;
			  var minOutsideViewableArea = ((Math.pow(minX - self.center, 2) + Math.pow(minY - self.center, 2)) < Math.pow(self.center - 25, 2)) == false;

			  if (maxOutsideViewableArea && minOutsideViewableArea) {
			    if ((maxBeyondCenter && minBeyondCenter) || (!maxBeyondCenter && !minBeyondCenter)) {
			      var gapBetweenThem = (minY - maxY).abs();
			      var closestTheyCanBe = Pixel.scale(16.0000000);

			      if (gapBetweenThem <= closestTheyCanBe) {
			        bump = (closestTheyCanBe - gapBetweenThem)/2.0;
			      }
			    }
			  }

			  for (var i = 0; i < 2; ++i) {
			    var x = i == 0 ? maxX : minX;
			    var y = i == 0 ? maxY : minY;
			    var value = i == 0 ? max : min;
			    var outsideViewableArea = i == 0 ? maxOutsideViewableArea : minOutsideViewableArea;
			    var isMin = (i == 1);
			    var shouldFlip = false;

			    /* If y for min is greater than ~200 */
			    if (isMin && y > Pixel.scale(200)) {
			      shouldFlip = true;
			    }
			    /* If y for max is less than ~95 */
			    else if (!isMin && y < Pixel.scale(95)) {
			      shouldFlip = true;
			    }

			    var la = 1;
			    var lx = x;
			    var ly = y - lpt;

			    var vx;
			    var vy = y - vpt;

			    var polyTwo = new [2];
			    var polyThree = new [2];

			    if (outsideViewableArea) {
			      if (bump != null) {
			        var bumpAdj = (bump * (isMin ? 1 : -1));

			        y += bumpAdj;
			        ly += bumpAdj;
			        vy += bumpAdj;
			      }

			      var sign = x > self.center ? -1 : 1;

			      var lhaAdj = Math.ceil(lha/2.0);

			      lx = x + (Pixel.scale(10) * sign);
			      ly -= lhaAdj;

			      vx = x + (Pixel.scale(11) * sign) + ((isMin ? lwmi : lwma) * sign);

			      if (bump != null) {
			        vy = vy - (isMin ? lhaAdj : vha) + (isMin ? 0 : lhaAdj);
			      } else {
			        vy = vy - (isMin ? vha : lhaAdj) + (isMin ? lhaAdj : 0);
			      }

			      la = x > self.center ? 0 : 2;

			      polyTwo = [(x + (Pixel.scale(7) * sign)), (y + Pixel.scale(6))];
			      polyThree = [(x + (Pixel.scale(7) * sign)), (y - Pixel.scale(6))];
			    }
			    /* Inside viewable screen area */
			    else {
			      var a = (shouldFlip == false && isMin == true) || (shouldFlip == true && isMin == false);
			      var b = (shouldFlip == false && isMin == false) || (shouldFlip == true && isMin == true);

			      ly = ly + Pixel.scale((a ? 12 : -12)) - (b ? lha : 0);

			      vx = x + (((isMin ? lwmi : lwma)/2 + Pixel.scale(4)) * (x > self.center ? -1 : 1));
			      vy = vy - (a ? vha : 0) + Pixel.scale((a ? 12 : -12)) + (a ? lha : -lha);

			      polyTwo = [(x + Pixel.scale(9)), (y + Pixel.scale((a ? 7 : -7)))];
			      polyThree = [(x - Pixel.scale(9)), (y + Pixel.scale((a ? 7 : -7)))];
			    }

			    dc.setColor(0xFFFFFF, -1);
			    dc.fillPolygon([
			      [x, y],
			      polyTwo,
			      polyThree
			    ]);
			    dc.drawText(
			      lx,
			      ly,
			      9,
			      isMin ? self.i18nMin : self.i18nMax,
			      la
			    );
			    dc.drawText(
			      vx,
			      vy,
			      11,
			      value,
			      x > self.center ? 0 : 2
			    );
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

		  public function onInitialize() {
		    //
		  }

		  public function onReady(dc) {
		    //
		  }

		  public function onIterate(dc) {
		    //
		  }

		  public function format(value) {
		    return value;
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
