using Toybox.System;

class ViewManager
{
    const MAX_SENSORS = 8;

    var deviceNumbers = new [MAX_SENSORS];
    var impactCounts = new[MAX_SENSORS];
    var currentViewIndex = -1;
    var numOfConnectedSensors = 0;
    var view;

    function initialize() {
        for( var i = 0; i < MAX_SENSORS; i++ ) {
            deviceNumbers[i] = -1;
            impactCounts[i] = -1;
        }
    }

    // Add sensor
    function addSensor( deviceNumber, impactCount ) {
        deviceNumbers[numOfConnectedSensors] = deviceNumber;
        impactCounts[numOfConnectedSensors] = impactCount;
        numOfConnectedSensors++;

        if (numOfConnectedSensors == 1) {
            currentViewIndex = 0;
            view = new SensorDetailsView(
                    deviceNumbers[currentViewIndex],
                    impactCounts[currentViewIndex],
                    currentViewIndex,
                    numOfConnectedSensors);
            WatchUi.switchToView(view, new SensorDetailsDelegate(view), WatchUi.SLIDE_BLINK);
        }
        else
        {
            view.pairedDevices = numOfConnectedSensors;
            WatchUi.requestUpdate();
        }
    }

    // Delete sensor
    function deleteSensor( deviceNumber ) {
        // Find index of sensor to delete
        var indexToDelete = -1;
        for( var i = 0; i < numOfConnectedSensors; i++ ) {
            if (deviceNumber == deviceNumbers[i]) {
                indexToDelete = i;
                break;
            }
        }

        // Overwrite sensor and compress array
        for( var i = indexToDelete; i < numOfConnectedSensors; i++ ) {
            deviceNumbers[i] = deviceNumbers[i+1];
            impactCounts[i] = impactCounts[i+1];
        }

        // Decrement number of connected sensors
        numOfConnectedSensors--;

        if (numOfConnectedSensors == 0) {
            currentViewIndex = -1;
            view = new SensorPairView();
            WatchUi.switchToView(view, new SensorPairDelegate(view), WatchUi.SLIDE_BLINK);
        }
        else {
            if (currentViewIndex == numOfConnectedSensors) {
                currentViewIndex--;
            }
            view = new SensorDetailsView(
                    deviceNumbers[currentViewIndex],
                    impactCounts[currentViewIndex],
                    currentViewIndex,
                    numOfConnectedSensors);
            WatchUi.switchToView(view, new SensorDetailsDelegate(view), WatchUi.SLIDE_BLINK);
        }
    }

    // Update impact count for a sensor
    function updateImpactCount(deviceNumber, impactCount) {
        var sensorIndex;
        for( var i = 0; i < numOfConnectedSensors; i++ ) {

            if (deviceNumbers[i] == deviceNumber) {
                impactCounts[i] = impactCount;
                if (currentViewIndex == i) {
                    view.setImpactCount( impactCount );
                }
                break;
            }

        }
        WatchUi.requestUpdate();
    }

    // Go to next sensor
    function nextSensor() {
        currentViewIndex++;
        if (currentViewIndex == numOfConnectedSensors) {
            currentViewIndex = 0;
        }
        view = new SensorDetailsView(
                deviceNumbers[currentViewIndex],
                impactCounts[currentViewIndex],
                currentViewIndex,
                numOfConnectedSensors);
        WatchUi.switchToView(view, new SensorDetailsDelegate(view), WatchUi.SLIDE_UP);
    }

    // Go to previous sensor
    function previousSensor() {
        if (currentViewIndex == 0) {
            currentViewIndex = numOfConnectedSensors;
        }
        currentViewIndex--;
        view = new SensorDetailsView(
                deviceNumbers[currentViewIndex],
                impactCounts[currentViewIndex],
                currentViewIndex,
                numOfConnectedSensors);
        WatchUi.switchToView(view, new SensorDetailsDelegate(view), WatchUi.SLIDE_DOWN);
    }

}
