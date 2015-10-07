using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

class SearchView extends Ui.View {
	
	var width;
	var height;
	
	function initialize(sensor) {
		sensor.search(method(:onSearch));
	}

	function onSearch (ids) {
		// create menu
		var menu = new Menu();
		for (var i = 0; i < ids.length; i++) {
			menu.addItem(ids[i], ids[i]);
		}
		// push menu
		Ui.pushView(menu, new SearchMenuDelegate(), Ui.SLIDE_IMMEDIATE);
	}

    //! Load your resources here
    function onLayout(dc) {
    	width = dc.getWidth();
    	height = dc.getHeight();
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {

    }

    //! Update the view
    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);

		dc.clear();
		
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);

		dc.drawText(dc.getWidth()/2, (dc.getHeight()-dc.getFontHeight(Gfx.FONT_LARGE))/2, Gfx.FONT_LARGE, "Searching...", Gfx.TEXT_JUSTIFY_CENTER);		
		dc.drawText(dc.getWidth()/2, (dc.getHeight()-dc.getFontHeight(Gfx.FONT_SMALL)), Gfx.FONT_SMALL, "Cancel", Gfx.TEXT_JUSTIFY_CENTER);		
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {

    }

}

class SearchMenuDelegate extends Ui.MenuInputDelegate {

    function onMenuItem(item) {
		LoggingHelper.write("Selected PM id " + item);
    }

}
