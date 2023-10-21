using Toybox.Math;

module Keg
{
	module Utilities
	{
		module Circle
		{
			function calculateRadialPoint(center, degrees, offset, xOrY) {
			  var radialOffset = xOrY == :xc || xOrY == :yc
			    ? offset
			    : -(center - offset);

			  return center + Math.round(
			    (
			      xOrY == :x || xOrY == :xc
			        ? Math.cos(Math.toRadians(degrees))
			        : Math.sin(Math.toRadians(degrees))
			    ) * radialOffset
			  );
			}
		}
	}
}
