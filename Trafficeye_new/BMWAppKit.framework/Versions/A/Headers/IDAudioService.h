/*  
 *  IDAudioService.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */


#import <Foundation/Foundation.h>
#import "IDService.h"


@class IDAudioService;

/*!
 @enum IDAudioState
 @abstract Defines possible states of the audio service.
 @constant IDAudioStateActivePlaying Used to indicate a playing audio channel (i.e. the application is now the active
 active audio source).
 @constant IDAudioStateActiveMuted Used to indicate a muted audio channel (i.e. the audio channel was muted by the user
 or by the audio master in the head unit).
 @constant IDAudioStateInactive Used to indicate an inactive audio channel.
 */
typedef enum  {
    IDAudioStateActivePlaying,
    IDAudioStateActiveMuted,
    IDAudioStateInactive
} IDAudioState;

/*!
 @enum IDAudioButtonEvent
 @abstract Defines possible events for the skip buttons of the mutltimedia system.
 @constant IDAudioButtonEventSkipUp This event can be triggered by shortly pressing the up or next button.
 @constant IDAudioButtonEventSkipDown  This event can be triggered by shortly pressing the down or previous button.
 @constant IDAudioButtonEventSkipLongUp  This event can be triggered by long pressing the up or next button.
 @constant IDAudioButtonEventSkipLongDown This event can be triggered by long pressing the down or previous button.
 @constant IDAudioButtonEventSkipStop This event is triggered by releasing a button after a long press.
 */
typedef enum {
    IDAudioButtonEventSkipUp,
    IDAudioButtonEventSkipDown,
    IDAudioButtonEventSkipLongUp,
    IDAudioButtonEventSkipLongDown,
    IDAudioButtonEventSkipStop
} IDAudioButtonEvent;

#pragma mark -
#pragma mark IDAudioServiceDelegate protocol

/*!
 @protocol IDAudioServiceDelegate
 @abstract Audio Service Delegate protocol.
 @discussion Implement this protocol if you would like to receive callbacks for state changes of the audio service and multimedia button events. It is vital for the audio system (audio source mixing) within the hmi that the iOS application using BMWAppKit respects the delegate calls. No playback before a channel is switched to active playing or after the channel was set to inactive.
 */
@protocol IDAudioServiceDelegate <NSObject>

@required

/*!
 @method audioService:entertainmentStateChanged:
 @abstract Inform the delegate that the state of the entertainment channel has changed.
 @param audioService the IDAudioService responsible for the channel that changed state
 @param newState the new state of the channel
 */
- (void)audioService:(IDAudioService *)audioService entertainmentStateChanged:(IDAudioState)newState;

/*!
 @method audioService:interruptStateChanged:
 @abstract Inform the delegate that the state of the interrupt channel has changed.
 @param audioService the IDAudioService responsible for the channel that changed state
 @param newState the new state of the channel
 */
- (void)audioService:(IDAudioService *)audioService interruptStateChanged:(IDAudioState)newState;

/*!
 @method audioService:multimediaButtonEvent:
 @abstract Inform the delegate that an multimedia button event was received from the remote hmi.
 @discussion Button events are generatd when the driver of a vehicle uses a physical multimedia button in his vehicle.
 @param audioService the audio service that received the event from the remote hmi
 @param buttonEvent the button event that represents the physical button in the vehicle
 */
- (void)audioService:(IDAudioService *)audioService multimediaButtonEvent:(IDAudioButtonEvent)buttonEvent;

@end

#pragma mark -
#pragma mark IDAudioService

/*!
 @class IDAudioService
 @abstract Service class for audio related hmi functionality.
 @discussion The audio service is used to control audio channels within the head unit. An application using BMWAppKit is required to request a audio channel before it might start audio playback. Also the hmi needs to know if the application no longer requires the channel. The audio service supports entertainment and interrupt audio (different mixing behavior). Only one channel should be used at a time. Using both channels at the same time is not officaly supported and might lead to unexpected behavior. For starting the playback of entertainment audio from an iOS device (e.g. a music or podcast player) an app would have to request an entertainment channel with -activateEntertainment and release the entertainment channel with deactivateEntertainment. For playing short audio sequences like notification sounds or navigation instructions an app can use activateInterrupt to interrupt the vehicle's current entertainment auido playback. After playing the audio sequence the application is supposed to close the interrupt channel by calling deactivateInterrupt. This will cause the vehicle's entertainment audio source to continue playback. The delegate of the audio service will receive callbacks whenever the state of an entertainment or interrupt channel changes. Furthermore the delegate will also receive callbacks whenever a skip button is pressed either on the steering wheel or in the vehicle's center stack.
 */
@interface IDAudioService : IDService

/*!
 @method activateEntertainment
 @abstract Request to activate the entertainment audio channel.
 @discussion Result is sent asyncronously via the delegate. Noop if channel is allready activated.
This method should be called before an iOS application intends to play entertainment audio through the vehicle's audio system.
 The audio system delegate gets informed asynchronously about the entertainment channel's state.
 */
- (void)activateEntertainment;

/*!
 @method deactivateEntertainment
 @abstract Request to deactivate the entertainment audio channel.
 @discussion Result is sent asyncronously via the delegate. Noop if channel is allready deactivated. This smethod should be called when an iOS application wants to stop playing entertainment audio. The vehicle's audio master will fall back to the entertainment audio source that was active right before activateEntertainment was called. The audio system delegate gets informed asynchronously about the entertainment channel's state.
 */
- (void)deactivateEntertainment;

/*!
 @method activateInterrupt
 @abstract Request to actiate the interrupt audio channel.
 @discussion Result is sent asyncronously via the delegate. Noop if channel is allready activated. This method should be called before an iOS application intends to play interrupt audio sequences through the vehicle's audio system. The vehicle's audio master will fade the audio interruption over the currently playing entertainment audio source if it is one of the vehicle's native audio sources (e.g. radio, CD/Multimedia, ...). If the app is also the active entertainement source then the app has to take care of mixing the audio interruption into the entertainment audio stream on its own. The audio system delegate gets informed asynchronously about the interrupt channel's state.
 */
- (void)activateInterrupt;

/*!
 @method deactivateInterrupt
 @abstract Request to deactivate the interrupt audio channel. Result is sent asyncronously via the delegate.
 @discussion Result is sent asyncronously via the delegate. Noop if channel is allready deactivated.
 */
- (void)deactivateInterrupt;

/*!
 @property delegate
 @abstract The Audio Service delegate is passed updates when changes to audio state occur.
 @discussion After setting the delegate, have it initially check the current state and react accordingly. Only new audio state changes will be automatically passed to the delegate.
 */
@property (assign) id<IDAudioServiceDelegate> delegate;

/*!
 @property entertainmentAudioState
 @abstract Current entertainment channel audio state. Not KVO compliant.
 */
@property (readonly, nonatomic) IDAudioState entertainmentAudioState;

/*!
 @property interruptAudioState
 @abstract Current interrupt channel audio state. Not KVO compliant.
 */
@property (readonly, nonatomic) IDAudioState interruptAudioState;

@end
