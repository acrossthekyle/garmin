using Keg.Pixel;

module Keg
{
	module History
	{
		module Graph
		{
			(:glance)
			function spline(dc, history, bounds) {
				if (history != null) {
			    /* Bottom (y) of graphing area */
			    var bottom = Pixel.scale(bounds[2]);

			    /* Middle (y) of graphing area */
			    var middle = Pixel.scale(bounds[1]);

			    /* Top (y) of graphing area */
			    var top = Pixel.scale(bounds[0]);

			    /* Height (y) of graphing area */
			    var height = Pixel.scale(bounds[3]);

			    var minimum = history.getMin();
			    var maximum = history.getMax();

			    if (minimum == null) {
			      minimum = 0;
			    }

			    if (maximum == null) {
			      maximum = 0;
			    }

			    var r = maximum - minimum;

			    var ys = []b;

			    while (true) {
			      var next = history.next();

			      if (next != null) {
			        var value = 0.0;

			        if (next.data != null) {
			          value = next.data.toFloat();
			        }

			        var y = bottom;

			        if (value > 0) {
			          /* Scale value to fit graph area */
			          y = (
			            r > 0
			              ? bottom - ((height - 0.0000000) * (value - minimum) / r + 0.0000000)
			              : middle
			            );

			          /* Weight value to appear more evenly distributed vertically */
			          y = ((0.5 * y) + (0.5 * middle));
			        }

			        ys.add((y - top).toNumber());
			      } else {
			        break;
			      }
			    }

			    var lastPoint = null;
			    var x = screenCenter + (ys.size()/2);

			    dc.setPenWidth(Pixel.scale(4));
			    dc.setColor(0x55FF00, 1);

			    for (var i = 0; i < ys.size(); ++i) {
			      var y = ys[i] + top;

			      if (lastPoint != null) {
			        dc.drawLine(
			          x,
			          y,
			          lastPoint[0],
			          lastPoint[1]
			        );
			      }

			      lastPoint = [x, y];

			      x -= 1;
			    }
			  }
			}
		}
	}
}
