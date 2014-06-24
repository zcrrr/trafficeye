//
//  Created by Andreas Streuber on 16.12.11.
//  Copyright (c) 2011 BMW Group. All rights reserved.
//

#import "MCOffboardAudioService.h"


typedef enum {
    IDAudioConnectionTypeEntertainment = 0,
    IDAudioConnectionTypeInterrupt = 1,
    IDAudioConnectionTypeInvalid = 2
} IDAudioConnectionType;

typedef enum {
    IDAudioPlayerStatePlay,
    IDAudioPlayerStatePause,
    IDAudioPlayerStateStop,
    IDAudioPlayerStateInvalid
} IDAudioPlayerState;

@interface IDAudioService () {
    @protected
    IDAudioPlayerState _entertainmentAudioState;
    IDAudioPlayerState _interruptAudioState;
}

- (void)handleAudioConnectionDeniedEvent:(IDAudioConnectionType)connectionType;
- (void)handleAudioRequestPlayerStateEvent:(IDAudioConnectionType)connectionType playerState:(IDAudioPlayerState)state;
- (void)handleAudioConnectionGrantedEvent:(IDAudioConnectionType)connectionType;
- (void)handleAudioConnectionDeactivatedEvent:(IDAudioConnectionType)connectionType;
- (void)handleAudioButtonEvent:(IDAudioButtonEvent)button;

@end

@implementation MCOffboardAudioService

static NSString *const LOG_CATEGORY = @"MCOffboardAudioService";

- (id)init
{
    self = [super init];
    if (self)
    {
        _entertainmentAudioState = (IDAudioPlayerState)IDAudioStateInactive;
        _interruptAudioState = (IDAudioPlayerState)IDAudioStateInactive;
    }
    return self;
}

- (void)activateEntertainment
{
    /*
     This medhod will allways grant the entertainemnt channel request and return a play command.
     */
    [super handleAudioConnectionGrantedEvent:IDAudioConnectionTypeEntertainment];
    [super handleAudioRequestPlayerStateEvent:IDAudioConnectionTypeEntertainment playerState:IDAudioPlayerStatePlay];
}

- (void)deactivateEntertainment
{
    /*
     This medhod will deactive the entertainemnt connection and return a stop command.
     */
    [super handleAudioConnectionDeactivatedEvent:IDAudioConnectionTypeEntertainment];
}

- (void)activateInterrupt
{
    /*
     This method denies every activation request. Interrupt channel is not supported in offboard mode.
     */
    [super handleAudioConnectionDeniedEvent:IDAudioConnectionTypeInterrupt];
}

- (void)deactivateInterrupt
{
    /*
     Because we never grant a interrupt channel this method will do nothing.
     */
}

@end
