# Keg.Sun.Twilight

`widgets` `datafields` `apps`

#### Parent-module(s): [Sun](SUN.md)

***

### Description

Get information about the twilight times of the sun.

***

### Module Details

#### getInfo(position, moment, level) as _[TwilightInfo](SUN.TWILIGHT.md#twilightinfo)_

```js
using Keg.Sun.Twilight;

var twilight = Twilight.getInfo([45.555, 55.555], Toybox.Time.now(), 2);
```

***

### _TwilightInfo_

`dawn` as _[TwilightLevelInfo](SUN.TWILIGHT.md#twilightlevelinfo)_

The total ascent based on the on-device sensor history for altitude.

`dusk` as _[TwilightLevelInfo](SUN.TWILIGHT.md#twilightlevelinfo)_

The total descent based on the on-device sensor history for altitude.

***

### _TwilightLevelInfo_

`asString()` as ${\textsf{\color{salmon}string}}$

The formatted twilight time.

`minute` as ${\textsf{\color{salmon}number}}$

The minute of the sun event.

`hour` as ${\textsf{\color{salmon}number}}$

The hour of the sun event.

`degree` as ${\textsf{\color{salmon}number}}$

The degrees of the sun event on a circle.

***

[Return to Modules](../MODULES.md)
