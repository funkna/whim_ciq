using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Timer;
using Toybox.Lang;
using Toybox.Communications;

class SensorPairView extends WatchUi.View {

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
        View.findDrawableById("title").setText(Rez.Strings.AppName);
    }
    
    function timerCallback() {
        WatchUi.requestUpdate();
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    	View.onShow();
        mTimer.start(method(:timerCallback), 500, true);
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        View.findDrawableById("message").setText(mMessages[mCounter]);
        mCounter++;
        if (mCounter == mMessages.size()) {
            mCounter = 0;
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
        mTimer.stop();
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}

class SensorPairDelegate extends WHIMBehaviorDelegate {

	function initialize(view) {
        WHIMBehaviorDelegate.initialize(view);
    }

    function onKey(keyEvent) {
        var view = new SensorDetailsView();
        WatchUi.switchToView(view, new SensorDetailsDelegate(view), WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

}
