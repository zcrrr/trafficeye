//
//  Created by Andreas Streuber on 16.12.11.
//  Copyright (c) 2011 BMW Group. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 @class MCOffboardAudioService
 @abstract Audio service for handling offboard audio.
 @discussion This audio service implements the entertainment / interrupt channel logic and audio channel state management when the iOS device is not connected to the remote hmi. The service will allow an entertainment channel only. The Interrupt channel is not supported in offboard mode.
 @updated 2011-12-16
 */
@interface MCOffboardAudioService : IDAudioService

@end
