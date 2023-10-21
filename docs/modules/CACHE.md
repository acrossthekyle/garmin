# Keg.Cache

`widgets` `datafields` `apps` `watchfaces`

#### Sub-module(s): None

***

### Description

Get, put, and delete, data from local storage on the device for complex calculations that may consume resources.

***

### Module Details

#### fetch(id) as _string|number|array_

```js
using Keg.Cache;

var data = Cache.fetch("SomeId");
```

#### save(id, duration, time, data) as _void_

```js
using Keg.Cache;

Cache.save("SomeId", 10, :minutes, ["foo"]);
```

#### wipe(ids) as _void_

```js
using Keg.Cache;

Cache.wipe(["SomeId"]);
```

***

[Return to Modules](../MODULES.md)
