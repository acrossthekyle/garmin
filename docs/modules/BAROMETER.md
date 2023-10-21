# Keg.Barometer

`widgets` `datafields` `apps`

#### Sub-module(s): [Barometer.BarometricTendency](BAROMETER.BAROMETRICTENDENCY.md)

***

### Description

Get information about the current barometer pressure from the on-device sensor reading(s).

***

### Module Details

#### getInfo() as _[BarometerInfo](BAROMETER.md#barometerinfo)_

```js
using Keg.Barometer;

var barometer = Barometer.getInfo();
```

***

### _BarometerInfo_

`asString()` as ${\textsf{\color{salmon}string}}$

The formatted barometer pressure value based on device settings for metric/statute. Will
return `--` if the sensor reading is invalid or not available.

`ambient` as _[BarometerAmbientInfo](BAROMETER.md#barometerambientinfo)_

The ambient (local) pressure not calibrated to sea-level, as an instance.

`unit` as ${\textsf{\color{salmon}string}}$

The unit of measurement based on device settings. Can be `hPa`, `mmHg`, `mBar`, or `inHg`.

`value` as ${\textsf{\color{salmon}number}}$

The raw barometer value in Pascals.

***

### _BarometerAmbientInfo_

`unit` as ${\textsf{\color{salmon}string}}$

The unit of measurement based on device settings. Can be `hPa`, `mmHg`, `mBar`, or `inHg`.

`asString()` as ${\textsf{\color{salmon}string}}$

The formatted value.

***

[Return to Modules](../MODULES.md)
