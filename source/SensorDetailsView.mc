using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;

class SensorDetailsView extends WatchUi.View {

    hidden var mImpacts, mIndex;

    function initialize() {
        View.initialize();
        mImpacts = 0;
		mIndex = 0;
		
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.SensorDetails(dc));
        View.findDrawableById("sensor_name").setText(Rez.Strings.text_sensor_name);
        View.findDrawableById("impacts").setText(Rez.Strings.text_impacts);
        View.findDrawableById("index").setText(Rez.Strings.text_index);
    }
    
    function onShow() {
        View.onShow();
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    
    	View.findDrawableById("impacts_field").setText(mImpacts.toString());
        View.findDrawableById("index_field").setText(mIndex.toString());
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

    function onBack() {
        var view = new SensorPairView();
        WatchUi.switchToView(view, new SensorPairDelegate(view), WatchUi.SLIDE_IMMEDIATE);
        return true;
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

