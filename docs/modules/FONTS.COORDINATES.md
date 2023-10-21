# Keg.Fonts.Coordinates

`widgets` `datafields` `apps` `watchfaces`

#### Parent-module(s): [Fonts](FONTS.md)

***

### Description

Calculate the various `y` coordinates relative to the desired alignment scaled to each device size.

***

### Module Details

#### calculate(verticalAlignment, yCoordinate, fontAdjustments) as _[FontCoordinates](FONTS.COORDINATES.md#fontcoordinates)_

```js
using Keg.Fonts.Coordinates;

var adjustments = Fonts.getAdjustments(9);

var coordinates = Coordinates.calculate(:middle, 100, adjustments);
```

***

### _FontCoordinates_

`actual` as ${\textsf{\color{salmon}number}}$

The y coordinate unaltered and scaled to the device size.

`top` as ${\textsf{\color{salmon}number}}$

The top of the font based on font size as provided by the font adjustments, scaled to the device size.

`middle` as ${\textsf{\color{salmon}number}}$

The middle of the font based on font size as provided by the font adjustments, scaled to the device size.

`bottom` as ${\textsf{\color{salmon}number}}$

The bottom of the font based on font size as provided by the font adjustments, scaled to the device size.

***

[Return to Modules](../MODULES.md)
