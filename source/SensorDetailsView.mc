using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Timer;
using Toybox.Lang;

class SensorDetailsView extends WatchUi.View {

    const VIEW_ID = DETAILS;

    var deviceNumber;
    var impactCount;

    function initialize( aDeviceNumber, aImpactCount ) {
        deviceNumber = aDeviceNumber;
        impactCount = aImpactCount;
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.SensorDetails(dc));
        View.findDrawableById("sensor_name").setText("ID"); //TODO: Use a meaningful name.
        View.findDrawableById("impacts").setText(Rez.Strings.text_impacts);
    }

    // Called when this View is brought to the foreground.
    function onShow() {
        View.onShow();
    }

    // Update the view
    function onUpdate(dc) {
        View.findDrawableById("impacts_field").setText(impactCount.toString());
        View.findDrawableById("sensor_name").setText(deviceNumber.toString());

        // TODO: Handle incoming data in a better manner.
        if(impactCount > 0) {
            View.findDrawableById("status").setColor(Graphics.COLOR_RED);
            View.findDrawableById("status").setText(Rez.Strings.text_status_urgent);
        }
        else {
            View.findDrawableById("status").setColor(Graphics.COLOR_GREEN);
            View.findDrawableById("status").setText(Rez.Strings.text_status_safe);
        }

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        addViewDetails(dc);
    }

    // Called when this View is removed from the screen.
    function onHide() {
    }

    private function addViewDetails(dc) {
        dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_DK_RED);
        dc.drawLine(20, 80, 220, 80);
        dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_DK_RED);
        dc.drawLine(20, 160, 220, 160);
    }

    function setImpactCount( aImpactCount ) {
        impactCount = aImpactCount;
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
        WatchUi.pushView(initializeMenu(), new CommandMenuDelegate(), WatchUi.SLIDE_BLINK); // Switch views if the UP key is held long enough
    }

    function onKeyPressed(keyEvent) {
        if(keyEvent.getKey() == KEY_UP) {
            mTimer.start(method(:timerCallback), 400, true); // Start the timer when the UP key is held
            return true;
        }
        else if(keyEvent.getKey() == KEY_DOWN ) {
            viewManager.nextSensor();
            return true;
        }
        return false;
    }

    function onKeyReleased(keyEvent) {
        if(keyEvent.getKey() == KEY_UP) {
            mTimer.stop(); // Stop the timer
            viewManager.previousSensor(); // Display previous sensor info
            return true;
        }
        return false;
    }

    private function initializeMenu() {
        var menu = new WatchUi.Menu2( {:title => "ID"} ); //TODO: Use a meaningful name.
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
                Rez.Strings.text_command_reset_data,
                "",
                Rez.Strings.text_id_reset_data,
                null
            )
        );
        return menu;
    }

}

