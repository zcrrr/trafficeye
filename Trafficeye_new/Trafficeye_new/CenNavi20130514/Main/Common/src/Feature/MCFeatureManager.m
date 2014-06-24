//
//  MCFeatureManager.m
//  Connected
//
//  Created by Sebastian Cohausz on 01.06.12.
//  Copyright (c) 2012 BMW Group. All rights reserved.
//

#import "MCFeatureManager.h"
#import "MCFeatureResolver.h"
#import "MCFeatureConnector.h"
#import "MCNotifications.h"

@interface MCFeatureManager ()
@property (retain) MCFeatureResolver *featureResolver;
@property (retain) MCFeatureConnector *featureConnector;

- (NSDictionary *)getFeatureConfigurations;
- (id<MCFeatureController>)newFeatureControllerWithConfiguration:(MCFeatureConfiguration *)configuration;
@end

@implementation MCFeatureManager

@synthesize featureResolver = _featureResolver;
@synthesize featureConnector = _featureConnector;
@synthesize featureControllers = _featureControllers;
@synthesize mainFeatureController = _mainFeatureController;
@synthesize connected = _connected;


static MCFeatureManager* sharedManager = nil;

NSString *const FeatureIdentifierKey = @"FeatureIdentifier";
NSString *const LOG_CATEGORY_NAME = @"MCFeatureManager";

#pragma mark - Singleton implementation

+ (MCFeatureManager*)sharedManager
{
    static dispatch_once_t once;

    dispatch_once(&once, ^{
        sharedManager = [[MCFeatureManager alloc] init];
    });
    return sharedManager;
}

#pragma mark - Setup, TearDown, Memory management

- (id)init
{
    if ((self = [super init]))
    {
        NSArray *featureConfigurations = [[self getFeatureConfigurations] allValues];
        NSMutableArray* featureControllers = [NSMutableArray arrayWithCapacity:[featureConfigurations count]];

        for (NSDictionary* appInfoDict in featureConfigurations)
        {
            MCFeatureConfiguration *featureConfiguration = [[MCFeatureConfiguration alloc] initWithFeatureConfigurationDictionary:appInfoDict];
            id<MCFeatureController> featureController = [self newFeatureControllerWithConfiguration:featureConfiguration];

            //this will also adapt the configuration for use of the corresponding dummy feature controller
            [featureConfiguration release];
            featureConfiguration = nil;
            
            [featureController registerWithAppSwitcher];

            [featureControllers addObject:featureController];

            [featureController release];
        }

        _featureControllers = [[NSArray alloc] initWithArray:featureControllers];

        _mainFeatureController= [self.featureControllers  objectAtIndex:0];

        _featureResolver = [[MCFeatureResolver alloc] initWithFeatureControllers:self.featureControllers featureConfigurations:[self getFeatureConfigurations]];
        _featureConnector = [[MCFeatureConnector alloc] init];
    }
    return self;
}


- (void) dealloc {
    [_calledAppSwitcherFeature release];
    _calledAppSwitcherFeature = nil;
    [_featureConnector release];
    _featureConnector = nil;
    [_featureResolver release];
    _featureResolver = nil;
    _mainFeatureController = nil;
    [_featureControllers release];
    _featureControllers = nil;
    [super dealloc];
}

- (void) connectToHMIType:(IDVehicleHmiType)hmiType {
    
    MCLog(IDLogLevelDebug, @"%s - connectToHMIType", __PRETTY_FUNCTION__);
    
    if (hmiType == IDVehicleHmiTypeUnknown) {
        MCLog(IDLogLevelWarn, @"%s: invalid vehicle type set! Features that require a certain HMI type will not connect.", __PRETTY_FUNCTION__);
    }
    //self.featureResolver.vehicleHMIType = hmiType;
    
    // start the Feature called by the AppSwitcher before all other user-features
    id<MCFeatureController> appSwitchFeature = nil;
    if (self.calledAppSwitcherFeature != nil) {
        appSwitchFeature = [self.featureResolver featureControllerForIdentifier:self.calledAppSwitcherFeature];
        MCLog(IDLogLevelInfo, @"%s - app switch to %@ => starting it as first feature!", __PRETTY_FUNCTION__, appSwitchFeature);
        self.calledAppSwitcherFeature = nil;
    }
    
    //do not switch to the feature if the car does not support it
    if ([appSwitchFeature featureRequiresNBT] && hmiType != IDVehicleHmiTypeID4PlusPlus) {
        appSwitchFeature = nil;
    }
    
    //deregister features from app switcher if the current head unit doesn't support them
    for (id<MCFeatureController> aFeatureController in self.featureControllers) {
        [aFeatureController registerWithAppSwitcher];
        
    }
    
    NSArray *featureControllersToConnect = [self.featureResolver featuresToStartWithAdditionalFeature:appSwitchFeature];
    
    MCLog(IDLogLevelDebug, @"appSwitchFeature: %d", appSwitchFeature);
    
    if (appSwitchFeature) {
        BOOL success = [self.featureConnector startFeatures:[NSArray arrayWithObject:appSwitchFeature]];
        if (success) {
            //perform LUM on connected feature
            if (appSwitchFeature)
                [appSwitchFeature featureShouldRestoreHmiWithComponents:nil];
        } else {
            MCLog(IDLogLevelError, @"%s: Could not switch to feature", __PRETTY_FUNCTION__);
        }
    }
    
    //now that the "app switch" feature is handled, connect other features
    [self.featureConnector startFeatures:featureControllersToConnect];
}


