# Keg.Altitude

`widgets` `datafields` `apps`

#### Sub-module(s): [Altitude.Elevation](ALTITUDE.ELEVATION.md)

***

### Description

Get information about the current altitude from the on-device sensor reading(s).

***

### Module Details

#### getInfo() as _[AltitudeInfo](ALTITUDE.md#altitudeinfo)_

```js
using Keg.Altitude;

var altitude = Altitude.getInfo();
```

#### setInfo(info) as _void_

```js
using Keg.Altitude;

function compute(info) {
  Altitude.setInfo(info);
}
```

> [!NOTE]
> This method is required for datafields due to the standard data services being
> unavailable during run-time.

***

### _AltitudeInfo_

`asString()` as ${\textsf{\color{salmon}string}}$

The formatted altitude value based on device settings for metric/statute. Will
return `--` if the sensor reading is invalid or not available.

`oxygen` as _[AltitudeOxygenInfo](ALTITUDE.md#altitudeoxygeninfo)_

The estimated effective oxygen available, as an instance.

`risk` as ${\textsf{\color{salmon}number}}$

The current altitude risk on a scale from 0-3. The higher the altitude, the
higher the risk level.

`zone` as ${\textsf{\color{salmon}number}}$

The current altitude zone on a scale from 0-4. The higher the altitude, the
higher the zone.

`unit` as ${\textsf{\color{salmon}string}}$

The unit of measurement based on device settings. Will either be `m` or `ft`.

`value` as ${\textsf{\color{salmon}float|number}}$

The raw altitude value.

***

### _AltitudeOxygenInfo_

`value` as ${\textsf{\color{salmon}number}}$

The raw estimated effective oxygen available as a whole number.

`asString()` as ${\textsf{\color{salmon}string}}$

The formatted estimated effective oxygen available.

***

[Return to Modules](../MODULES.md)
