# Keg.Altitude.Elevation

`widgets` `datafields` `apps`

#### Parent-module(s): [Altitude](ALTITUDE.md)

***

### Description

Get information about the current elevation variation.

***

### Module Details

#### getInfo() as _[ElevationInfo](ALTITUDE.ELEVATION.md#elevationinfo)_

```js
using Keg.Altitude.Elevation;

var elevation = Elevation.getInfo();
```

***

### _ElevationInfo_

`ascent` as _[ElevationVariationInfo](ALTITUDE.ELEVATION.md#elevationvariationinfo)_

The total ascent based on the on-device sensor history for altitude.

`descent` as _[ElevationVariationInfo](ALTITUDE.ELEVATION.md#elevationvariationinfo)_

The total descent based on the on-device sensor history for altitude.

`min` as _[ElevationExtremityInfo](ALTITUDE.ELEVATION.md#elevationextremityinfo)_

The lowest altitude based on the on-device sensor history for altitude.

`max` as _[ElevationExtremityInfo](ALTITUDE.ELEVATION.md#elevationextremityinfo)_

The highest altitude based on the on-device sensor history for altitude.

***

### _ElevationVariationInfo_

`value` as ${\textsf{\color{salmon}number}}$

The raw value.

`asString()` as ${\textsf{\color{salmon}string}}$

The formatted value.

***

### _ElevationExtremityInfo_

`value` as ${\textsf{\color{salmon}number}}$

The raw value.

`asString()` as ${\textsf{\color{salmon}string}}$

The formatted value.

***

[Return to Modules](../MODULES.md)
