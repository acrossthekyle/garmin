# Keg.Heart

`widgets` `datafields` `apps`

#### Sub-module(s): [Heart.Variability](HEART.VARIABILITY.md)

***

### Description

Get information about the current heart rate from the on-device sensor reading(s).

***

### Module Details

#### getInfo() as _[HeartInfo](HEART.md#heartinfo)_

```js
using Keg.Heart;

var heart = Heart.getInfo();
```

***

### _HeartInfo_

`asString()` as ${\textsf{\color{salmon}string}}$

The formatted heart rate value. Will return `--` if the sensor reading is invalid or not available.

`resting` as _[HeartRestingInfo](HEART.md#heartrestinginfo)_

The resting heart rate, if available, as an instance.

`value` as ${\textsf{\color{salmon}float|number}}$

The raw heart rate value.

***

### _HeartRestingInfo_

`asString()` as ${\textsf{\color{salmon}string}}$

The formatted resting heart rate value. Will return `--` if the sensor reading is invalid or not available.

`value` as ${\textsf{\color{salmon}number}}$

The raw heart rate resting value as a whole number.

***

[Return to Modules](../MODULES.md)
