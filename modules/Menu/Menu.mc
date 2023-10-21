using Toybox.Application;
using Toybox.Application.Properties;
using Toybox.WatchUi;
using Keg.I18n;
using Keg.Setting;

(:excludeFromLowMemoryDevices :excludeFromDataField)
class Menu extends WatchUi.Menu2
{
  public function initialize() {
    WatchUi.Menu2.initialize({
      :title => I18n.t(:Global_Settings),
      :focus => null
    });

    // WatchUi.Menu2.addItem(new WatchUi.MenuItem(
    //   I18n.t(:FooBar),
    //   null,
    //   :FooBar,
    //   null
    // ));
	}
}

(:excludeFromLowMemoryDevices :excludeFromDataField)
class MenuController extends WatchUi.Menu2InputDelegate
{
  public var menu;

  public function initialize(menu) {
    WatchUi.Menu2InputDelegate.initialize();

    self.menu = menu;
  }

  public function onBack() {
    Application.getApp().onSettingsChanged();

    WatchUi.popView(0);

    return true;
  }

  public function onSelect(selected) {
    var id = selected.getId();
    var index = self.menu.findItemById(id);
    var label = self.menu.getItem(index).getLabel();

    var view = new $.SubMenu(id, label);

    // if (id == :FooBar) {
	  //   view.build([
	  //   	[
    //       "FooBar",
    //       I18n.t(:FooBar),
    //       :toggle
    //     ],
    //     [
    //       "FooBar",
    //       I18n.t(:FooBar),
    //       :select,
    //       [
    //       	I18n.t(:FooBarItem)
		// 			]
    //     ]
		// 	]);
    // }

    WatchUi.pushView(
      view,
      new $.SubMenuController(view, self.menu, index),
      0
    );

    return true;
  }
}

(:excludeFromLowMemoryDevices :excludeFromDataField)
class SubMenu extends WatchUi.Menu2
{
	public var id;
	public var title;
	public var stuff;

  public function initialize(id, title) {
  	self.id = id;
  	self.title = title;

    WatchUi.Menu2.initialize({
      :title => self.title,
      :focus => null
    });
  }

  public function build(stuff) {
    self.stuff = stuff;

    var value;

    for (var i = 0; i < self.stuff.size(); ++i) {
      if (self.stuff[i][3] == :toggle) {
        WatchUi.Menu2.addItem(new WatchUi.ToggleMenuItem(
          self.stuff[i][2],
          null,
          self.stuff[i][0],
          Setting.getValue([self.stuff[i][0]], null),
          null
        ));
      } else {
        value =  Setting.getValue([self.stuff[i][0]], null);

        if (value > (self.stuff[i][4].size() - 1)) {
          value = 0;
        }

        WatchUi.Menu2.addItem(new WatchUi.MenuItem(
          self.stuff[i][2],
          self.stuff[i][4][value],
          self.stuff[i][0],
          null
        ));
      }
    }
  }
}

(:excludeFromLowMemoryDevices :excludeFromDataField)
class SubMenuController extends WatchUi.Menu2InputDelegate
{
  public var current = null;
  public var previous = null;
  public var index = 0;

  public function initialize(current, previous, index) {
    WatchUi.Menu2InputDelegate.initialize();

    self.current = current;
    self.previous = previous;
    self.index = index;
  }

  public function onSelect(selected) {
    var id = selected.getId();
    var index = self.current.findItemById(id);
    var selectedItem = self.current.getItem(index);

    var item = null;

    for (var i = 0; i < self.current.stuff.size(); ++i) {
      if (self.current.stuff[i][0].equals(id)) {
        item = self.current.stuff[i];

        break;
      }
    }

    if (item != null) {
	    if (item[3] == :toggle) {
	      var value = selectedItem.isEnabled();

	      Properties.setValue(item[0], value);

	      self.current.updateItem(selectedItem, index);
	    } else {
	    	var view = new $.SubMenuSelect(item[2], item[4], Setting.getValue([item[0]], null));

        WatchUi.pushView(
          view,
          new $.SubMenuSelectController(
            view,
            self.current,
            id,
            item,
            index
          ),
          0
        );
	    }
	  }

    return true;
  }

  public function onBack() {
    self.previous.setFocus(self.index);

    WatchUi.popView(0);

    return true;
  }
}

(:excludeFromLowMemoryDevices :excludeFromDataField)
class SubMenuSelect extends WatchUi.Menu2
{
  public function initialize(title, options, index) {
    WatchUi.Menu2.initialize({
      :title => title,
      :focus => null
    });

    for (var i = 0; i < options.size(); ++i) {
      WatchUi.Menu2.addItem(new WatchUi.MenuItem(
        options[i],
        null,
        i,
        null
      ));
    }

    self.setFocus(index);
  }
}

(:excludeFromLowMemoryDevices :excludeFromDataField)
class SubMenuSelectController extends WatchUi.Menu2InputDelegate
{
  public var current = null;
  public var previous = null;
  public var id = null;
  public var item = [];
  public var index = null;

  public function initialize(current, previous, id, item, index) {
    Menu2InputDelegate.initialize();

    self.current = current;
    self.previous = previous;
    self.id = id;
    self.item = item;
    self.index = index;
  }

  public function onSelect(selected) {
    var selectedIndex = self.current.findItemById(selected.getId());

    Properties.setValue(self.item[0], selectedIndex);

    if (self.previous != null) {
      var previousIndex = self.previous.findItemById(self.id);
      var previousSelected = self.previous.getItem(previousIndex);

      previousSelected.setSubLabel(self.item[4][selectedIndex]);

      self.previous.updateItem(previousSelected, previousIndex);
    }

    WatchUi.popView(0);

    return true;
  }

  public function onBack() {
    self.previous.setFocus(self.index);

    WatchUi.popView(0);

    return true;
  }
}
