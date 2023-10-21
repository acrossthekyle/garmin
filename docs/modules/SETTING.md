# Keg.Setting

`widgets` `datafields` `apps` `watchfaces`

#### Sub-module(s): None

***

### Description

Gets a setting value from the project settings, with a fallback value.

***

### Module Details

#### getValue(name, fallbackValue) as _number|boolean|string|float_

```js
using Keg.Setting;

function onUpdate(dc) {
	var value = Setting.getValue("SomeSettingID", 1);
}
```

***

[Return to Modules](../MODULES.md)
