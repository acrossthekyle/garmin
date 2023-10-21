using Keg.Pixel;
using Keg.Utilities.Circle;

module Keg
{
	module Shape
	{
		function arc(dc, options) {
			var DIRECTION = 1; // clockwise
			var THRESHOLD = .985;

			var BACKGROUND = options.get(:background);
			var CENTER = options.get(:center);
			var DEGREES = options.get(:degrees);
			var ENDCAPS = options.hasKey(:endcaps) ? options.get(:endcaps) : false;
			var FOREGROUND = options.get(:foreground);
			var OVERLAP = options.get(:overlap);
			var PERCENT = options.get(:percent);
			var RADIUS = options.get(:radius);
			var ROUNDED = options.get(:rounded);
			var START = options.get(:start);
			var THICKNESS = options.get(:thickness);
			var ENDCAPS_COLOR = options.hasKey(:endcapsColor) ? options.get(:endcapsColor) : FOREGROUND;

			// // // // // // // // // // // //
			// // // // // // // // // // // //
			// // // // // // // // // // // //
			//
			//                      COORDINATES
			//
			// // // // // // // // // // // //
			// // // // // // // // // // // //
			// // // // // // // // // // // //

			var COORDINATES = [130, 130];

			if (CENTER != null) {
				COORDINATES = CENTER;
			}

			COORDINATES[0] = Pixel.scale(COORDINATES[0]);
			COORDINATES[1] = Pixel.scale(COORDINATES[1]);

			// // // // // // // // // // // //
			// // // // // // // // // // // //
			// // // // // // // // // // // //
			//
			//                    IS OFF CENTER
			//
			// // // // // // // // // // // //
			// // // // // // // // // // // //
			// // // // // // // // // // // //

			var askew = COORDINATES[0] != COORDINATES[1];

			if (COORDINATES[0] == COORDINATES[1]) {
				askew = COORDINATES[0] != 130;
			}

			// // // // // // // // // // // //
			// // // // // // // // // // // //
			// // // // // // // // // // // //
			//
			//                       RADIAL X/Y
			//
			// // // // // // // // // // // //
			// // // // // // // // // // // //
			// // // // // // // // // // // //

			var x = askew ? :xc : :x;
			var y = askew ? :yc : :y;

			// // // // // // // // // // // //
			// // // // // // // // // // // //
			// // // // // // // // // // // //
			//
			//                          PERCENT
			//
			// // // // // // // // // // // //
			// // // // // // // // // // // //
			// // // // // // // // // // // //

			var percentage = PERCENT != null ? (PERCENT < 0.01 ? 0.0 : PERCENT) : 1.0;

			// // // // // // // // // // // //
			// // // // // // // // // // // //
			// // // // // // // // // // // //
			//
			//                          DEGREES
			//
			// // // // // // // // // // // //
			// // // // // // // // // // // //
			// // // // // // // // // // // //

			var actualDegrees = (DEGREES.toFloat() * percentage);

			// // // // // // // // // // // //
			// // // // // // // // // // // //
			// // // // // // // // // // // //
			//
			//                           RADIUS
			//
			// // // // // // // // // // // //
			// // // // // // // // // // // //
			// // // // // // // // // // // //

			var radius = (RADIUS - (THICKNESS/2));

			// // // // // // // // // // // //
			// // // // // // // // // // // //
			// // // // // // // // // // // //
			//
			//                          OVERLAP
			//
			// // // // // // // // // // // //
			// // // // // // // // // // // //
			// // // // // // // // // // // //

			var overlapCount = actualDegrees / DEGREES.toFloat();
			var overlapPercentage = 0;
			var overlapDegrees = 0;

			if (overlapCount > 1.0) {
				actualDegrees = DEGREES.toFloat();

				if (OVERLAP) {
					overlapPercentage = overlapCount - overlapCount.toNumber();
					overlapPercentage = (overlapPercentage < 0.01 ? 0.0 : overlapPercentage);
				}
			}

			overlapDegrees = DEGREES.toFloat() * overlapPercentage;

			// // // // // // // // // // // //
			// // // // // // // // // // // //
			// // // // // // // // // // // //
			//
			//                       START/STOP
			//
			// // // // // // // // // // // //
			// // // // // // // // // // // //
			// // // // // // // // // // // //

			var start = -270 + -START;
			var stop = start + -actualDegrees;

			// // // // // // // // // // // //
			// // // // // // // // // // // //
			// // // // // // // // // // // //
			//
			//                          ENDCAPS
			//
			// // // // // // // // // // // //
			// // // // // // // // // // // //
			// // // // // // // // // // // //

			var endcapsDegrees = askew ? -90 + START : START + 90;
			var endcapsOffset = Pixel.scale(dth,
				askew ? (RADIUS - (THICKNESS/2)) : (130 - radius)
			);
			var endcapsRadius = Pixel.scale((THICKNESS - 2)/2);
			var endcapsRadiusEnlarged = Pixel.scale((THICKNESS/2) + 1);

			// // // // // // // // // // // //
			// // // // // // // // // // // //
			// // // // // // // // // // // //
			//
			//                       BACKGROUND
			//
			// // // // // // // // // // // //
			// // // // // // // // // // // //
			// // // // // // // // // // // //

			dc.setPenWidth(Pixel.scale(THICKNESS));

			if (BACKGROUND && percentage < 1.0) {
				dc.setColor(BACKGROUND, -1);
				dc.drawArc(
		      COORDINATES[0],
		      COORDINATES[1],
		      Pixel.scale(radius),
		      DIRECTION,
		      start,
		      start + -DEGREES
		    );

		    if (ENDCAPS && DEGREES != 360.0) {
		    	dc.setColor(BACKGROUND, -1);
		    	dc.fillCircle(
			      Circle.calculateRadialPoint(COORDINATES[0], endcapsDegrees, endcapsOffset, x),
			      Circle.calculateRadialPoint(COORDINATES[1], endcapsDegrees, endcapsOffset, y),
			      endcapsRadius
			    );
		    	dc.fillCircle(
			      Circle.calculateRadialPoint(COORDINATES[0], endcapsDegrees + DEGREES, endcapsOffset, x),
			      Circle.calculateRadialPoint(COORDINATES[1], endcapsDegrees + DEGREES, endcapsOffset, y),
			      endcapsRadius
			    );
		    }
			}

			// // // // // // // // // // // //
			// // // // // // // // // // // //
			// // // // // // // // // // // //
			//
			//                       FOREGROUND
			//
			// // // // // // // // // // // //
			// // // // // // // // // // // //
			// // // // // // // // // // // //

			if (FOREGROUND && percentage > 0.00) {
				dc.setColor(FOREGROUND, -1);
				dc.drawArc(
		      COORDINATES[0],
		      COORDINATES[1],
		      Pixel.scale(radius),
		      DIRECTION,
		      start,
		      stop
		    );

		    if (ENDCAPS) {
		    	// beginning endcap
		    	dc.setColor(ENDCAPS_COLOR, -1);
		    	dc.fillCircle(
			      Circle.calculateRadialPoint(COORDINATES[0], endcapsDegrees, endcapsOffset, x),
			      Circle.calculateRadialPoint(COORDINATES[1], endcapsDegrees, endcapsOffset, y),
			      endcapsRadius
			    );

		    	// ending endcap
			    if (ROUNDED && percentage < THRESHOLD) {
			    	dc.fillCircle(
				      Circle.calculateRadialPoint(COORDINATES[0], endcapsDegrees + actualDegrees, endcapsOffset, x),
				      Circle.calculateRadialPoint(COORDINATES[1], endcapsDegrees + actualDegrees, endcapsOffset, y),
				      endcapsRadius
				    );
			    } else if (percentage >= THRESHOLD || percentage >= 1.0) {
			    	dc.fillCircle(
				      Circle.calculateRadialPoint(COORDINATES[0], endcapsDegrees + DEGREES, endcapsOffset, x),
				      Circle.calculateRadialPoint(COORDINATES[1], endcapsDegrees + DEGREES, endcapsOffset, y),
				      endcapsRadius
				    );
			    }

		    	if (overlapPercentage > 0) {
		    		dc.setColor(0x000000, -1);
						dc.fillCircle(
				      Circle.calculateRadialPoint(COORDINATES[0], endcapsDegrees + overlapDegrees, endcapsOffset, x),
				      Circle.calculateRadialPoint(COORDINATES[1], endcapsDegrees + overlapDegrees, endcapsOffset, y),
				      endcapsRadiusEnlarged
				    );

		    		dc.setColor(FOREGROUND, -1);
						dc.drawArc(
				      COORDINATES[0],
				      COORDINATES[1],
				      Pixel.scale(radius),
				      DIRECTION,
				      start,
				      start + -overlapDegrees
				    );

				    // beginning overflow endcap
						dc.setColor(ENDCAPS_COLOR, -1);
			    	dc.fillCircle(
				      Circle.calculateRadialPoint(COORDINATES[0], endcapsDegrees, endcapsOffset, x),
				      Circle.calculateRadialPoint(COORDINATES[1], endcapsDegrees, endcapsOffset, y),
				      endcapsRadius
				    );
				    // ending overflow endcap
				    dc.fillCircle(
				      Circle.calculateRadialPoint(COORDINATES[0], endcapsDegrees + overlapDegrees, endcapsOffset, x),
				      Circle.calculateRadialPoint(COORDINATES[1], endcapsDegrees + overlapDegrees, endcapsOffset, y),
				      endcapsRadius
				    );
		    	}
		    }
			}
		}
	}
}
