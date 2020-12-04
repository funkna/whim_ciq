using Toybox.Application;
using Toybox.WatchUi;

var current_view_id;

enum {
    PAIR,
    DETAILS
}

class WHIMApp extends Application.AppBase {

    var mChannel;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
        // Create channel object and open it
        mChannel = new WHIMChannel();
        mChannel.open();
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
        // Close and release the channel
        mChannel.close();
        mChannel.release();
    }

    // Return the initial view of your application here
    function getInitialView() {
        var view = new SensorPairView();
        return [ view, new SensorPairDelegate(view) ];
    }

}

