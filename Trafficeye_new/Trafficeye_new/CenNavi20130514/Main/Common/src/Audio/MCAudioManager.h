//
//  MCAudioManager.h
//  Connected
//
//  Created by Andreas Streuber on 05.12.11.
//  Copyright (c) 2011 BMW Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

/*!
 @class MCAudioManager
 @abstract The one clas to handle onboard and offboard audio within the fat app.
 @discussion The audio manager handles a single instance of IDAudioService to control access to audio for the FatApp.
 This class handles onboard as well as offboard audio. The MCAudioManager is the AVAudioSessionDelegate.
 This class uses the MCOfboarAudioService when not connected to the remote hmi.
 Switching from onboard to offboard will deactivate the interrupt and the enterteinment channel.
 Interrupt channels are not supported in offboard mode.
 @updated 2012-02-03
 
 TODO: check if we need to handle beginInterruption and endInterruption calls on AVAudioPlayerDelegate (e.g. restart FMOD, reconfigure AVAudiosession, ...)
 TODO: check if we need to reconfigure the AVAudioSession after a switch from onboard to offboard and vice versa
 
 */

@protocol MCAudioManagerDelegate;

@interface MCAudioManager : NSObject <IDAudioServiceDelegate, AVAudioSessionDelegate>

/*!
 @enum MCAudioManager reasons for route change
 @abstract These are reasons used when the audio route changes
 @constant MCAudioRouteChangeReasonUnknown
 The reason is unknown. (kAudioSessionRouteChangeReason_Unknown)
 @constant MCAudioRouteChangeReasonNewDeviceAvailable
 A new device became available (e.g. headphones have been plugged in). (kAudioSessionRouteChangeReason_NewDeviceAvailable)
 @constant MCAudioRouteChangeReasonOldDeviceUnavailable
 The old device became unavailable (e.g. headphones have been unplugged). (kAudioSessionRouteChangeReason_OldDeviceUnavailable)
 @constant MCAudioRouteChangeReasonCategoryChange
 The audio category has changed (e.g. kAudioSessionCategory_MediaPlayback has been changed to kAudioSessionCategory_PlayAndRecord). (kAudioSessionRouteChangeReason_CategoryChange)
 @constant MCAudioRouteChangeReasonOverride
 The route has been overridden (e.g. category is kAudioSessionCategory_PlayAndRecord and the output has been changed from the receiver, which is the default, to the speaker). (kAudioSessionRouteChangeReason_Override)
 @constant MCAudioRouteChangeReasonWakeFromSleep
 The device woke from sleep. (kAudioSessionRouteChangeReason_WakeFromSleep)
 @constant MCAudioRouteChangeReasonNoSuitableRouteForCategory
 Returned when there is no route for the current category (for instance RecordCategory but no input device). (kAudioSessionRouteChangeReason_NoSuitableRouteForCategory)
 */
typedef enum {
    MCAudioRouteChangeReasonUnknown = kAudioSessionRouteChangeReason_Unknown,
    MCAudioRouteChangeReasonNewDeviceAvailable = kAudioSessionRouteChangeReason_NewDeviceAvailable,
    MCAudioRouteChangeReasonOldDeviceUnavailable = kAudioSessionRouteChangeReason_OldDeviceUnavailable,
    MCAudioRouteChangeReasonCategoryChange = kAudioSessionRouteChangeReason_CategoryChange,
    MCAudioRouteChangeReasonOverride = kAudioSessionRouteChangeReason_Override,
    MCAudioRouteChangeReasonWakeFromSleep = kAudioSessionRouteChangeReason_WakeFromSleep,
    MCAudioRouteChangeReasonNoSuitableRouteForCategory = kAudioSessionRouteChangeReason_NoSuitableRouteForCategory
} MCAudioRouteChangeReason;

/*!
 @enum MCAudioManager output audio routes
 @abstract These constants represent the available routes for audio output.
 @constant MCAudioRouteHeadphones
 Speakers in a headset (mic and headphones) or simple headphones (kAudioSessionOutputRoute_Headphones)
 @constant MCAudioRouteBuiltInSpeaker
 The built-in speaker ( kAudioSessionOutputRoute_BuiltInSpeaker)
 @constant MCAudioRouteBuiltInReceiver
 The speaker you hold to your ear when on a phone call (kAudioSessionOutputRoute_BuiltInReceiver)
 @constant MCAudioRouteUSBAudio
 Speaker(s) in a Universal Serial Bus device (kAudioSessionOutputRoute_USBAudio)
 @constant MCAudioRouteHDMI
 Output via High-Definition Multimedia Interface (kAudioSessionOutputRoute_HDMI)
 @constant MCAudioRouteAirPlay
 Output on a remote Air Play device (kAudioSessionOutputRoute_AirPlay)
 @constant MCAudioRouteLineOut
 A line out output (kAudioSessionOutputRoute_LineOut)
 @constant MCAudioRouteBluetoothHFP
 Speakers that are part of a Bluetooth Hands-Free Profile device (kAudioSessionOutputRoute_BluetoothHFP)
 @constatn MCAudioRouteBluetoothA2DP
 Speakers in a Bluetooth A2DP device (kAudioSessionOutputRoute_BluetoothA2DP)
 @constant MCAudioRouteUnknown
 The output audio route is unknown
 */
