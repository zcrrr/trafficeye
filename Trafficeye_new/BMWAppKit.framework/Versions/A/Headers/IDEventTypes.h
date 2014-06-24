/*  
 *  IDEventTypes.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

// TODO: header documentation


/*!
 @enum IDEventTypes
 @abstract Defines various possible event types.
 @constant IDEventFocus
    This event is fired when a component gets focussed or unfocussed.
    Parameters: 
        bool focus
 @constant IDEventRequestData
    This event is fired when an invalidated list request new data.
    Parameters: 
        bool from: list index from which data is needed
        bool to: list index to which data is needed
 @constant IDEventApplicationInit
    This event is fired when the remote application was 
    successfully integrated and can initialize its components.
 @constant IDEventIntegrationError
    This event is fired when something went wrong, e.g. when an invalid
    description was sent.
    Parameters: 
        uint32 errorcode
        string errorinfo
 @constant IDEventAudioChannel
    This event is fired when the audio channel status changes
    Parameters: 
        uint32 channelstatus
 @constant IDEventVideoChannel
    This event is fired when the video channel status changes
    Parameters: 
        uint32 channelstatus
 @constant IDEventSplitscreen
    This event is fired when splitscreen is enabled or disabled. This is done
    only for the terminalUI component.
    Parameters: 
        bool splitscreen: splitscreen state
 @constant IDEventApplicationRelease
    This event is fired when the remote application is released from
    the HMI side (e.g. if it does not respond for a long time)
 @constant IDEventKeyCode
    This event is not fired for all key events in the car but for very special 
    global ones like the skip buttons on the steering wheel, when a multimedia 
    connection was initiated by the remote application.
    Parameters: 
        uint32 keyCode (see PropertyTypes.h)
 @constant IDEventInternetConnection
    This event is fired when the status of the internet connection
    of the headunit changes.
    Parameters:
        uint32 internetconnectionstatus
 @constant IDEventVisible
    This event is fired when a component gets visible or invisible.
    Parameters: 
        bool visible
 @constant IDEventRestoreHmi
    This event is fired when this application was the last visible application and
    shall restore its last hmi state.
    Parameters: 
        int32 last state
 @constant IDEventRestoreAudio
    This event is fired when this application was the last visible application and
    shall restore its audio source.
 */
typedef enum IDEventTypes
{
    IDEventFocus = 1,
    IDEventRequestData = 2,
    IDEventApplicationInit = 3,
    IDEventIntegrationError = 4,
    IDEventAudioChannel = 5,
    IDEventVideoChannel = 6,
    IDEventSplitscreen = 7,
    IDEventApplicationRelease = 8,
    IDEventKeyCode = 9,
    IDEventInternetConnection = 10,
    IDEventVisible = 11,
    IDEventRestoreHmi = 12,
    IDEventRestoreAudio = 13
} IDEventTypes;

/*!
 @enum IDIntegrationErrorCodes
 @abstract Defines various possible integration error codes.
    @constant IDErrorDescriptionInvalid
    @constant IDErrorDataNotSet
    @constant IDErrorWrongVersion
    @constant IDErrorNotRegisteredBefore
    @constant IDErrorNotEnoughMemoryAvailable
    @constant IDErrorApplicationAlreadyLoaded
    @constant IDErrorDescriptionSizeInvalid
    @constant IDErrorNoHmiCommAdapter
 */
typedef enum IDIntegrationErrorCodes
{
    IDErrorDescriptionInvalid = 1,
    IDErrorDataNotSet = 2,
    IDErrorWrongVersion = 3,
    IDErrorNotRegisteredBefore = 4,
    IDErrorNotEnoughMemoryAvailable = 5,
    IDErrorApplicationAlreadyLoaded = 6,
    IDErrorDescriptionSizeInvalid = 7,
    IDErrorNoHmiCommAdapter = 8
} IDIntegrationErrorCodes;

/*!
 @enum IDChannelStatus
 @abstract Defines various possible channel states.
    @constant IDChannelNotAvailable
    @constant IDChannelAvailable
    @constant IDChannelGranted
    @constant IDChannelRemoved
 */
typedef enum IDChannelStatus
{
    IDChannelNotAvailable,
    IDChannelAvailable,
    IDChannelGranted,
    IDChannelRemoved
} IDChannelStatus;

/*!
 @enum IDSplitscreenStatus
 @abstract Defines various possible splitscreen states.
    @constant IDSplitscreenEnabled
    @constant IDSplitscreenDisabled
 */
typedef enum IDSplitscreenStatus
{
    IDSplitscreenEnabled,
    IDSplitscreenDisabled
} IDSplitscreenStatus;

/*!
 @enum IDInternetConnectionStatus
 @abstract Defines various possible internet connection states.
 @discussion 
    @constant IDInternetNotAvailable
    @constant IDInternetAvailable
    @constant IDInternetConnecting
    @constant IDInternetConnected
    @constant IDInternetDisconnected
    @constant IDInternetConnectionError
 */
typedef enum IDInternetConnectionStatus
{
    IDInternetNotAvailable,
    IDInternetAvailable,
    IDInternetConnecting,
    IDInternetConnected,
    IDInternetDisconnected,
    IDInternetConnectionError
} IDInternetConnectionStatus;
