# Keg.Clock

`widgets` `datafields` `apps` `watchfaces`

#### Sub-module(s): None

***

### Description

Get information about time related to the system clock.

***

### Module Details

#### getInfo() as _[ClockInfo](CLOCK.md#clockinfo)_

```js
using Keg.Clock;

var clock = Clock.getInfo();
```

***

### _ClockInfo_

`minutesSinceMidnight` as ${\textsf{\color{salmon}number}}$

The number of minutes since 12:00 AM, or midnight, today.

`secondsUntilMidnight` as ${\textsf{\color{salmon}number}}$

The number of seconds until midnight, today.

***

[Return to Modules](../MODULES.md)
