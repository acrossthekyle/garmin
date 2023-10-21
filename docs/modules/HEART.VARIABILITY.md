# Keg.Heart.Variability

`widgets` `datafields` `apps`

#### Parent-module(s): [Heart](HEART.md)

***

### Description

Get information about the current heart rate variability (HRV).

***

### Module Details

#### getInfo() as _[VariabilityInfo](HEART.VARIABILITY.md#variabilityinfo)_

```js
using Keg.Heart.Variability;

var hrv = Variability.getInfo();
```

#### setData(data) as _void_

```js
using Keg.Heart.Variability;

function onSensorData(data) {
  Variability.setData(data);
}

Toybox.Sensor.registerSensorDataListener(method(:onSensorData), {
  :period => 4,
  :heartBeatIntervals => {
    :enabled => true
  }
});
```

***

### _VariabilityInfo_

`asString()` as ${\textsf{\color{salmon}string}}$

The formatted value.

`value` as ${\textsf{\color{salmon}number}}$

The raw value.

***

[Return to Modules](../MODULES.md)
