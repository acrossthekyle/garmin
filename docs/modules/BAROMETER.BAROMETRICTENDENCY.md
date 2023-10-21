# Keg.Barometer.BarometricTendency

`widgets` `datafields` `apps`

#### Parent-module(s): [Barometer](BAROMETER.md)

***

### Description

Get information about the current barometric tendency from the on-device sensor history reading(s).

***

### Module Details

#### getInfo() as _[BarometricTendencyInfo](BAROMETER.BAROMETRICTENDENCY.md#barometrictendencyinfo)_

```js
using Keg.Barometer.BarometricTendency;

var tendency = BarometricTendency.getInfo();
```

***

### _BarometricTendencyInfo_

`value` as ${\textsf{\color{salmon}array}}$

The barometric tendency as an array of 14 indexes of Y coordinates.

***

[Return to Modules](../MODULES.md)
