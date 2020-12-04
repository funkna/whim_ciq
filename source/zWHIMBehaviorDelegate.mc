using Toybox.WatchUi;

//! A custom BehaviorDelegate that lets us use the next and previous
//! page events as well as adding an onEnter() event.
class WHIMBehaviorDelegate extends WatchUi.BehaviorDelegate {

    hidden var mDevice;
    var relatedView;

    function initialize(view) {
        BehaviorDelegate.initialize();
        mDevice = WatchUi.loadResource(Rez.Strings.device);
        relatedView = view;
    }

    function onKey(evt) {
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

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    function onTap() {
        return true;
    }
}

