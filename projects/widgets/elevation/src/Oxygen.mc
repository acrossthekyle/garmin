using Toybox.WatchUi;
using Keg.Altitude;
using Keg.Barometer;
using Keg.I18n;
using Keg.Pixel;
using Keg.Views;

class Oxygen extends Views.AbstractWidgetView
{
  public var page = 4;

  private var icon = null;
  private var risks = new [4];
  private var zones = new [5];

  private var title = "";
  private var oxygenTitle = "";
  private var riskTitle = "";

  public function initialize() {
    Views.AbstractWidgetView.initialize();
  }

  public function onReady(dc) {
    self.icon = WatchUi.loadResource(Rez.Drawables.HeaderIcon);

    self.zones[0] = I18n.t(:Altitude_ZoneLow);
    self.zones[1] = I18n.t(:Altitude_ZoneModerate);
    self.zones[2] = I18n.t(:Altitude_ZoneHigh);
    self.zones[3] = I18n.t(:Altitude_ZoneVeryHigh);
    self.zones[4] = I18n.t(:Altitude_ZoneExtreme);

    self.risks[0] = I18n.t(:Altitude_RiskNone);
    self.risks[1] = I18n.t(:Altitude_RiskAms);
    self.risks[2] = I18n.t(:Altitude_RiskHape);
    self.risks[3] = I18n.t(:Altitude_RiskHace);

    self.title = I18n.t(:Altitude);
    self.oxygenTitle = I18n.t(:Altitude_Oxygen);
    self.riskTitle = I18n.t(:Altitude_Risk);
  }

  public function onIterate(dc) {
    var altitude = Altitude.getInfo();
    var barometer = Barometer.getInfo();

    if (self.icon != null) {
      dc.drawBitmap(
        self.center - self.icon.getWidth()/2,
        Pixel.scale(15) - self. icon.getHeight()/2,
        self.icon
      );
    }

    dc.setColor(0xFFFFFF, -1);
    dc.drawText(
      self.center,
      Pixel.scale(38),
      9,
      self.title.toUpper(),
      1 | 4
    );
    dc.drawText(
      self.center,
      Pixel.scale(63),
      13,
      self.zones[altitude.zone].toUpper(),
      1 | 4
    );

    dc.setColor(0xFFFFFF, -1);
    dc.drawText(
      Pixel.scale(65),
      Pixel.scale(108),
      10,
      self.oxygenTitle.toUpper(),
      1 | 4
    );
    dc.drawText(
      Pixel.scale(65),
      Pixel.scale(122),
      13,
      altitude.oxygen.asString(),
      1
    );

    dc.setColor(0xAAAAAA, -1);
    dc.setPenWidth(Pixel.scale(2));
    dc.drawLine(
      self.center,
      Pixel.scale(98),
      self.center,
      Pixel.scale(163)
    );

    dc.setColor(0xFFFFFF, -1);
    dc.drawText(
      Pixel.scale(195),
      Pixel.scale(108),
      10,
      self.riskTitle.toUpper(),
      1 | 4
    );
    dc.drawText(
      Pixel.scale(195),
      Pixel.scale(122),
      13,
      self.risks[altitude.risk].toUpper(),
      1
    );

    var oxygenMeterWidth = Pixel.scale(186);

    dc.setColor(0x55FF00, -1);
    dc.fillRoundedRectangle(
      Pixel.scale(37),
      Pixel.scale(185),
      oxygenMeterWidth,
      Pixel.scale(8),
      Pixel.scale(4)
    );

    var oxygenBarPixels = altitude.oxygen.value * oxygenMeterWidth;

    dc.setColor(0x000000, -1);
    dc.fillRoundedRectangle(
      Pixel.scale(37) + oxygenBarPixels - Pixel.scale(6),
      Pixel.scale(180),
      Pixel.scale(12),
      Pixel.scale(18),
      Pixel.scale(3)
    );
    dc.setColor(0xFFFFFF, -1);
    dc.fillRoundedRectangle(
      Pixel.scale(37) + oxygenBarPixels - Pixel.scale(4),
      Pixel.scale(180),
      Pixel.scale(8),
      Pixel.scale(18),
      Pixel.scale(3)
    );

    dc.setColor(0xFFFFFF, -1);
    dc.drawText(
      self.center,
      Pixel.scale(221),
      12,
      barometer.ambient.asString(),
      1 | 4
    );
    dc.drawText(
      self.center,
      Pixel.scale(244),
      9,
      barometer.unit,
      1 | 4
    );
  }

  public function nextView() {
    return new $.Index();
  }

  public function previousView() {
    return new $.AscentDescent();
  }
}
