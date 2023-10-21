# Keg.Compass.Dial

`widgets` `datafields` `apps`

#### Parent-module(s): [Compass](COMPASS.md)

***

### Description

Renders a compass dial for the compass projects.

***

### Module Details

#### render(dc, degrees) as _void_

```js
using Keg.Compass;
using Keg.Compass.Dial;

function onUpdate(dc) {
	var compass = Compass.getInfo();

	Dial.render(dc, compass.degrees);
}
```

***

[Return to Modules](../MODULES.md)
