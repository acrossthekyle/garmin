# Keg.Fonts

`widgets` `datafields` `apps` `watchfaces`

#### Sub-module(s): [Fonts.Coordinates](FONTS.COORDINATES.md)

***

### Description

Calculate adjustments for the various system-standard font families in order to position text in relation to other text, and to remove padding discrepancies between the system-standard font families.

***

### Module Details

#### getAdjustments(font) as _[FontAdjustments](FONTS.md#fontadjustments)_

```js
using Keg.Fonts;

var adjustments = Fonts.getAdjustments(9);

// or

var adjustments = Fonts.getAdjustments(:extraTiny);
```

#### snap(verticalAlignment, yCoordinate, fontAdjustments) as _void_

```js
using Keg.Fonts;

var adjustments = Fonts.getAdjustments(9);

Fonts.snap(:top, 100, adjustments);
```

***

### _FontAdjustments_

`ascent` as ${\textsf{\color{salmon}number}}$

The corrected ascent of the font size, only for font sizes 9 and 11 (extraTiny and small).

`descent` as ${\textsf{\color{salmon}number}}$

The corrected descent of the font size.

`height` as ${\textsf{\color{salmon}number}}$

The corrected height of the font size.

***

[Return to Modules](../MODULES.md)
