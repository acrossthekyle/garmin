# Keg.Shape

`widgets` `datafields` `apps` `watchfaces`

#### Sub-module(s): None

***

### Description

Render commonly used shapes.

***

### Module Details

#### arc(dc, options) as _void_

```js
using Keg.Shape;

function onUpdate(dc) {
	Shape.arc(dc, {
		:background => 0x000000,
		:foreground => 0xFFFFFF,
		:center 		=> [130, 130],
		:degrees    => 90,
		:overlap    => false,
		:percent    => .50,
		:radius     => 10,
		:rounded    => true,
		:start      => 0,
		:thickness  => 20
	});
}
```

***

[Return to Modules](../MODULES.md)
