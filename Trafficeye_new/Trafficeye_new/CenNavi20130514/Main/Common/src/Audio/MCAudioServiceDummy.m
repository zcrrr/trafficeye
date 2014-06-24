//
//  MCAudioServiceDummy.m
//  Connected
//
//  Created by Andreas Streuber on 09.12.11.
//  Copyright (c) 2011 BMW Group. All rights reserved.
//

#import "MCAudioServiceDummy.h"
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

@implementation MCAudioServiceDummy

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
    MCLog(IDLogLevelWarn, @"activateEntertainment");

    [super handleAudioConnectionGrantedEvent:IDAudioConnectionTypeEntertainment];
    [super handleAudioRequestPlayerStateEvent:IDAudioConnectionTypeEntertainment playerState:IDAudioPlayerStatePlay];
}

- (void)deactivateEntertainment
{
    MCLog(IDLogLevelWarn, @"deactivateEntertainment");

    [super handleAudioConnectionDeactivatedEvent:IDAudioConnectionTypeEntertainment];
}

- (void)activateInterrupt
{
    [super handleAudioConnectionGrantedEvent:IDAudioConnectionTypeInterrupt];
    [super handleAudioRequestPlayerStateEvent:IDAudioConnectionTypeInterrupt playerState:IDAudioPlayerStatePlay];
}

- (void)deactivateInterrupt
{
    [super handleAudioConnectionDeactivatedEvent:IDAudioConnectionTypeInterrupt];
}

@end
