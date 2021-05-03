using Toybox.System;
using Toybox.Lang;
using Toybox.WatchUi;

class CommandMenuDelegate extends WatchUi.Menu2InputDelegate {

    var mDevId;

    function initialize(devId) {
        mDevId = devId;
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        var id = item.getId();
        if(id == Rez.Strings.text_id_rename) {
            var view = new SensorRenameView(mDevId);
            WatchUi.pushView(view, new SensorRenameDelegate(view), WatchUi.SLIDE_BLINK);

        } else if(id == Rez.Strings.text_id_reset_data) {
            if(channelManager.sendResetDataCommand(mDevId)) {
                System.println("Reset command sent");
            }
            else {
                System.println("ERROR: Failed to send reset command.");
            }
            WatchUi.popView(WatchUi.SLIDE_BLINK);
        }
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_BLINK);
        return true;
    }
}
