using Keg.Altitude;
using Keg.I18n;
using Keg.Pixel;
using Keg.Views;

(:glance)
class Glance extends Views.AbstractGlanceView
{
  public var history = :getElevationHistory;
  public var historyColor = 0x55FF00;

  private var oxygenWidth = 0;
  private var oxygenFourth = 0;
  private var oxygenSixteenth = 0;

  public function initialize() {
    Views.AbstractGlanceView.initialize();
  }

  public function onReady(dc) {
    self.title = I18n.t(:Altitude);

    self.oxygenWidth = self.width - (dc.getTextWidthInPixels("O2", 18) + Pixel.scale(5));
    self.oxygenFourth = self.oxygenWidth/4.0;
    self.oxygenSixteenth = self.oxygenWidth/16.0;
  }

  public function onIterate(dc) {
    var altitude = Altitude.getInfo();

    self.sensor = altitude.asString();
    self.sensorUnits = altitude.unit;

    // Meter

    dc.setColor(0xFFFFFF, -1);
  	dc.drawText(
      self.width,
      self.plotY,
      18,
      "O2",
      0 | 4
    );

    dc.setPenWidth(Pixel.scale(1));
    dc.drawLine(0, self.plotY, self.oxygenWidth, self.plotY);

    dc.setPenWidth(Pixel.scale(2));
    dc.drawLine(1, self.plotY - Pixel.scale(5), 1, self.plotY + Pixel.scale(5));
    dc.drawLine(self.oxygenWidth, self.plotY - Pixel.scale(5), self.oxygenWidth, self.plotY + Pixel.scale(5));

    for (var i = 1; i < 4; ++i) {
      dc.drawLine(
        i * self.oxygenFourth,
        self.plotY - Pixel.scale(3),
        i * self.oxygenFourth,
        self.plotY + Pixel.scale(3)
      );
    }

    dc.setPenWidth(Pixel.scale(1));

    for (var i = 1; i < 16; ++i) {
      dc.drawLine(
        i * self.oxygenSixteenth,
        self.plotY - Pixel.scale(2),
        i * self.oxygenSixteenth,
        self.plotY + Pixel.scale(2)
      );
    }

    var oxygen = altitude.oxygen.value/100;

    dc.setColor(0x55FF00, -1);
    dc.setPenWidth(Pixel.scale(5));
    dc.drawLine(
      self.oxygenWidth * (oxygen <= 0 ? 0 : oxygen) - (oxygen >= .99 ? Pixel.scale(5) : 0),
      self.plotY - Pixel.scale(4),
      self.oxygenWidth * (oxygen <= 0 ? 0 : oxygen) - (oxygen >= .99 ? Pixel.scale(5) : 0),
      self.plotY + Pixel.scale(4)
    );
  }
}
