using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Timer;
using Toybox.Lang;
using Toybox.Application;

class SensorDetailsView extends WatchUi.View {

    const INDICATOR_X_POSITIONS = [15, 12, 10, 9, 9, 10, 12, 15];
    const INDICATOR_Y_POSITIONS = [85, 95, 105, 115, 125, 135, 145, 155];
    const BASE_INDICATOR_SIZE = 3;
    const SELECTION_INDICATOR_SIZE = 5;
    const BASE_COLOR = Graphics.COLOR_LT_GRAY;
    const ALERT_COLOR = Graphics.COLOR_RED;
    const SELECTION_COLOR = Graphics.COLOR_BLACK;

    const VIEW_ID = DETAILS;

    var deviceNumber;
    var largestHic, latestHic, impactCount;
    var selectedIndex;
    var pairedDevices;
    var displayId, displayIdCleaned;

    function initialize( aDeviceNumber, aImpactCount, aLargestHic, aLatestHic, aSelectedIndex, aPairedDevices ) {
        deviceNumber = aDeviceNumber;
        impactCount = aImpactCount;
        largestHic = aLargestHic;
        latestHic = aLatestHic;
        selectedIndex = aSelectedIndex;
        pairedDevices = aPairedDevices;
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.SensorDetails(dc));
        View.findDrawableById("sensor").setText(Rez.Strings.text_sensor_id);
        View.findDrawableById("impacts").setText(Rez.Strings.text_impacts);
        View.findDrawableById("largest_hic").setText(Rez.Strings.text_largest_hic);
        View.findDrawableById("latest_hic").setText(Rez.Strings.text_latest_hic);
    }

    // Called when this View is brought to the foreground.
    function onShow() {
        var stored_display_id = Application.Storage.getValue(deviceNumber);
        if(stored_display_id == null)
        {
            displayId = deviceNumber.toString();
        }
        else
        {
            displayId = stored_display_id;
        }
        displayIdCleaned = trimTrailingWhitespace(displayId);
        View.onShow();
    }

    // Update the view
    function onUpdate(dc) {
        View.findDrawableById("impacts_field").setText(impactCount.toString());
        View.findDrawableById("sensor_field").setText(displayIdCleaned.toString());

        View.findDrawableById("largest_hic_field").setText(largestHic.toString());
        View.findDrawableById("latest_hic_field").setText(latestHic.toString());

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        drawViewDetails(dc);
        drawDeviceIndicators(dc);
    }

    // Called when this View is removed from the screen.
    function onHide() {
    }

    private function drawViewDetails(dc) {
        dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_DK_RED);
        dc.drawLine(20, 80, 220, 80);
        dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_DK_RED);
        dc.drawLine(20, 160, 220, 160);
        dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_DK_RED);
        dc.drawLine(120, 80, 120, 160);
    }

    private function drawDeviceIndicators(dc) {
        for(var i = 0; i < pairedDevices; i++)
        {
            dc.setColor(BASE_COLOR, BASE_COLOR);
            dc.fillCircle(INDICATOR_X_POSITIONS[i], INDICATOR_Y_POSITIONS[i], BASE_INDICATOR_SIZE);

            if (i == selectedIndex)
            {
                dc.setColor(SELECTION_COLOR, SELECTION_COLOR);
                dc.drawCircle(INDICATOR_X_POSITIONS[i], INDICATOR_Y_POSITIONS[i], SELECTION_INDICATOR_SIZE);
            }
        }
    }

    function setImpactCount( aImpactCount ) {
        impactCount = aImpactCount;
    }

    function setLargestHic( aLargestHic ) {
        largestHic = aLargestHic;
    }

    function setLatestHic( aLatestHic ) {
        latestHic = aLatestHic;
    }

    function trimTrailingWhitespace( aString ) {
        var str_char_arr = aString.toCharArray();
        var index_to_trim = str_char_arr.size();
        for(var i = str_char_arr.size() - 1; i > 0; i--) {
            if(str_char_arr[i] == ' ') {
                index_to_trim = i;
            }
            else
            {
                break;
            }
        }
        return aString.substring(0, index_to_trim);
    }
}

class SensorDetailsDelegate extends WHIMBehaviorDelegate {

    var mTimer;
    var mView;

    function initialize(view) {
        WHIMBehaviorDelegate.initialize(view);
        mView = view;
        mTimer = new Timer.Timer();
    }

    function timerCallback() {
        mTimer.stop();
        WatchUi.pushView(initializeMenu(mView.displayId), new CommandMenuDelegate(mView.deviceNumber), WatchUi.SLIDE_BLINK); // Switch views if the UP key is held long enough
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

    private function initializeMenu(aDisplayId) {
        var menu = new WatchUi.Menu2( {:title => aDisplayId} ); //TODO: Use a meaningful name.
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

