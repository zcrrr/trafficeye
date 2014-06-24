//
//  Created by Andreas Streuber on 05.12.11.
//  Copyright (c) 2011 BMW Group. All rights reserved.
//

#import "MCAudioManager.h"
#import "MCMainApplicationDelegate.h"
#import "MCFeatureManager.h"
#import "MCNotifications.h"
#import "IDAudioService+Connected.h"
#import "MCOffboardAudioService.h"
#import "MCMainApplicationDelegate.h"
#import "IDAudioService+Connected.h"
#import <AudioToolbox/AudioToolbox.h>


@interface MCAudioManager ()

@property (retain) MCOffboardAudioService *offboardAudioService;

@property (assign, readwrite) BOOL entertainmentChannelActivationInProgress;
@property (assign, readwrite) BOOL interruptChannelActivationInProgress;
@property (assign) BOOL connectedToVehicle;
@property (assign) BOOL phoneCallInProgress;

- (void)handleVehicleDidConnectNotification:(NSNotification *)notification;
- (void)handleVehicleDidDisconnectNotification:(NSNotification *)notification;
- (void)communicationCurrentCallInfoDidChange:(NSNotification *)notification;

- (void)configureAudioManagerForOffboardUsage;
- (void)configureAudioManagerforOnboardUsage;

- (void)configureAVAudioSession;
- (void)activateAVAudioSession:(BOOL)activeFlag;
- (IDAudioService *)audioService;
- (NSString *)statusMessageWithStatus:(OSStatus)status;

void audioRouteChangeListenerCallback (void *inUserData, AudioSessionPropertyID inPropertyID, UInt32 inPropertyValueSize, const void *inPropertyValue);

MCAudioRoute AudioRouteDescriptionGetAudioRoute(CFDictionaryRef descriptionDict);
MCAudioRouteChangeReason AudioRouteChangeDictionaryGetAudioRouteChangeReason(CFDictionaryRef changeDict);

@end

@implementation MCAudioManager

@synthesize offboardAudioService = _offboardAudioService;

@synthesize audioDelegate = _audioDelegate;

@synthesize entertainmentChannelActivationInProgress = _entertainmentChannelActivationInProgress;
@synthesize interruptChannelActivationInProgress = _interruptChannelActivationInProgress;
@synthesize connectedToVehicle = _connectedToVehicle;
@synthesize phoneCallInProgress = _phoneCallInProgress;

static NSString *const LOG_CATEGORY = @"MCAudioManager";
static MCAudioManager *_defaultInstance;

#pragma mark - Default audio manager instantiation

+ (id)defaultAudioManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultInstance = [[MCAudioManager alloc] init];
    });
    
    return _defaultInstance;
}

#pragma mark - Setup, TearDown

- (id)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleVehicleDidConnectNotification:) name:IDAccessoryDidConnectNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleVehicleDidDisconnectNotification:) name:IDAccessoryDidDisconnectNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(communicationCurrentCallInfoDidChange:) name:MCCommunicationCurrentCallInfoDidChangeNotification object:nil];
        
        _connectedToVehicle = [(MCMainApplicationDelegate *)[TEAppDelegate getApplicationDelegate].appController carConnected];
        
        if (!_connectedToVehicle)
        {
            _offboardAudioService = [[MCOffboardAudioService alloc] init];
            _offboardAudioService.delegate = self;
        }
        
        [self configureAVAudioSession];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IDAccessoryDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IDAccessoryDidDisconnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MCCommunicationCurrentCallInfoDidChangeNotification object:nil];
    
    [_offboardAudioService release];
    [super dealloc];
}

#pragma mark - Audio manager onboard and offboard switching

- (void)configureAudioManagerForOffboardUsage
{
    self.entertainmentChannelActivationInProgress = NO;
    self.interruptChannelActivationInProgress = NO;
    
    if ([self audioService])
    {
        if ([self audioService].entertainmentAudioState != IDAudioStateInactive)
        {
            [[self audioService] deactivateEntertainment];
            if (self.audioDelegate)
            {
                //stop audio when switching from onboard to offboard
                [self.audioDelegate audioManager:self channelStateChanged:IDAudioStateInactive];
            }
        }
        
        if ([self audioService].interruptAudioState != IDAudioStateInactive)
        {
            [[self audioService] deactivateInterrupt];
            if (self.audioDelegate)
            {
                //stop audio when switching from onboard to offboard
                [self.audioDelegate audioManager:self channelStateChanged:IDAudioStateInactive];
            }
        }
    }
    
    self.offboardAudioService = [[[MCOffboardAudioService alloc] init] autorelease];
    self.offboardAudioService.delegate = self;
}

