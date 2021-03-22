using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Timer;
using Toybox.Lang;
using Toybox.Communications;
using Toybox.Application;

class SensorRenameView extends WatchUi.View {
    const MAX_DISPLAY_NAME_SIZE = 5;
    const SELECTION_CHAR = [Rez.Strings.text_rename1, Rez.Strings.text_rename2];

    // These consts must match the drawable id's in layout_sensor_rename.xml
    const DISPLAY_ID_DRAWABLE_IDS = ["c1", "c2", "c3", "c4", "c5"];
    const SCROLL_UP_DRAWABLE_IDS = ["c1_up", "c2_up", "c3_up", "c4_up", "c5_up"];
    const SCROLL_DOWN_DRAWABLE_IDS = ["c1_down", "c2_down", "c3_down", "c4_down", "c5_down"];
    const SELECTION_DRAWABLE_IDS = ["c1_select", "c2_select", "c3_select", "c4_select", "c5_select"];
    const ALLOWED_DISPLAY_ID_CHARACTERS = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ' ',
                                           'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
                                           'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];

    var mDisplayName, mDisplayCharIndexes = new[MAX_DISPLAY_NAME_SIZE];
    var mSelection, mValueSelection, mDeviceId;
    hidden var mCounter, mTimer;

    function initialize(device_id) {
        mDeviceId = device_id;

        var stored_display_id = Application.Storage.getValue(device_id);
        if(stored_display_id == null)
        {
            mDisplayName = device_id.toString().toCharArray();
        }
        else
        {
            mDisplayName = stored_display_id.toString().toCharArray();
        }

        for(var i = 0; i < MAX_DISPLAY_NAME_SIZE; i++)
        {
            if(i < mDisplayName.size())
            {
                for(var j = 0; j < ALLOWED_DISPLAY_ID_CHARACTERS.size(); j++)
                {
                    if(ALLOWED_DISPLAY_ID_CHARACTERS[j] == mDisplayName[i])
                    {
                        mDisplayCharIndexes[i] = j;
                    }
                }
            }
            else
            {
                mDisplayCharIndexes[i] = 10;
            }
        }

        mSelection = 0;
        mValueSelection = mDisplayCharIndexes[mSelection];
        mCounter = 0;
        mTimer = new Timer.Timer();
        View.initialize();
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
        for(var i = 0; i < MAX_DISPLAY_NAME_SIZE; i++)
        {
            if(i < mDisplayName.size()) //Display name may be shorter than MAX_DISPLAY_NAME_SIZE
            {
                View.findDrawableById(DISPLAY_ID_DRAWABLE_IDS[i]).setText(mDisplayName[i].toString());
            }
            //User has cursor over the current character in this loop
            if(i == mSelection)
            {
                //Draw the next char upwards
                if(mValueSelection - 1 >= 0)
                {
                    View.findDrawableById(SCROLL_UP_DRAWABLE_IDS[i]).setText(ALLOWED_DISPLAY_ID_CHARACTERS[mValueSelection - 1].toString());
                }
                else
                {
                    View.findDrawableById(SCROLL_UP_DRAWABLE_IDS[i]).setText(" ");
                }

                //Draw the next char downwards
                if(mValueSelection + 1 < ALLOWED_DISPLAY_ID_CHARACTERS.size())
                {
                    View.findDrawableById(SCROLL_DOWN_DRAWABLE_IDS[i]).setText(ALLOWED_DISPLAY_ID_CHARACTERS[mValueSelection + 1].toString());
                }
                else
                {
                    View.findDrawableById(SCROLL_DOWN_DRAWABLE_IDS[i]).setText(" ");
                }

                //Draw the current state of the underscore cursor
                View.findDrawableById(SELECTION_DRAWABLE_IDS[i]).setText(SELECTION_CHAR[mCounter]);
            }
            else
            {
                View.findDrawableById(SCROLL_UP_DRAWABLE_IDS[i]).setText("");
                View.findDrawableById(SCROLL_DOWN_DRAWABLE_IDS[i]).setText("");
                View.findDrawableById(SELECTION_DRAWABLE_IDS[i]).setText("");
            }
        }

        mCounter++;
        if(mCounter == SELECTION_CHAR.size())
        {
            mCounter = 0;
        }

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen.
    function onHide() {
        mTimer.stop();
    }


    function selectNext() {
        if(mSelection < MAX_DISPLAY_NAME_SIZE - 1)
        {
            mSelection++;
            mValueSelection = mDisplayCharIndexes[mSelection];
            if(mDisplayName.size() <= mSelection)
            {
                mDisplayName.add(ALLOWED_DISPLAY_ID_CHARACTERS[mValueSelection]);
            }
        }
        else
        {
            var new_name = "";
            for(var i = 0; i < MAX_DISPLAY_NAME_SIZE; i++)
            {
                if(i < mDisplayName.size())
                {
                    new_name = new_name + mDisplayName[i].toString();
                }
            }
            Application.Storage.setValue(mDeviceId, new_name);
            System.println("Saving ID " + mDeviceId + " with display ID " + new_name);
            WatchUi.popView(WatchUi.SLIDE_BLINK);
            WatchUi.popView(WatchUi.SLIDE_BLINK);
        }
    }

    function selectPrevious() {
        if(mSelection > 0)
        {
            mSelection--;
            mValueSelection = mDisplayCharIndexes[mSelection];
            if(mDisplayName.size() <= mSelection)
            {
                mDisplayName.add(ALLOWED_DISPLAY_ID_CHARACTERS[mValueSelection]);
            }
        }
        else
        {
           WatchUi.popView(WatchUi.SLIDE_BLINK);
        }
    }

    function scrollUpSelection() {
        if(mValueSelection > 0)
        {
            mValueSelection--;
        }
        mDisplayName[mSelection] = ALLOWED_DISPLAY_ID_CHARACTERS[mValueSelection];
    }

    function scrollDownSelection() {
        if(mValueSelection < ALLOWED_DISPLAY_ID_CHARACTERS.size() - 1)
        {
            mValueSelection++;
        }
        mDisplayName[mSelection] = ALLOWED_DISPLAY_ID_CHARACTERS[mValueSelection];
    }
}

class SensorRenameDelegate extends  WatchUi.BehaviorDelegate  {

    var mView;

    function initialize(view) {
        BehaviorDelegate.initialize(view);
        mView = view;
    }

    function onSelect()
    {
        mView.selectNext();
        WatchUi.requestUpdate();
        return true;
    }

    function onBack()
    {
        mView.selectPrevious();
        WatchUi.requestUpdate();
        return true;
    }

    function onNextPage()
    {
        mView.scrollDownSelection();
        WatchUi.requestUpdate();
        return true;
    }


    function onPreviousPage()
    {
        mView.scrollUpSelection();
        WatchUi.requestUpdate();
        return true;
    }
}