typedef enum {
    MCAudioRouteUnknown = 0,
    MCAudioRouteHeadphones = 1,
    MCAudioRouteBuiltInSpeaker = 2,
    MCAudioRouteBuiltInReceiver = 3,
    MCAudioRouteUSBAudio = 4,
    MCAudioRouteHDMI = 5,
    MCAudioRouteAirPlay = 6,
    MCAudioRouteLineOut = 7,
    MCAudioRouteBluetoothHFP = 8,
    MCAudioRouteBluetoothA2DP = 9
} MCAudioRoute;

@property (assign, nonatomic) id<MCAudioManagerDelegate> audioDelegate;

/*!
 @method defaultAudioManager
 @abstract Method to retrieve the default MCAudioManager instance.
 @return MCAudioManager default instance
 */
+ (id)defaultAudioManager;

/*!
 @method activateEntertainmentChannel
 @abstract Method to activate an entertainment channel.
 @discussion This method will return immediately. After the method returns the delegate must not start playback. Instead it should wait for a audioManager:channelStateChanged: message.
 If the delegate already has an interrupt channel it has to call deactivateInterruptChannel before. Otherwise audioManager:channelStateChanged: is not called.
 */
- (void)activateEntertainmentChannel;

/*!
 deactivateEntertainmentChannelAndReleaseAVAudioSession
 @abstract Method to deactivate an entertainment channel.
 @discussion This method will return immediately. The delegate should stop playback before calling this method. It never should continue playback after calling this method.
 @param releaseAVAudioSession set current AVAudioSession to inactive
 */
- (void)deactivateEntertainmentChannelAndReleaseAVAudioSession:(BOOL)releaseAVAudioSession;

/*!
 @method activateInterruptChannel
 @abstract Method to activate an interrupt channel.
 @discussion This method will return immediately. After the method returns the delegate must not start playback. Instead it should wait for a audioManager:channelStateChanged: message.
 If the delegate already has an entertainment channel it has to call deactivateEntertainmentChannelAndReleaseAVAudioSession before. Otherwise audioManager:channelStateChanged: is not called.
 */
- (void)activateInterruptChannel;

/*!
 @method deactivateInterruptChannel
 @abstract Method to deactivate an interrupt channel.
 @discussion This method will return immediately. The delegate should stop playback before calling this method. It never should continue playback after calling this method.
 */
- (void)deactivateInterruptChannel;

/*!
 @method entertainmentChannelAudioState
 @abstract Method to retrieve the IDAudioState of the entertainment channel.
 @return the IDAudioState of the entertainment channel
 */
- (IDAudioState)entertainmentChannelAudioState;

/*!
 @method interruptChannelAudioState
 @abstract Method to retrieve the IDAudioState of the interrupt channel.
 @return the IDAudioState of the interrupt channel
 */
- (IDAudioState)interruptChannelAudioState;

@end

#pragma mark - MCAudioManagerDelegate protocol

@protocol MCAudioManagerDelegate <NSObject>


@required
/*!
 @method audioService
 @abstract Method that returns an audio service.
 @discussion The method must return an instance of IDAudioService.
 @return an instance of IDAudioService
 */
- (IDAudioService *)audioService;

/*!
 @method audioManager:channelStateChanged:
 @abstract Method to inform the delegate about state changes in a requested channel (interrupt or entertainment).
 @discussion The delegate MUST allways respect the IDAudioState passed in as second method argument.
 @param audioManager the MCAudioManager singleton instance
 @param newState the new audio state for the channel requested by the delegate
 */
- (void)audioManager:(MCAudioManager *)audioManager channelStateChanged:(IDAudioState)newState;

/*!
 @method audioManager:multimediaButtonEvent:
 @abstract Method to inform the delegate about multimeda button events from the hmi.
 @param audioManager the MCAudioManager singleton instance
 @param button the button event received from the hmi
 */
- (void)audioManager:(MCAudioManager *)audioManager multimediaButtonEvent:(IDAudioButtonEvent)button;

/*!
 @method audioManager:setPlaybackVolume:
 @abstract Method to set the volume of the delegate.
 @discussion The volume is a float value between 0.0f and 1.0f. The delegate must respect the volume set by the MCAudioManager singleton.
 @param audioManager the MCAudioManager singleton instance
 @param volume the volume for the delegate
 */
- (void)audioManager:(MCAudioManager *)audioManager setPlaybackVolume:(float)volume;

@optional

/*!
 @method audioManager:audioRouteDidChange:newAudioRoute:changeReason:
 @abstract Method to to notify the audio manager delegate about audio route changes.
 @param audioManager the MCAudioManager singleton instance
 @param oldAudioRoute the audio route before the change
 @param newAudioRoute the audio route after the change
 @param changeReason the reason why the audio route was changed
 */
- (void)audioManager:(MCAudioManager *)audioManager audioRouteDidChange:(MCAudioRoute)oldAudioRoute newAudioRoute:(MCAudioRoute)newAudioRoute changeReason:(MCAudioRouteChangeReason)changeReason;


@end
