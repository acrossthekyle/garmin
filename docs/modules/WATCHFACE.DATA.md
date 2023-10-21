# Keg.Watchface.Data;

`watchfaces`

#### Sub-module(s): None

***

### Description

Get data for a watchface complication.

***

### Module Details

#### getInfo(options) as _[DataInfo](WATCHFACE.DATA.md#datainfo)_

```js
using Keg.Watchface.Data;

function onUpdate(dc) {
	var data = Data.getInfo({ :type => 7, :key => "SomeCacheID" });
}
```

***

### _DataInfo_

`getIcon()` as ${\textsf{\color{salmon}mixed|null}}$

Load the necessary icon from resources for the data item.

`getLabel()` as ${\textsf{\color{salmon}string|null}}$

Load the necessary string label for the data item.

`getUnitsLabel()` as ${\textsf{\color{salmon}string|null}}$

Load the necessary string label for the units of measurement for the data item.

`asString()` as ${\textsf{\color{salmon}string}}$

Get the data formatted as a string.

`value` as ${\textsf{\color{salmon}mixed}}$

The raw data value.

`units` as ${\textsf{\color{salmon}string|null}}$

The unit of measurement for the data item.

`prefix` as ${\textsf{\color{salmon}string|null}}$

The custom prefix value for the data item.

***

[Return to Modules](../MODULES.md)
