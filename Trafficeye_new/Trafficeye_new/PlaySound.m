//
//  PlaySound.m
//  TrafficEye
//
//  Created by Renton Lin on 12-3-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlaySound.h"
#import "AVFoundation/AVAudioPlayer.h"

static AVAudioPlayer* default_player = nil;
static PlaySound* objPlayer = nil;

@interface PlaySound(private_)
-(void)stopAutoDestroyTimer;
-(void)autodestroyAfterTimerInterval;
@end

@implementation PlaySound (private_)

-(void)stopAutoDestroyTimer
{
    if (nil != _timer_autoDestroy)
    {
        [_timer_autoDestroy invalidate];
        _timer_autoDestroy = nil;
#ifdef MYDEBUG
        NSLog(@"timer invalidate");
#endif
    }
else {
#ifdef MYDEBUG
    NSLog(@"timer is nill");
#endif
    }
}
-(void)autodestroyAfterTimerInterval
{
    [PlaySound destroy];
    [_timer_autoDestroy invalidate];
    _timer_autoDestroy = nil;
}
@end

@implementation PlaySound
@synthesize timer_autoDestroy = _timer_autoDestroy;

+ (void)play
{
    if (nil == objPlayer)
    {
       objPlayer = [[PlaySound alloc]init];
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"connect_effect" ofType:@"mp3"];
    NSDictionary* error = nil;
    NSData* data = [NSData dataWithContentsOfFile:path];
    if (nil != default_player)
    {
        default_player = nil;
    }
    AVAudioPlayer* player = [[AVAudioPlayer alloc]initWithData:data error:nil];

    if (nil != error)
    {
        NSLog(@"%@", [error description]);
    }
    
#ifdef playSoundEnabled
    [objPlayer stopAutoDestroyTimer];
    [player play];
    default_player = player;
#endif
    
    NSTimer* timer_autoDestroy = [NSTimer timerWithTimeInterval:3 target:objPlayer selector:@selector(autodestroyAfterTimerInterval) userInfo:nil repeats:NO];
    objPlayer.timer_autoDestroy = timer_autoDestroy;
    [[NSRunLoop mainRunLoop]addTimer:objPlayer.timer_autoDestroy forMode:NSDefaultRunLoopMode];
}

+ (void)destroy
{
    if (nil != objPlayer)
    {
        objPlayer = nil;
    }
    if (nil != default_player)
    {
        default_player = nil;
    }
}
@end
