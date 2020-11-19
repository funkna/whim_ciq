using Toybox.Ant;
using Toybox.System;
using Toybox.WatchUi;

enum {
    UNACQUIRED,
    CLOSED,
    OPEN
}

class WHIMChannel extends Ant.GenericChannel
{
    const DEVICE_NUMBER = 0;
    const DEVICE_TYPE = 23;
    const TRANS_TYPE = 0;
    const MSG_PERIOD = 8192;
    const FREQUENCY = 66;

    var state = UNACQUIRED;

    function initialize() {
        try {
            // Get the channel
            var chanAssign = new Ant.ChannelAssignment(Ant.CHANNEL_TYPE_RX_NOT_TX, Ant.NETWORK_PUBLIC);
            GenericChannel.initialize(method(:onMessage), chanAssign);
            
            // Channel has been acquired, set to CLOSED state
            state = CLOSED;

            // Set the configuration
            var deviceConfig = new Ant.DeviceConfig( {
                :deviceNumber => DEVICE_NUMBER,
                :deviceType => DEVICE_TYPE,
                :transmissionType => TRANS_TYPE,
                :messagePeriod => MSG_PERIOD,
                :radioFrequency => FREQUENCY } );
            GenericChannel.setDeviceConfig(deviceConfig);
            
            System.println( "Channel initialized and opened." );

        } catch ( ex instanceof UnableToAcquireChannelException ) {
            System.println( "ERROR: Unable to acquire channel" );
        } catch ( ex ) {
            System.println( "ERROR: Unexpected exception in Channel.initialize(): " + ex );
        }
    }

    function open() {
        // Attempt to open channel and handle accordingly
        if( GenericChannel.open() ) {
            state = OPEN;
        }
        else {
            System.println( "ERROR: Unable to open channel" );
        }
    }
    
    function close() {
        state = CLOSED;
        GenericChannel.close();
    }

    function release() {
        // Release channel if one has been acquired
        if( state != UNACQUIRED )
        {
            GenericChannel.release();
        }
    }

    function onMessage( msg ) {
        try {
            var payload = msg.getPayload();
            
            if (Ant.MSG_ID_BROADCAST_DATA == msg.messageId) {
                System.println( "Broadcast data received" );
                // TODO: Handle broadcast data messages

            } else if( Ant.MSG_ID_CHANNEL_RESPONSE_EVENT == msg.messageId ) {
                if( Ant.MSG_ID_RF_EVENT == payload[0] )
                {
                    var eventCode = payload[1];

                    switch( eventCode ) {
                        case Ant.MSG_CODE_EVENT_RX_FAIL:
                            System.println( "RX_FAIL" );
                            break;
                        case Ant.MSG_CODE_EVENT_TX:
                            System.println( "EVENT_TX" );
                            break;
                        case Ant.MSG_CODE_EVENT_CHANNEL_CLOSED:
                            System.println( "CHANNEL_CLOSED" );
                            checkChannelClosure();
                            break;
                        case Ant.MSG_CODE_EVENT_RX_FAIL_GO_TO_SEARCH:
                            System.println( "RX_FAIL_GO_TO_SEARCH" );
                            break;
                        default:
                            handleUnexpectedAntEvent( eventCode );
                            break;
                    }
                }
            }
        } catch ( ex ) {
            GenericChannel.close();
            state = CLOSED;
            System.println( "ERROR: Unexpected exception in Channel.onMessage()", ex );
            WatchUi.requestUpdate();
        }
    }

    function checkChannelClosure() {
        if( CLOSED != state )
        {
            System.println( "ERROR: Channel closed unexpectedly" );
            state = CLOSED;
            WatchUi.requestUpdate();
        }
    }

    function handleUnexpectedAntEvent( eventCode ) {
        System.println( "Unhandled ANT event: " + eventCode );
        WatchUi.requestUpdate();
    }
}
