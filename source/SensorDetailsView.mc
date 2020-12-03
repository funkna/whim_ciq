using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Timer;
using Toybox.Lang;

var impacts = 0;

class SensorDetailsView extends WatchUi.View {

    const VIEW_ID = DETAILS;

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.SensorDetails(dc));
        current_view_id = VIEW_ID;
        View.findDrawableById("sensor_name").setText("ID");
        View.findDrawableById("impacts").setText(Rez.Strings.text_impacts);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
        View.onShow();
    }

    // Update the view
    function onUpdate(dc) {
        View.findDrawableById("impacts_field").setText(impacts.toString());

        if(impacts > 0) {
            View.findDrawableById("status").setColor(Graphics.COLOR_RED);
            View.findDrawableById("status").setText(Rez.Strings.text_status_urgent);
        }
        else {
            View.findDrawableById("status").setColor(Graphics.COLOR_GREEN);
            View.findDrawableById("status").setText(Rez.Strings.text_status_safe);
        }

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}


class SensorDetailsDelegate extends WHIMBehaviorDelegate {

    var mTimer;

    function initialize(view) {
        WHIMBehaviorDelegate.initialize(view);
        mTimer = new Timer.Timer();
    }

    function timerCallback() {
        mTimer.stop();
        var menu = new WatchUi.Menu2( {:title => "ID"} );
        menu.addItem(
            new WatchUi.MenuItem(
                Rez.Strings.text_command_rename,
                "",
                Rez.Strings.text_id_rename,
                null
            )
        );
        menu.addItem(
            new WatchUi.MenuItem(
                Rez.Strings.text_command_erase,
                "",
                Rez.Strings.text_id_erase,
                null
            )
        );
        WatchUi.switchToView(menu, new CommandMenuDelegate(), WatchUi.SLIDE_UP);
    }

    function onKey(keyEvent) {
        System.println(keyEvent.getKey() + " - " +keyEvent.getType()); //TODO: Delete debug line

        if(keyEvent.getKey() == KEY_UP) {
            System.println("TODO: Hold this key to switch to command view.");
            mTimer.start(method(:timerCallback), 400, true);
            return true;
        }
        return false;
    }

    function onEnter() {
        return false;
    }

    function onBack() {
        return false;
    }

    function onNextPage() {
        return false;
    }

    function onPreviousPage() {
        return false;
    }

}