- (void) connect {
    // start the Feature called by the AppSwitcher before all other user-features
    id<MCFeatureController> appSwitchFeature = nil;
    if (self.calledAppSwitcherFeature != nil) {
        appSwitchFeature = [self.featureResolver featureControllerForIdentifier:self.calledAppSwitcherFeature];
        MCLog(IDLogLevelInfo, @"%s - app switch to %@ => starting it as first feature!", __PRETTY_FUNCTION__, appSwitchFeature);
        self.calledAppSwitcherFeature = nil;
    }

    //deregister features from app switcher if the current head unit doesn't support them
    for (id<MCFeatureController> aFeatureController in self.featureControllers) {
        [aFeatureController registerWithAppSwitcher];
        
    }
    
    NSArray *featureControllersToConnect = [self.featureResolver featuresToStartWithAdditionalFeature:appSwitchFeature];
    
    
    if (appSwitchFeature) {
        BOOL success = [self.featureConnector startFeatures:[NSArray arrayWithObject:appSwitchFeature]];
        if (success) {
            //[self.featureResolver registerFeatureAsMostRecent:appSwitchFeature];
            //perform LUM on connected feature
            if (appSwitchFeature)
                [appSwitchFeature featureShouldRestoreHmiWithComponents:nil];
        } else {
            MCLog(IDLogLevelError, @"%s: Could not switch to feature", __PRETTY_FUNCTION__);
        }
    }
    
    //now that the "app switch" feature is handled, connect other features
    [self.featureConnector startFeatures:featureControllersToConnect];
}

- (void) disconnect {
    [self.featureConnector stopFeatures:[self.featureResolver allFeatureControllers]];
}


#pragma mark - Helper methods

- (NSDictionary *)getFeatureConfigurations
{
    NSString* featuresPlistPath = [[NSBundle mainBundle] pathForResource:@"Features" ofType:@"plist"];
    NSArray*  featuresPlist = [NSArray arrayWithContentsOfFile:featuresPlistPath];

    NSMutableDictionary *featureConfigurations = [NSMutableDictionary dictionaryWithCapacity:featuresPlist.count];

    for (NSDictionary* featureDict in featuresPlist)
    {
        NSMutableDictionary *mutableFeatureDict = [NSMutableDictionary dictionaryWithDictionary:featureDict];
        [featureConfigurations setObject:mutableFeatureDict forKey:[mutableFeatureDict objectForKey:FeatureIdentifierKey]];
    }

    return [NSDictionary dictionaryWithDictionary:featureConfigurations];
}

- (id<MCFeatureController>)newFeatureControllerWithConfiguration:(MCFeatureConfiguration *)configuration
{
    //  IDApplication recently has a the concept of the delegate queue, for scheduling and serializing call backs to IDApplicationDelegates (like hmiDidStart ..). The queue for the delegate call backs is chosen from the context (using +[NSOperationQueue currentQueue]). In the case of being instantiated from the main thread, this is then set to +[NSOperationQueue mainQueue]. When apps are instantiated from a background thread, this is set to nil because there is queue in the background thread's context. (Andreas Streuber - 20120112T1345)

    NSAssert([NSThread currentThread] == [NSThread mainThread], @"IDApplication has to be created on the main thread, hard constraint!");
    IDApplication* app = [[IDApplication alloc] init];
    
    NSString* featureControllerClassName = nil;
    NSString *controllerStringSuffix = @"FeatureController";
    featureControllerClassName = [configuration.identifier.name stringByAppendingString:controllerStringSuffix];
    

    Class featureControllerClass = NSClassFromString(featureControllerClassName);
    id obj = [featureControllerClass alloc];
    NSAssert(obj != nil, @"Unable to allocate class with class name: %@", featureControllerClassName);
    NSAssert([obj conformsToProtocol:@protocol(MCFeatureController)], @"Class: %@ does not conform to protocol: %@.", featureControllerClassName, NSStringFromProtocol(@protocol(MCFeatureController)));
    NSAssert([obj conformsToProtocol:@protocol(IDApplicationDelegate)], @"Class: %@ does not conform to protocol: %@.", featureControllerClassName, NSStringFromProtocol(@protocol(IDApplicationDelegate)));
    NSAssert([obj conformsToProtocol:@protocol(IDApplicationDataSource)], @"Class: %@ does not conform to protocol: %@.", featureControllerClassName, NSStringFromProtocol(@protocol(IDApplicationDataSource)));

    id<MCFeatureController, IDApplicationDelegate, IDApplicationDataSource> featureController = [obj initWithApplication:app featureConfiguration:configuration];
    NSAssert(featureController, @"Could not initialize class:%@.", featureControllerClassName);

    featureController.application.dataSource = featureController;
    featureController.application.delegate = featureController;
    //app.dataSource = featureController;
    //app.delegate = featureController;

    [app release];
    app = nil;

    return featureController;
}


#pragma mark - Public Methods

- (BOOL) areFeaturesConnected {
    return [self.featureResolver connectedFeatureControllers].count > 0;
}


@end
