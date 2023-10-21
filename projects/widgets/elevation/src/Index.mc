using Keg.Altitude;
using Keg.I18n;
using Keg.Pagination;
using Keg.Pixel;
using Keg.Views;

class Index extends Views.AbstractWidgetView
{
  private var title = "";

  public function initialize() {
    Views.AbstractWidgetView.initialize();
  }

  public function onReady(dc) {
    self.title = I18n.t(:Altitude);
  }

  public function onAppLoad() {
    Pagination.setPages(4);
  }

  public function onIterate(dc) {
    var altitude = Altitude.getInfo();

    var start = Pixel.scale(-106);
    var ys = [34, 20, 34, 20, 34, 20, 34]b;

    dc.setColor(0xFFFFFF, -1);

    for (var i = 0; i < 7; ++i) {
      dc.fillRoundedRectangle(
        self.center - Pixel.scale(ys[i])/2,
        self.center + start + Pixel.scale(8),
        Pixel.scale(ys[i]),
        Pixel.scale(5),
        Pixel.scale(5)
      );

      start += Pixel.scale(16);
    }

    var y = Pixel.scale(132) - (
      Pixel.scale(100) * (
        (altitude.value < 0 ? 0 : altitude.value)/8854.44
      )
    );

    dc.setColor(0xFFFFFF, -1);
    dc.fillPolygon([
      [Pixel.scale(103), y],
      [Pixel.scale(93), (y - Pixel.scale(7))],
      [Pixel.scale(93), (y + Pixel.scale(7))]
    ]);
    dc.fillPolygon([
      [Pixel.scale(157), y],
      [Pixel.scale(167), (y - Pixel.scale(7))],
      [Pixel.scale(167), (y + Pixel.scale(7))]
    ]);

    dc.setColor(0x55FF00, -1);
    dc.drawText(
      self.center,
      Pixel.scale(167),
      11,
      self.title.toUpper(),
      1 | 4
    );

    dc.setColor(0xFFFFFF, -1);
    dc.drawText(
      self.center,
      Pixel.scale(203),
      15,
      altitude.asString(),
      1 | 4
    );
    dc.drawText(
      self.center + (dc.getTextWidthInPixels(altitude.asString(), 15)/2) + Pixel.scale(4),
      Pixel.scale(203),
      10,
      altitude.unit,
      2 | 4
    );
  }

  public function nextView() {
    return new $.ElevationHistory();
  }

  public function previousView() {
    return new $.Oxygen();
  }
}
