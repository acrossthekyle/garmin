using Toybox.System;

(:debug :glance)
function log(m) {
  System.println(m);
}

module Keg
{
	var screenWidth = System.getDeviceSettings().screenWidth;
	var screenHeight = System.getDeviceSettings().screenHeight;
	var screenCenter = self.screenWidth/2;

	var opened = false;
}
