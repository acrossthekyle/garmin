using Keg.Compass;
using Keg.Compass.Dial;
using Keg.I18n;
using Keg.Pixel;
using Keg.Setting;
using Keg.Utilities.Circle;
using Keg.Views;

class Deviation extends Views.AbstractWidgetView
{
	public var page = 4;

  private var title = "";

	private var enabled = false;

	private var direction = :neutral;

	private var crossedEastToWestOverNorth = false;
  private var crossedWestToEastOverNorth = false;

  private var degreesStart = null;
  private var radiansStart = null;

  private var rawDegrees = 0;
  private var rawRadians = 0;
  private var rawRadiansPrevious = 0;

  public function initialize() {
    Views.AbstractWidgetView.initialize();

    self.reset();
  }

  public function onReady(dc) {
    self.title = I18n.t(:Compass_Deviation);
  }

  public function onTrigger() {
    self.toggle();
  }

  public function onNavigate(direction) {
    self.enabled = false;

    self.reset();
  }

  public function onExit() {
    self.enabled = false;

    self.reset();

    return false;
  }

  public function onIterate(dc) {
  	self.rawRadiansPrevious = self.rawRadians;

    var color = Setting.getValue("Compass_Color", 0xFF0000);
    var compass = Compass.getInfo();

  	self.rawRadians = compass.radians;
  	self.rawDegrees = compass.degrees;

  	var deviation = self.calculateDeviation();
  	var deviationPrettified = self.prettifyDeviation(deviation);

  	var canDrawDeviation = self.enabled == true && deviation.abs() != 0;

    dc.setColor(0xFFFFFF, -1);

    if (!canDrawDeviation) {
      dc.drawText(
        self.center,
        Pixel.scale(110),
        16,
        compass.asString(),
        1 | 4
      );
      dc.drawText(
        self.center + dc.getTextWidthInPixels(compass.asString(), 16)/2 + 7,
        Pixel.scale(96),
        13,
        "°",
        1 | 4
      );
      dc.drawText(
        self.center,
        Pixel.scale(160),
        12,
        compass.nesw(),
        1 | 4
      );
    } else {
      dc.setColor(0xFFFFFF, -1);
      dc.drawText(
        self.center,
        Pixel.scale(88),
        16,
        compass.asString(),
        1 | 4
      );
      dc.drawText(
        self.center + dc.getTextWidthInPixels(compass.asString(), 16)/2 + 7,
        Pixel.scale(74),
        13,
        "°",
        1 | 4
      );

      dc.setColor(0x555555, -1);
      dc.setPenWidth(Pixel.scale(3));
      dc.drawLine(
        Pixel.scale(60),
        Pixel.scale(124),
        Pixel.scale(200),
        Pixel.scale(124)
      );

      dc.setColor(0xAAAAAA, -1);
      dc.drawText(
        self.center,
        Pixel.scale(138),
        9,
        self.title.toUpper(),
        1 | 4
      );

      dc.setColor(0xFFFFFF, -1);
      dc.drawText(
        self.center,
        Pixel.scale(178),
        16,
        deviationPrettified,
        1 | 4
      );
      dc.drawText(
        self.center + dc.getTextWidthInPixels(deviationPrettified, 16)/2 + 7,
        Pixel.scale(164),
        13,
        "°",
        1 | 4
      );
    }

    if (canDrawDeviation) {
      dc.setColor(color, -1);
      dc.setPenWidth(Pixel.scale(25));
      dc.drawArc(
        self.center,
        self.center,
        Pixel.scale(117),
        (self.direction == :left ? 0 : 1),
        (90 + deviation),
        90
      );
    }

    Dial.render(dc, compass.degrees);

    if (canDrawDeviation) {
      dc.setColor(0xFFFFFF, -1);
      dc.setPenWidth(Pixel.scale(3));
      dc.drawLine(
        Circle.calculateRadialPoint(
        	self.center,
        	(90 - deviation),
        	0,
        	:x
        ),
        Circle.calculateRadialPoint(
        	self.center,
        	(90 - deviation),
        	0,
        	:y
        ),
        Circle.calculateRadialPoint(
        	self.center,
        	(90 - deviation),
        	Pixel.scale(25),
        	:x
        ),
        Circle.calculateRadialPoint(
        	self.center,
        	(90 - deviation),
        	Pixel.scale(25),
        	:y
        )
      );
    }
  }

