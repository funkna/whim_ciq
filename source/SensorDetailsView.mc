using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Timer;
using Toybox.Lang;

var impacts = 1;

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

        if (impacts > 0) {
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

    function initialize(view) {
        WHIMBehaviorDelegate.initialize(view);
    }

    function onEnter() {
        return true;
    }

    function onNextPage() {
        return true;
    }

    function onPreviousPage() {
        return true;
    }

}

