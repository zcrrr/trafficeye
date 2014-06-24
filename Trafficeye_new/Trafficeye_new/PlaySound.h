//
//  PlaySound.h
//  TrafficEye
//
//  Created by Renton Lin on 12-3-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaySound : NSObject
{
    NSTimer* _timer_autoDestroy;
}
@property (strong) NSTimer* timer_autoDestroy;
+ (void)play;

+ (void)destroy;
@end
