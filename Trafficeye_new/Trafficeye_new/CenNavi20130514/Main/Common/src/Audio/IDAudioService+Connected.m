//
//  Created by Andreas Streuber on 06.12.11.
//  Copyright (c) 2011 BMW Group. All rights reserved.
//

#import "IDAudioService+Connected.h"

@implementation IDAudioService (Connected)

static NSDictionary *_idAudioStateStringMapping = nil;
static NSDictionary *_idAudioButtonEventMapping = nil;

+ (NSString *)stringWithIDAudioState:(IDAudioState)state
{
    if (!_idAudioStateStringMapping) {
        _idAudioStateStringMapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      @"IDAudioStateActivePlaying", [NSNumber numberWithInt:IDAudioStateActivePlaying],
                                      @"IDAudioStateActiveMuted", [NSNumber numberWithInt:IDAudioStateActiveMuted],
                                      @"IDAudioStateInactive", [NSNumber numberWithInt:IDAudioStateInactive],
                                      nil];
    }
    
    NSString *audioState = [_idAudioStateStringMapping objectForKey:[NSNumber numberWithInt:state]];
    
    if (!audioState || [audioState length] < 1) {
        return @"unknown IDAudioState";
    }
    
    return audioState;
}

+ (NSString *)stringWithIDAudioButtonEvent:(IDAudioButtonEvent)event
{
    if (!_idAudioButtonEventMapping) {
        _idAudioButtonEventMapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      @"IDAudioButtonEventSkipDown", [NSNumber numberWithInt:IDAudioButtonEventSkipDown],
                                      @"IDAudioButtonEventSkipLongDown", [NSNumber numberWithInt:IDAudioButtonEventSkipLongDown],
                                      @"IDAudioButtonEventSkipLongUp", [NSNumber numberWithInt:IDAudioButtonEventSkipLongUp],
                                      @"IDAudioButtonEventSkipLongUp", [NSNumber numberWithInt:IDAudioButtonEventSkipLongUp],
                                      @"IDAudioButtonEventSkipStop", [NSNumber numberWithInt:IDAudioButtonEventSkipStop],
                                      nil];
    }
    
    NSString *audioButtonEvent = [_idAudioStateStringMapping objectForKey:[NSNumber numberWithInt:event]];
    
    if (!audioButtonEvent || [audioButtonEvent length] < 1) {
        return @"unknown IDAudioButtonEvent";
    }
    
    return audioButtonEvent;
}

@end
