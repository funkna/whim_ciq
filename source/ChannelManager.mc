using Toybox.System;

class ChannelManager
{
    const MAX_CHANNELS = 8;

    var channels = new[MAX_CHANNELS];

    function initialize() {
        // Initialize all channels
        for( var i = 0; i < MAX_CHANNELS; i++ ) {
            channels[i] = new WhimChannel();
        }
        // Open channel 0 to begin searching
        channels[0].open();
    }

    function shutDown()
    {
        var state;

        // Close and release all channels
        for( var i = 0; i < 8; i++ ) {
            state = channels[i].getState();
            if (state == STATE_PAIRED || state == STATE_SEARCHING) {
                channels[i].close();
                channels[i].release();
            }
            else if (state == STATE_CLOSED) {
                channels[i].release();
            }
        }
    }

    /*
     * Opens new channel to search, if there is not already a channel
     * searching.
     */
    function openSearchChannel() {
        var index = getAvailableChannelIndex();
        if (-1 != index) {
            channels[index].open();
        }
    }

    /*
     * Returns index of the next channel available to open for searching.
     * If there is already a channel searching, -1 will be returned.
     */
    function getAvailableChannelIndex() {
        var channelIndex = -1;
        var alreadySearching = false;

        for( var i = ( MAX_CHANNELS - 1 ); i >= 0; i-- )
        {
            switch( channels[i].getState() ) {
                case STATE_CLOSED:
                    channelIndex = i;
                    break;

                case STATE_SEARCHING:
                    alreadySearching = true;
                    break;

                case STATE_PAIRED:
                    // Do nothing
                    break;

                case STATE_UNACQUIRED:
                    System.println( "ERROR: Channel " + i + " is unacquired" );
                    break;

                default:
                    System.println( "ERROR: Unkown channel state in channelManager.getAvailableChannelIndex()" );
                    break;
            }
        }

        if (alreadySearching) {
            return -1;
        }
        else {
            return channelIndex;
        }
    }


    function sendResetDataCommand(id) {
        for( var i = 0; i < MAX_CHANNELS; i++ ) {
            if( id == channels[i].getDeviceNumber() ){
                channels[i].sendResetDataCommand();
                return true;
            }
        }
        return false;
    }
}
