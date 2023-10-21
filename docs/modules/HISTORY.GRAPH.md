# Keg.History.Graph

`widgets` `datafields` `apps`

#### Parent-module(s): [History](HISTORY.md)

***

### Description

Render a spline-curve graph based on a _History Object_.

***

### Module Details

#### spline() as _void_

```js
using Keg.History;
using Keg.History.Graph;

function onUpdate(dc) {
	var historyObject = History.getHistory(:getElevationHistory, 180);

	Graph.spline(dc, historyObject, [140.0000000, 180.0000000, 220.0000000, 80.0000000]);
}
```

***

[Return to Modules](../MODULES.md)
