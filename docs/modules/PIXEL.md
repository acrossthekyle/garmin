# Keg.Pixel

`widgets` `datafields` `apps` `watchfaces`

#### Sub-module(s): None

***

### Description

Scale and de-scale pixels based on device size, with 260 being the base.

***

### Module Details

#### scale(pixels) as _float_

```js
using Keg.Pixel;

function onUpdate(dc) {
	var pixel = Pixel.scale(100);
}
```

#### descale(pixel) as _void_

Scales pixel from scaled size back to true device size.

```js
using Keg.Pixel;

function onUpdate(dc) {
	var pixel = Pixel.descale(100);
}
```

***

[Return to Modules](../MODULES.md)
