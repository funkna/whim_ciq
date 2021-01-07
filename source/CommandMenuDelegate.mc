using Toybox.System;
using Toybox.Lang;
using Toybox.WatchUi;

class CommandMenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        var id = item.getId();
        if(id == Rez.Strings.text_id_rename) {
            System.println("Rename Command Placeholder");
        } else if(id == Rez.Strings.text_id_reset_data) {
            whimChannel.sendResetDataCommand();
        }
    }

    function onBack() {
        var view = new SensorDetailsView();
        WatchUi.switchToView(view, new SensorDetailsDelegate(view), WatchUi.SLIDE_BLINK);
        return true;
    }
}

