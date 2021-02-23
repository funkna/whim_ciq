using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Timer;
using Toybox.Lang;
using Toybox.Communications;

class SensorRenameView extends WatchUi.View {

    // These consts must match the drawable id's in layout_sensor_rename.xml
    const DISPLAY_ID_DRAWABLE_IDS = ["c1", "c2", "c3", "c4", "c5"];
    const SELECTION_DRAWABLE_IDS = ["c1_select", "c2_select", "c3_select", "c4_select", "c5_select"];
    const ALLOWED_DISPLAY_ID_CHARACTERS = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ' ',
                                           'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
                                           'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
    var mDisplayName = [];
    var mSelection, mValueSelection;
    hidden var mSelectChar = [];
    hidden var mCounter, mMessages, mTimer;

    function initialize(current_id) {
        View.initialize();
        mDisplayName = current_id.toString().toCharArray();
        mSelection = 0;
        mValueSelection = 0;
        mCounter = 0;
        mSelectChar = [Rez.Strings.text_rename1, Rez.Strings.text_rename2];
        mTimer = new Timer.Timer();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.SensorRename(dc));
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
        for(var i = 0; i < DISPLAY_ID_DRAWABLE_IDS.size() - 1; i++)
        {
            View.findDrawableById(DISPLAY_ID_DRAWABLE_IDS[i]).setText(mDisplayName[i].toString());
            View.findDrawableById(SELECTION_DRAWABLE_IDS[i]).setText(mSelectChar[0]);
            if(i == mSelection)
            {
                View.findDrawableById(SELECTION_DRAWABLE_IDS[i]).setText(mSelectChar[mCounter]);
            }
        }

        mCounter++;
        mCounter %= mSelectChar.size();

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen.
    function onHide() {
        mTimer.stop();
    }
}

class SensorRenameDelegate extends WHIMBehaviorDelegate {

    var mTimerUp, mTimerDown;
    var mView;

    function initialize(view) {
        WHIMBehaviorDelegate.initialize(view);
        mView = view;
        mTimerUp = new Timer.Timer();
        mTimerDown = new Timer.Timer();
    }

    function timerCallbackUp() {
        mTimerUp.stop();
        if(mView.mSelection > 0)
        {
            mView.mSelection--;
            mView.mValueSelection = 0;
        }
        mView.requestUpdate();
    }

    function timerCallbackDown() {
        mTimerDown.stop();
        if(mView.mSelection < mView.DISPLAY_ID_DRAWABLE_IDS.size() - 1)
        {
            mView.mSelection++;
            mView.mValueSelection = 0;
        }
        mView.requestUpdate();
    }

    function onKeyPressed(keyEvent) {
        if(keyEvent.getKey() == KEY_UP) {
            mTimerUp.stop();
            mTimerUp.start(method(:timerCallbackUp), 400, true); // Start the timer when the UP key is held
            return true;
        }
        else if(keyEvent.getKey() == KEY_DOWN) {
            mTimerDown.stop();
            mTimerDown.start(method(:timerCallbackDown), 400, true); // Start the timer when the UP key is held
            return true;
        }
        else if(keyEvent.getKey() == KEY_ENTER) {
            System.println("Save name here.");
            return true;
        }
        else if(keyEvent.getKey() == KEY_ESC) {
            WatchUi.popView(WatchUi.SLIDE_BLINK);
            return true;
        }
        return false;
    }

    function onKeyReleased(keyEvent) {
        if(keyEvent.getKey() == KEY_UP) {
            mTimerUp.stop();
            if(mView.mValueSelection > 0)
            {
                mView.mValueSelection--;
            }
            mView.mDisplayName[mView.mSelection] = mView.ALLOWED_DISPLAY_ID_CHARACTERS[mView.mValueSelection];
            mView.requestUpdate();
            return true;
        }
        else if(keyEvent.getKey() == KEY_DOWN) {
            mTimerDown.stop();
            if(mView.mValueSelection < mView.ALLOWED_DISPLAY_ID_CHARACTERS.size() - 1)
            {
                mView.mValueSelection++;
            }
            mView.mDisplayName[mView.mSelection] = mView.ALLOWED_DISPLAY_ID_CHARACTERS[mView.mValueSelection];
            mView.requestUpdate();
            return true;
        }
        return false;
    }

}

