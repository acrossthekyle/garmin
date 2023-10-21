using Toybox.Application.Properties;
using Toybox.Application.Storage;
using Toybox.Background;
using Toybox.SensorHistory;
using Toybox.System;
using Toybox.UserProfile;

(:background)
class BackgroundService extends System.ServiceDelegate
{
  function onTemporalEvent() {
    try {
      Storage.setValue("StormAlertData", null);

      var d = Storage.getValue("PressureHistory");

      if (d == null) {
        d = [];
      }

      var h = SensorHistory.getPressureHistory({
        :period => 1,
        :order  => 0 /* newest first */
      });

      if (h != null) {
        var sample = h.next();

        if (sample != null) {
          if (sample has :data) {
            if (sample.data != null) {
              var p = sample.data.toFloat()/100.0; /* convert to millibars */

              if (d.size() == 7) {
                d[0] = d[1];
                d[1] = d[2];
                d[2] = d[3];
                d[3] = d[4];
                d[4] = d[5];
                d[5] = d[6];
                d[6] = p;
              } else {
                d.add(p);
              }
            }
          }
        }
      }

      Storage.setValue("PressureHistory", d);

      if (Properties.getValue("StormAlert_Enabled") == true) {
        var u = UserProfile.getProfile();
        var dnd = false;

        if (u.sleepTime != null && u.wakeTime != null) {
          var c = System.getClockTime();
          dnd = (c.hour >= (u.sleepTime.value()/60/60).toNumber() || (u.wakeTime.value()/60/60).toNumber() >= c.hour);
        }

        if (dnd == false && d.size() >= 3) {
          var r = Properties.getValue("StormAlert_RateOfChange");

          if (r != null) {
            if (!(r instanceof Number)) {
              r = r.toNumber();
            }
          } else {
            r = 4;
          }

          var count = d.size();

          var diff = d[count - 1] - d[count - 3]; /* recent minus 3 hours ago */

          if (diff < 0) {
            var rs = [6.0, 5.5, 5.0, 4.5, 4.0, 3.5, 3.0, 2.5, 2.0, 1.5, 1.0];

            if (diff.abs() >= rs[r]) {
              Background.requestApplicationWake(Properties.getValue("StormAlert_Message"));
            }
          }
        }
      }
    } catch (ex) {
      /* do nothing for now */
    }

    Background.exit(null);
  }
}
