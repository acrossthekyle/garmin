# Keg.Sun

`widgets` `datafields` `apps`

#### Sub-module(s): [Sun.Twilight](SUN.TWILIGHT.md)

***

### Description

Get information about the current sun times.

***

### Module Details

#### getInfo(position, moment) as _[SunInfo](SUN.md#suninfo)_

```js
using Keg.Sun;

var sun = Sun.getInfo([45.555, 55.555], Toybox.Time.now());
```

***

### _SunInfo_

`nextEvent` as _[SunNextEventInfo](SUN.md#sunnexteventinfo)_

The next event of the sun: rise or set, along with the time, as an instance.

`sunrise` as _[SunEventInfo](SUN.md#suneventinfo)_

The sunrise with minutes, hours, and degrees on a circle, as an instance.

`sunset` as _[SunEventInfo](SUN.md#suneventinfo)_

The sunset with minutes, hours, and degrees on a circle, as an instance.

`tomorrow` _[SunEventInfo](SUN.md#suneventinfo)_

The sunrise tomorrow with minutes, hours, and degrees on a circle, as an instance.

***

### _SunEventInfo_

`asString()` as ${\textsf{\color{salmon}string}}$

The formatted sun event time.

`minute` as ${\textsf{\color{salmon}number}}$

The minute of the sun event.

`hour` as ${\textsf{\color{salmon}number}}$

The hour of the sun event.

`degree` as ${\textsf{\color{salmon}number}}$

The degrees of the sun event on a circle.

***

### _SunNextEventInfo_

`asString()` as ${\textsf{\color{salmon}string}}$

The formatted next sun event time.

`minutes` as ${\textsf{\color{salmon}number}}$

The minutes until the next sun event.

`hours` as ${\textsf{\color{salmon}number}}$

The hours until the next sun event.

`event` as ${\textsf{\color{salmon}symbol}}$

The next sun event as `:sunrise` or `:sunset`.

***

[Return to Modules](../MODULES.md)
