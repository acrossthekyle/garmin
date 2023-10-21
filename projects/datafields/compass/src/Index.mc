using Keg.Altitude;
using Keg.Compass;
using Keg.Compass.Abc;
using Keg.Compass.Dial;
using Keg.Views;

class Index extends Views.AbstractDataFieldView
{
  public function initialize() {
    Views.AbstractDataFieldView.initialize();
  }

  public function onIterate(dc) {
    Altitude.setInfo(self.computedInfo);
    Compass.setInfo(self.computedInfo);

    var compass = Compass.getInfo();

    Abc.render(dc, compass.asString());

    Dial.render(dc, compass.degrees);
  }
}
