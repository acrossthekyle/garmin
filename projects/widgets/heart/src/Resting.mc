using Keg.Heart;
using Keg.I18n;
using Keg.Pixel;
using Keg.Views;

class Resting extends Views.AbstractWidgetView
{
  public var page = 3;

  private var restingIcon = null;
  private var title = "";

  public function initialize() {
    Views.AbstractWidgetView.initialize();
  }

  public function onReady(dc) {
    self.title = I18n.t(:HeartRate_Resting).toUpper();

    self.restingIcon = new Rez.Drawables.Resting();
  }

  public function onIterate(dc) {
    var heart = Heart.getInfo();

    self.restingIcon.draw(dc);

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
      heart.resting.asString(),
      1 | 4
    );

    dc.drawText(
      self.center,
      Pixel.scale(239),
      10,
      "bpm",
      1 | 4
    );
  }

  public function nextView() {
    return new $.Hrv();
  }

  public function previousView() {
    return new $.History();
  }
}