- (void)configureAudioManagerforOnboardUsage
{
    self.entertainmentChannelActivationInProgress = NO;
    self.interruptChannelActivationInProgress = NO;
    
    if (self.offboardAudioService)
    {
        if (self.offboardAudioService.entertainmentAudioState != IDAudioStateInactive)
        {
            if (self.audioDelegate)
            {
                //stop audio when switching from offboard to onboard
                [self.audioDelegate audioManager:self channelStateChanged:IDAudioStateInactive];
            }
        }
        self.offboardAudioService = nil;
    }
}

#pragma mark - Notification handling

- (void)handleVehicleDidConnectNotification:(NSNotification *)notification
{
    if (self.connectedToVehicle)
    {
        return;
    }
    
    self.connectedToVehicle = YES;
    [self configureAudioManagerforOnboardUsage];
}

- (void)handleVehicleDidDisconnectNotification:(NSNotification *)notification
{
    if (!self.connectedToVehicle)
    {
        return;
    }
    [self configureAudioManagerForOffboardUsage];
    self.connectedToVehicle = NO;
}

- (void)communicationCurrentCallInfoDidChange:(NSNotification *)notification
{
#if 0
    NSString *name = [[notification userInfo] objectForKey:MCCommunicationCurrentCallInfoNameKey];
    if (![SDUtilities stringContainsOnlyWhitespaces:name])
    {
        self.phoneCallInProgress = YES;
        return;
    }
    
    NSString *number = [[notification userInfo] objectForKey:MCCommunicationCurrentCallInfoNumberKey];
    if (![SDUtilities stringContainsOnlyWhitespaces:number])
    {
        self.phoneCallInProgress = YES;
        return;
    }
    
    self.phoneCallInProgress = NO;
#endif
}

#pragma mark - Entertainment- / Interruptchannel handling

- (void)activateEntertainmentChannel
{
    if (!self.audioDelegate)
    {
        MCLogWithCategory(IDLogLevelWarn, LOG_CATEGORY, @"Unable to activate entertainment channel because no audio delegate has been set!");
        return;
    }
    
    [self activateAVAudioSession:YES];
    
    IDAudioService *audioService = [self audioService];
    
    if (audioService)
    {
        if ([audioService interruptAudioState] != IDAudioStateInactive) {
            MCLogWithCategory(IDLogLevelWarn, LOG_CATEGORY, @"Requester has already an active interrupt channel. Release interrupt channel before requesting entertainment channel.");
            return;
        }
        
        self.entertainmentChannelActivationInProgress = YES;
        [audioService activateEntertainment];
    }
}

- (void)deactivateEntertainmentChannelAndReleaseAVAudioSession:(BOOL)releaseAVAudioSession
{
    IDAudioService *audioService = [self audioService];
    if (audioService){
        self.entertainmentChannelActivationInProgress = NO;
        [audioService deactivateEntertainment];
        if(releaseAVAudioSession){
            [self activateAVAudioSession:NO];
        }
    }
}

- (void)activateInterruptChannel
{
    if (!self.audioDelegate)
    {
        MCLogWithCategory(IDLogLevelWarn, LOG_CATEGORY, @"Unable to activate interrupt channel because no audio delegate has been set!");
        return;
    }
    
    [self activateAVAudioSession:YES];
    
    IDAudioService *audioService = [self audioService];
    
    if (audioService)
    {
        if (self.phoneCallInProgress)
        {
            // This shortcut will deny interrupt audio to overlay with an active phonecall. The headunit will allow interrupt audio if a phonecall is active. (Andreas Streuber - 20111213T1550)
            MCLogWithCategory(IDLogLevelInfo, LOG_CATEGORY, @"Interrupt activation request denied because of active phonecall!");
            return;
        }
        if ([audioService entertainmentAudioState] != IDAudioStateInactive) {
            MCLogWithCategory(IDLogLevelWarn, LOG_CATEGORY, @"Requester has already an active entertainment channel. Release entertainment channel before requesting interrupt channel.");
            return;
        }
        
        self.interruptChannelActivationInProgress = YES;
        [audioService activateInterrupt];
    }
}

- (void)deactivateInterruptChannel
{
    IDAudioService *audioService = [self audioService];
    if (audioService)
    {
        self.interruptChannelActivationInProgress = NO;
        [audioService deactivateInterrupt];
    }
}

