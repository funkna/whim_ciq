using Toybox.System;

class ViewManager
{
    const MAX_SENSORS = 8;

    var deviceNumbers = new [MAX_SENSORS];
    var impactCounts = new[MAX_SENSORS];
    var largestHics = new[MAX_SENSORS];
    var latestHics = new[MAX_SENSORS];
    var currentViewIndex = -1;
    var numOfConnectedSensors = 0;
    var view;

    function initialize() {
        for( var i = 0; i < MAX_SENSORS; i++ ) {
            deviceNumbers[i] = -1;
            impactCounts[i] = -1;
            largestHics[i] = -1;
            latestHics[i] = -1;
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
                    largestHics[currentViewIndex],
                    latestHics[currentViewIndex],
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

        if( indexToDelete == -1 )
        {
            return;
        }

        // Overwrite sensor and compress array
        for( var i = indexToDelete; i < numOfConnectedSensors - 1; i++ ) {
            deviceNumbers[i] = deviceNumbers[i+1];
            impactCounts[i] = impactCounts[i+1];
            largestHics[i] = largestHics[i+1];
            latestHics[i] = latestHics[i+1];
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
                    largestHics[currentViewIndex],
                    latestHics[currentViewIndex],
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

    // Update largest HIC for a sensor
    function updateLargestHic(deviceNumber, largestHic) {
        var sensorIndex;
        for( var i = 0; i < numOfConnectedSensors; i++ ) {

            if (deviceNumbers[i] == deviceNumber) {
                largestHics[i] = largestHic;
                if (currentViewIndex == i) {
                    view.setLargestHic( largestHic );
                }
                break;
            }

        }
        WatchUi.requestUpdate();
    }

    // Update latest HIC for a sensor
    function updateLatestHic(deviceNumber, latestHic) {
        var sensorIndex;
        for( var i = 0; i < numOfConnectedSensors; i++ ) {

            if (deviceNumbers[i] == deviceNumber) {
                latestHics[i] = latestHic;
                if (currentViewIndex == i) {
                    view.setLatestHic( latestHic );
                }
                break;
            }

        }
        WatchUi.requestUpdate();
    }

    // Go to next sensor
    function nextSensor() {
        if (numOfConnectedSensors == 1) {
            return;
        }

        currentViewIndex++;
        if (currentViewIndex == numOfConnectedSensors) {
            currentViewIndex = 0;
        }
        view = new SensorDetailsView(
                deviceNumbers[currentViewIndex],
                impactCounts[currentViewIndex],
                largestHics[currentViewIndex],
                latestHics[currentViewIndex],
                currentViewIndex,
                numOfConnectedSensors);
        WatchUi.switchToView(view, new SensorDetailsDelegate(view), WatchUi.SLIDE_UP);
    }

    // Go to previous sensor
    function previousSensor() {
        if (numOfConnectedSensors == 1) {
            return;
        }
        else if (currentViewIndex == 0) {
            currentViewIndex = numOfConnectedSensors;
        }
        currentViewIndex--;
        view = new SensorDetailsView(
                deviceNumbers[currentViewIndex],
                impactCounts[currentViewIndex],
                largestHics[currentViewIndex],
                latestHics[currentViewIndex],
                currentViewIndex,
                numOfConnectedSensors);
        WatchUi.switchToView(view, new SensorDetailsDelegate(view), WatchUi.SLIDE_DOWN);
    }

}