  private function toggle() {
  	self.reset();

  	self.enabled = !self.enabled;

    if (self.enabled == true) {
      self.degreesStart = self.rawDegrees;
      self.radiansStart = self.rawRadians;
    }
  }

  private function reset() {
    self.crossedEastToWestOverNorth = false;
    self.crossedWestToEastOverNorth = false;

    self.direction = :neutral;

    self.degreesStart = null;
    self.radiansStart = null;
  }

  private function calculateDeviation() {
  	self.calculateDeviationCrossings();
  	self.calculateDeviationDirection();

  	if (
  		self.enabled == true &&
  		self.rawDegrees != null &&
  		self.degreesStart != null
  	) {
  		return rawDegrees - degreesStart;
  	}

  	return 0;
  }

  private function calculateDeviationCrossings() {
  	if (
  		self.enabled == true &&
  		self.rawRadians != null &&
  		self.rawRadiansPrevious != null
  	) {
  		var wentWestToEastOverNorth = false;
	    var wentEastToWestOverNorth = false;

	    if (
	      (self.rawRadiansPrevious <= 7.0 && self.rawRadiansPrevious >= 4.5) && /* were in W -> N territory */
	      (self.rawRadians >= 0.0 && self.rawRadians <= 1.575) /* are in N -> E territory */
	    ) {
	      wentWestToEastOverNorth = true;
	    } else if (
	      (self.rawRadiansPrevious <= 1.575 && self.rawRadiansPrevious >= 0.0) && /* were in N -> E territory */
	      (self.rawRadians >= 4.5 && self.rawRadians <= 7.0) /* are in W -> N territory */
	    ) {
	      wentEastToWestOverNorth = true;
	    }

	    if (wentEastToWestOverNorth) {
	      if (self.crossedWestToEastOverNorth) {
	        self.crossedWestToEastOverNorth = false;
	      } else {
	        self.crossedEastToWestOverNorth = true;
	      }
	    } else if (wentWestToEastOverNorth) {
	      if (self.crossedEastToWestOverNorth) {
	        self.crossedEastToWestOverNorth = false;
	      } else {
	        self.crossedWestToEastOverNorth = true;
	      }
	    }
  	}
  }

  private function calculateDeviationDirection() {
  	if (
  		self.enabled == true &&
      self.rawRadians != null &&
      self.radiansStart != null
    ) {
    	self.direction = :neutral;

    	if (self.rawRadians > self.radiansStart) {
	      self.direction = :right;

	      if (self.crossedEastToWestOverNorth) {
	        self.direction = :left;
	      }
	    } else if (self.rawRadians < self.radiansStart) {
	      self.direction = :left;

	      if (self.crossedWestToEastOverNorth) {
	        self.direction = :right;
	      }
	    }
  	}
  }

  private function prettifyDeviation(deviation) {
    if (
      self.rawDegrees == null ||
      self.degreesStart == null ||
      self.enabled == false ||
      self.rawRadians == null ||
      self.rawRadiansPrevious == null ||
      self.radiansStart == null
    ) {
      return "--";
    }

    var v = 0;

    if (self.crossedWestToEastOverNorth) {
      var diff = 360 - self.degreesStart;

      v = (diff + self.rawDegrees).abs();
    } else if (self.crossedEastToWestOverNorth) {
      var diff = 360 - self.rawDegrees;

      v = (self.degreesStart + diff).abs();
    } else {
      v = deviation.abs();
    }

    if (v > 360) {
      v = v - 360;
    }

    var t = v.format("%d");

    if (v < 10) {
      t = "00" + t;
    } else if (v < 100) {
      t = "0" + t;
    }

    return t;
  }

  public function nextView() {
    return new $.Coordinates();
  }

  public function previousView() {
    return new $.BarometerHistory();
  }
}