- (IDAudioState)entertainmentChannelAudioState
{
    IDAudioService *audioService = [self audioService];
    if (!audioService)
    {
        return IDAudioStateInactive;
    }
    
    return [audioService entertainmentAudioState];
}

- (IDAudioState)interruptChannelAudioState
{
    IDAudioService *audioService = [self audioService];
    if (!audioService)
    {
        return IDAudioStateInactive;
    }
    
    return [audioService interruptAudioState];
}

#pragma mark - IDAudioServiceDelegate methods

- (void)audioService:(IDAudioService *)audioService entertainmentStateChanged:(IDAudioState)newState
{
    if (self.audioDelegate)
    {
        [self.audioDelegate audioManager:self channelStateChanged:newState];
    }
}

- (void)audioService:(IDAudioService *)audioService interruptStateChanged:(IDAudioState)newState
{
    if (self.audioDelegate)
    {
        [self.audioDelegate audioManager:self channelStateChanged:newState];
    }
}

- (void)audioService:(IDAudioService *)audioService multimediaButtonEvent:(IDAudioButtonEvent)button
{
    if (self.audioDelegate)
    {
        [self.audioDelegate audioManager:self multimediaButtonEvent:button];
    }
}

// private callback on IDAudioServiceDelegate in BMWAppKit
- (void)audioServiceEntertainmentActivationGranted:(IDAudioService *)audioService
{
    self.entertainmentChannelActivationInProgress = NO;
}

// private callback on IDAudioServiceDelegate in BMWAppKit
- (void)audioServiceEntertainmentActivationDenied:(IDAudioService *)audioService
{
    self.entertainmentChannelActivationInProgress = NO;
}

// private callback on IDAudioServiceDelegate in BMWAppKit
- (void)audioServiceInterruptActivationGranted:(IDAudioService *)audioService
{
    self.interruptChannelActivationInProgress = NO;
    
    //workaround for sdk bug. remove the following if-block if Ticket A4A-4522 is fixed
    if ([self interruptChannelAudioState] == IDAudioStateInactive) {
        MCLogWithCategory(IDLogLevelWarn, @"MCAudioManager",@"%s Overriding InterruptChannelState from IDAudioService", __PRETTY_FUNCTION__);
        [self audioService:audioService interruptStateChanged:IDAudioStateActivePlaying];
    }
}

// private callback on IDAudioServiceDelegate in BMWAppKit
- (void)audioServiceInterruptActivationDenied:(IDAudioService *)audioService
{
    self.interruptChannelActivationInProgress = NO;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[%@ [connectedToVehicle:%@][entertainmentChannelAudioState:%@][interruptChannelAudioState:%@][audioService:%@]]", NSStringFromClass([MCAudioManager class]), self.connectedToVehicle ? @"YES" : @"NO", [IDAudioService stringWithIDAudioState:self.entertainmentChannelAudioState], [IDAudioService stringWithIDAudioState:self.interruptChannelAudioState], [[self audioService] description]];
}

#pragma mark - AVAudioSessionDelegate methods

- (void)beginInterruption
{
    if ([self audioService])
    {
        if (([[self audioService] interruptAudioState] != IDAudioStateInactive) ||
            ([[self audioService] entertainmentAudioState] != IDAudioStateInactive)) {
            if (self.audioDelegate)
            {
                [self.audioDelegate audioManager:self channelStateChanged:IDAudioStateInactive];
            }
        }
    }
}

- (void)endInterruption
{
    [self activateAVAudioSession:YES];
    
    if ([self audioService])
    {
        IDAudioState audioStateAfterInterruption = IDAudioStateInactive;
        
        if ([[self audioService] interruptAudioState] != IDAudioStateInactive)
        {
            audioStateAfterInterruption = [[self audioService] interruptAudioState];
        }
        else if ([[self audioService] entertainmentAudioState] != IDAudioStateInactive)
        {
            audioStateAfterInterruption = [[self audioService] entertainmentAudioState];
        }
        
        if (self.audioDelegate && audioStateAfterInterruption != IDAudioStateInactive)
        {
            [self.audioDelegate audioManager:self channelStateChanged:audioStateAfterInterruption];
        }
    }
}

#pragma mark - AVAudioSession property listeners

