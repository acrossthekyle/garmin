# Keg.Gps

`widgets` `datafields` `apps`

#### Sub-module(s): None

***

### Description

Get the current position, along with satelite locating based on device/project settings.

***

### Module Details

#### getInfo() as _[GpsInfo](GPS.md#gpsinfo)_

```js
using Keg.Gps;

var data = Gps.getInfo();
```

#### locate(useDeviceGps, locationFromSettings) as _[LocationInfo](GPS.md#locationinfo)_

```js
using Keg.Gps;

var location = Gps.locate(true, [45.555, 55.555]);
```

***

### _GpsInfo_

`accuracy` as ${\textsf{\color{salmon}number}}$

The accuracy of the GPS position.

`latitude` as ${\textsf{\color{salmon}float}}$

The latitude of the GPS position.

`longitude` as ${\textsf{\color{salmon}float}}$

The longitude of the GPS position.

***

### _LocationInfo_

`asArray()` as ${\textsf{\color{salmon}array}}$

The position as an array of radians: `[latitude, longitude]`.

`acquiring` as ${\textsf{\color{salmon}boolean}}$

The processing status of the locating process.

`error` as ${\textsf{\color{salmon}boolean}}$

The error status if the locating process failed.

`located` as ${\textsf{\color{salmon}boolean}}$

The success status if the locating process worked.

***

[Return to Modules](../MODULES.md)
