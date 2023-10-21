# Keg.Compass

`widgets` `datafields` `apps`

#### Sub-module(s): [Compass.Abc](COMPASS.ABC.md), [Compass.Dial](COMPASS.DIAL.md)

***

### Description

Get information about the current heading from the on-device sensor reading(s).

***

### Module Details

#### getInfo() as _[CompassInfo](COMPASS.md#compassinfo)_

```js
using Keg.Compass;

var compass = Compass.getInfo();
```

#### setInfo(info) as _void_

```js
using Keg.Compass;

function compute(info) {
  Compass.setInfo(info);
}
```

> [!NOTE]
> This method is required for datafields due to the standard data services being
> unavailable during run-time.

***

### _CompassInfo_

`asString()` as ${\textsf{\color{salmon}string}}$

The formatted heading in degrees (or NATO degrees). Will return `--` if the sensor reading is invalid or not available.

`nesw()` as ${\textsf{\color{salmon}string}}$

The formatted heading in NESW format. Will return `--` if the sensor reading is invalid or not available.

`heading` as ${\textsf{\color{salmon}number}}$

The raw heading value.

`degrees` as ${\textsf{\color{salmon}number}}$

The raw heading in degrees value.

`radians` as ${\textsf{\color{salmon}number}}$

The raw heading in radians value.

***

[Return to Modules](../MODULES.md)