void audioRouteChangeListenerCallback (void *inUserData, AudioSessionPropertyID inPropertyID, UInt32 inPropertyValueSize, const void *inPropertyValue)
{
    if (inPropertyID != kAudioSessionProperty_AudioRouteChange) {
        return;
    }
    
    CFDictionaryRef routeChangeDictionary = inPropertyValue;
    
    MCAudioRouteChangeReason changeReason = AudioRouteChangeDictionaryGetAudioRouteChangeReason(routeChangeDictionary);
    MCAudioRoute oldAudioRoute = MCAudioRouteUnknown;
    MCAudioRoute currentAudioRoute = MCAudioRouteUnknown;
    
    CFDictionaryRef oldAudioRouteDescription = CFDictionaryGetValue(routeChangeDictionary, kAudioSession_AudioRouteChangeKey_PreviousRouteDescription);
    oldAudioRoute = AudioRouteDescriptionGetAudioRoute(oldAudioRouteDescription);
    
    CFDictionaryRef audioRouteDescription;
    UInt32 dataSize = sizeof(audioRouteDescription);
    OSStatus routeDescriptionGetError = AudioSessionGetProperty(kAudioSessionProperty_AudioRouteDescription, &dataSize, &audioRouteDescription);
    
    if  (routeDescriptionGetError != noErr)
    {
        MCLogWithCategory(IDLogLevelError, LOG_CATEGORY, @"Error while trying to get audio route description from AVAudioSession. Error was: %d", routeDescriptionGetError);
    } else
    {
        currentAudioRoute = AudioRouteDescriptionGetAudioRoute(audioRouteDescription);
        if (audioRouteDescription != NULL) {
            CFRelease(audioRouteDescription);
        }
    }
    
    MCAudioManager *audioManager = [MCAudioManager defaultAudioManager];
    
    if (audioManager.audioDelegate && [audioManager.audioDelegate respondsToSelector:@selector(audioManager:audioRouteDidChange:newAudioRoute:changeReason:)])
    {
        [audioManager.audioDelegate audioManager:audioManager audioRouteDidChange:oldAudioRoute newAudioRoute:currentAudioRoute changeReason:changeReason];
    }
}

#pragma mark - Helper methods

- (void)configureAVAudioSession
{
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    
    UInt32 category = kAudioSessionCategory_MediaPlayback;
    OSStatus categorySetError = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof (category), &category);
    if (categorySetError != noErr)
    {
        MCLogWithCategory(IDLogLevelError, LOG_CATEGORY, @"Error while trying to set audio category on AVAudioSession to category: %d Error was: %d", category, categorySetError);
    }
    
    UInt32 allowMixWithOthers = false;
    OSStatus propertySetError = AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(allowMixWithOthers), &allowMixWithOthers);
    if (propertySetError != noErr)
    {
        MCLogWithCategory(IDLogLevelError, LOG_CATEGORY, @"Error while trying to set property kAudioSessionProperty_OverrideCategoryMixWithOthers on AVAudioSession to %@. Error was: %d", allowMixWithOthers ? @"YES" : @"NO", propertySetError);
    }
    
    AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, audioRouteChangeListenerCallback, nil);
    
    [[AVAudioSession sharedInstance] setDelegate:self];
}

- (void)activateAVAudioSession:(BOOL)activeFlag
{
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setActive:activeFlag error:&error];
    if (error)
    {
        MCLogWithCategory(IDLogLevelError, LOG_CATEGORY, @"Error setting audio session active: YES. Error was: %@", [error localizedDescription]);
    }
}

- (IDAudioService *)audioService
{
    if (!self.connectedToVehicle)
    {
        return self.offboardAudioService;
    }
    
    if (!self.audioDelegate)
    {
        MCLogWithCategory(IDLogLevelWarn, LOG_CATEGORY, @"Unable to acces audio service because no audio delegate has been set!");
        return nil;
    }
    
    IDAudioService *audioService = [self.audioDelegate audioService];
    if (audioService.delegate != self)
    {
        audioService.delegate = self;
    }
    return audioService;
}

- (NSString *)statusMessageWithStatus:(OSStatus)status
{
    NSInteger swappedStatus = CFSwapInt32HostToBig(status);
    return [[[NSString alloc] initWithBytes:(const void *)&swappedStatus length:4 encoding:NSASCIIStringEncoding] autorelease];
}

- (void)setAudioDelegate:(id <MCAudioManagerDelegate>)audioDelegate
{
    if (_audioDelegate == nil) {
        _audioDelegate = audioDelegate;
        return;
    }
    
    if (_audioDelegate == audioDelegate) {
        return;
    }
    
    if (_audioDelegate != audioDelegate) {
        if ([[_audioDelegate audioService] entertainmentAudioState] != IDAudioStateInactive ) {
            [[_audioDelegate audioService] deactivateEntertainment];
        }
        if ([[_audioDelegate audioService] interruptAudioState] != IDAudioStateInactive) {
            [[_audioDelegate audioService] deactivateInterrupt];
        }
        _audioDelegate = audioDelegate;
    }
}

