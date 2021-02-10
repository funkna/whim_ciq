using Toybox.Application;
using Toybox.WatchUi;

enum {
    PAIR,
    DETAILS
}

var channelManager;
var viewManager;

class WhimApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
        // Create channel manager to acquire all available ANT channels
        // and open one channel for search
        channelManager = new ChannelManager();
        // Initialize view manager
        viewManager = new ViewManager();
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
        // Close and release all ANT channels
        channelManager.shutDown();
    }

    // Return the initial view of your application here
    function getInitialView() {
        var view = new SensorPairView();
        return [ view, new SensorPairDelegate(view) ];
    }
}
