using Toybox.WatchUi;
using Keg.Altitude.Elevation;
using Keg.History;
using Keg.History.Graph;
using Keg.I18n;
using Keg.Pixel;
using Keg.Views;

class AscentDescent extends Views.AbstractWidgetView
{
  public var page = 3;

  private var icon = null;

  private var ascentTitle = "";
  private var descentTitle = "";

  public function initialize() {
    Views.AbstractWidgetView.initialize();
  }

  public function onReady(dc) {
    self.icon = WatchUi.loadResource(Rez.Drawables.HeaderIcon);

    self.ascentTitle = I18n.t(:Altitude_Ascent);
    self.descentTitle = I18n.t(:Altitude_Descent);
  }

  public function onIterate(dc) {
    var info = Elevation.getInfo();

    if (self.icon != null) {
      dc.drawBitmap(
        self.center - self.icon.getWidth()/2,
        Pixel.scale(15) - self.icon.getHeight()/2,
        self.icon
      );
    }

    dc.setColor(0xFFFFFF, -1);
    dc.drawText(
      Pixel.scale(65),
      Pixel.scale(75),
      10,
      self.ascentTitle.toUpper(),
      1 | 4
    );
    dc.drawText(
      Pixel.scale(65),
      Pixel.scale(108),
      14,
      info.ascent.asString(),
      1 | 4
    );
    dc.drawText(
      Pixel.scale(195),
      Pixel.scale(75),
      10,
      self.descentTitle.toUpper(),
      1 | 4
    );
    dc.drawText(
      Pixel.scale(195),
      Pixel.scale(108),
      14,
      info.descent.asString(),
      1 | 4
    );

    Graph.spline(
      dc,
      History.getHistory(:getElevationHistory, self.width),
      [140.0000000, 180.0000000, 220.0000000, 80.0000000]
    );
  }

  public function nextView() {
    return new $.Oxygen();
  }

  public function previousView() {
    return new $.ElevationHistory();
  }
}
