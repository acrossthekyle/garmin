# Keg.Temperature

`widgets` `datafields` `apps`

#### Sub-module(s): None

***

### Description

Get information about the current temperature based on device sensor reading(s).

***

### Module Details

#### getInfo() as _[TemperatureInfo](TEMPERATURE.md#temperatureinfo)_

```js
using Keg.Temperature;

var temperature = Temperature.getInfo();
```

***

### _TemperatureInfo_

`asString()` as ${\textsf{\color{salmon}string}}$

The formatted temperature.

`unit` as ${\textsf{\color{salmon}string}}$

The unit of measurement for the temperature based on device settings. Will either be `C` or `F`.

`value` as ${\textsf{\color{salmon}float}}$

The raw value.

`isCore` as ${\textsf{\color{salmon}boolean}}$

The temperature value has been calculated as estimated core body temperature.

***

[Return to Modules](../MODULES.md)