MCAudioRoute AudioRouteDescriptionGetAudioRoute(CFDictionaryRef descriptionDict)
{
    MCAudioRoute audioRoute = MCAudioRouteUnknown;
    
    if (descriptionDict != NULL) {
        CFArrayRef audioRouteOutputs = CFDictionaryGetValue(descriptionDict, kAudioSession_AudioRouteKey_Outputs);
        if (audioRouteOutputs != NULL && CFArrayGetCount(audioRouteOutputs) > 0)
        {
            CFDictionaryRef outputTypes = CFArrayGetValueAtIndex(audioRouteOutputs, 0);
            CFStringRef route = CFDictionaryGetValue(outputTypes, kAudioSession_AudioRouteKey_Type);
            
            if (CFStringCompare(route, kAudioSessionOutputRoute_AirPlay, 0) == kCFCompareEqualTo)
            {
                audioRoute = MCAudioRouteAirPlay;
            } else if (CFStringCompare(route, kAudioSessionOutputRoute_BluetoothA2DP, 0) == kCFCompareEqualTo)
            {
                audioRoute = MCAudioRouteBluetoothA2DP;
            } else if (CFStringCompare(route, kAudioSessionOutputRoute_BluetoothHFP, 0) == kCFCompareEqualTo)
            {
                audioRoute = MCAudioRouteBluetoothHFP;
            } else if (CFStringCompare(route, kAudioSessionOutputRoute_BuiltInReceiver, 0) == kCFCompareEqualTo)
            {
                audioRoute = MCAudioRouteBuiltInReceiver;
            } else if (CFStringCompare(route, kAudioSessionOutputRoute_BuiltInSpeaker, 0) == kCFCompareEqualTo)
            {
                audioRoute = MCAudioRouteBuiltInSpeaker;
            } else if (CFStringCompare(route, kAudioSessionOutputRoute_HDMI, 0) == kCFCompareEqualTo)
            {
                audioRoute = MCAudioRouteHDMI;
            } else if (CFStringCompare(route, kAudioSessionOutputRoute_Headphones, 0) == kCFCompareEqualTo)
            {
                audioRoute = MCAudioRouteHeadphones;
            } else if (CFStringCompare(route, kAudioSessionOutputRoute_LineOut, 0) == kCFCompareEqualTo)
            {
                audioRoute = MCAudioRouteLineOut;
            } else if (CFStringCompare(route, kAudioSessionOutputRoute_USBAudio, 0) == kCFCompareEqualTo)
            {
                audioRoute = MCAudioRouteUSBAudio;
            }
        }
    }
    
    return audioRoute;
}

MCAudioRouteChangeReason AudioRouteChangeDictionaryGetAudioRouteChangeReason(CFDictionaryRef changeDict)
{
    NSInteger changeReason =kAudioSessionRouteChangeReason_Unknown;
    
    if (changeDict != NULL) {
        CFNumberRef changeReasonValue = kAudioSessionRouteChangeReason_Unknown;
        changeReasonValue = CFDictionaryGetValue(changeDict, kAudioSession_RouteChangeKey_Reason);
        if (changeReasonValue != NULL)
        {
            CFNumberGetValue(changeReasonValue, kCFNumberNSIntegerType, &changeReason);
        }
    }
    
    switch (changeReason)
    {
        case kAudioSessionRouteChangeReason_NewDeviceAvailable: return MCAudioRouteChangeReasonNewDeviceAvailable;
        case kAudioSessionRouteChangeReason_OldDeviceUnavailable: return MCAudioRouteChangeReasonOldDeviceUnavailable;
        case kAudioSessionRouteChangeReason_CategoryChange: return MCAudioRouteChangeReasonCategoryChange;
        case kAudioSessionRouteChangeReason_Override: return MCAudioRouteChangeReasonOverride;
        case kAudioSessionRouteChangeReason_WakeFromSleep: return MCAudioRouteChangeReasonWakeFromSleep;
        case kAudioSessionRouteChangeReason_NoSuitableRouteForCategory: return MCAudioRouteChangeReasonNoSuitableRouteForCategory;
        case kAudioSessionRouteChangeReason_Unknown: return MCAudioRouteChangeReasonUnknown;
        default: return MCAudioRouteChangeReasonUnknown;
    }
}

@end
