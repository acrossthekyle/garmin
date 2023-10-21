using Toybox.Application;
using Keg.Heart.Variability;
using Keg.I18n;
using Keg.Pixel;
using Keg.Views;

class Hrv extends Views.AbstractWidgetView
{
  public var page = 4;

  private var hrvIcon = null;
  private var title = "";

  public function initialize() {
    Views.AbstractWidgetView.initialize();
  }

  public function onReady(dc) {
    self.title = I18n.t(:HeartRate_HRV).toUpper();

    self.hrvIcon = new Rez.Drawables.HRV();
  }

  public function onIterate(dc) {
    var variability = Variability.getInfo();

    self.hrvIcon.draw(dc);

    dc.setColor(0xFF0000, -1);
    dc.drawText(
      self.center,
      Pixel.scale(167),
      11,
      self.title,
      1 | 4
    );

    dc.setColor(0xFFFFFF, -1);
    dc.drawText(
      self.center,
      Pixel.scale(203),
      15,
      variability.asString(),
      1 | 4
    );

    dc.setColor(0xFFFFFF, -1);
    dc.drawText(
      self.center,
      Pixel.scale(239),
      10,
      "ms",
      1 | 4
    );
  }

  public function nextView() {
    return new $.Index();
  }

  public function previousView() {
    return new $.Resting();
  }
}
