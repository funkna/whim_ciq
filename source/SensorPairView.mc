using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Timer;
using Toybox.Lang;
using Toybox.Communications;

class SensorPairView extends WatchUi.View {

    const VIEW_ID = PAIR;

    hidden var mCounter, mMessages, mTimer;

    function initialize() {
        View.initialize();
        mCounter = 0;
        mMessages = [Rez.Strings.text_waiting_for_message1, Rez.Strings.text_waiting_for_message2, Rez.Strings.text_waiting_for_message3];
        mTimer = new Timer.Timer();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.SensorPair(dc));
        current_view_id = VIEW_ID;
        View.findDrawableById("title").setText(Rez.Strings.AppName);
    }

    function timerCallback() {
        WatchUi.requestUpdate();
    }

    // Called when this View is brought to the foreground.
    function onShow() {
        View.onShow();
        mTimer.start(method(:timerCallback), 500, true);
    }

    // Update the view
    function onUpdate(dc) {
        View.findDrawableById("message").setText(mMessages[mCounter]);
        mCounter++;
        if (mCounter == mMessages.size()) {
            mCounter = 0;
        }

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen.
    function onHide() {
        mTimer.stop();
    }
}

class SensorPairDelegate extends WHIMBehaviorDelegate {

    function initialize(view) {
        WHIMBehaviorDelegate.initialize(view);
    }

    function onKey(keyEvent) {
        //TODO: Remove this test key to switch views without an ANT connection.
        var view = new SensorDetailsView();
        WatchUi.switchToView(view, new SensorDetailsDelegate(view), WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

}

