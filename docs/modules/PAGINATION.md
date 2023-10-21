# Keg.Pagination

`widgets`

#### Sub-module(s): None

***

### Description

Renders pagination indicators on the screen.

***

### Module Details

#### setPages(pages) as _void_

```js
using Keg.Pagination;

function getInitialView(dc) {
	Pagination.setPages(2);
}
```

#### render(dc, page) as _void_

```js
using Keg.Pagination;

function onUpdate(dc) {
	Pagination.render(dc, 1);
}
```

#### reset() as _void_

Resets pagination timeout.

```js
using Keg.Pagination;

function onLayout(dc) {
	Pagination.reset();
}
```

***

[Return to Modules](../MODULES.md)
