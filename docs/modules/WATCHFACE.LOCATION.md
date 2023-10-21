# Keg.Watchface.Location;

`watchfaces`

#### Sub-module(s): None

***

### Description

Get the users location based on latitude/longitude from project settings.

***

### Module Details

#### getLocation(latitude, longitude) as _Toybox.Position.Location_

```js
using Keg.Watchface.Location;

function onUpdate(dc) {
	var location = Location.getLocation(45.555, 55.555);
}
```

***

[Return to Modules](../MODULES.md)
