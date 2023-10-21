# Keg.Compass.Abc

`widgets` `datafields` `apps`

#### Parent-module(s): [Compass](COMPASS.md)

***

### Description

Renders the A.B.C. portions of the compass projects.

***

### Module Details

#### render(dc, compassInfo) as _void_

```js
using Keg.Compass;
using Keg.Compass.Abc;

function onUpdate(dc) {
	var compass = Compass.getInfo();

	Abc.render(dc, compass);
}
```

***

[Return to Modules](../MODULES.md)
