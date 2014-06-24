//
//  MCFeatureResolver.m
//  Connected
//
//  Created by Sebastian Cohausz on 01.06.12.
//  Copyright (c) 2012 BMW Group. All rights reserved.
//

#import "MCFeatureResolver.h"

@interface MCFeatureResolver ()
@property (retain) NSArray *featureControllers;
@property (retain) NSDictionary *featureConfigurations;

- (NSMutableArray *)connectableFeatureControllers;
- (BOOL)willFeatureControllerConnectToRHMI:(id<MCFeatureController>)featureController;

@end

@implementation MCFeatureResolver

@synthesize featureControllers = _featureControllers;
@synthesize featureConfigurations = _featureConfigurations;


#pragma mark Setup, teardown

- (id) initWithFeatureControllers:(NSArray *)featureControllers
            featureConfigurations:(NSDictionary *)featureConfigs
{
    if ((self = [super init])) {
        _featureControllers = [featureControllers retain];
        _featureConfigurations = [featureConfigs retain];
    }
    return self;
}

- (void)dealloc {
    [_featureControllers release]; _featureControllers = nil;
    [_featureConfigurations release]; _featureConfigurations = nil;
    [super dealloc];
}

#pragma mark Feature Connection Logic

- (NSArray *) featuresToStartWithAdditionalFeature:(id<MCFeatureController>)additionalFeature {
    NSMutableArray *allConnectableFeatures = [self connectableFeatureControllers];
    return allConnectableFeatures;
    
    /*
    NSMutableArray *featuresToConnect = [NSMutableArray array];
    if (additionalFeature) {
        for (id<MCFeatureController> featureController in allConnectableFeatures) {
            [featuresToConnect addObject:featureController];
        }
    } else {
        featuresToConnect = allConnectableFeatures;
    }

    return featuresToConnect;
     */
    
}

- (NSArray *)featuresToStopForAdditionalFeature:(id<MCFeatureController>)additionalController {
    NSMutableArray *featuresToDisconnect = [[[NSMutableArray alloc] init] autorelease];
    for (id<MCFeatureController> currentFeatCon in self.featureControllers) {
        if (![[currentFeatCon featureIdentifier] isEqual:[additionalController featureIdentifier]]) {
            [featuresToDisconnect addObject:currentFeatCon];
        }
    }
    return featuresToDisconnect;
}

- (NSMutableArray *)connectableFeatureControllers {
    NSMutableArray *connectableFeatureControllers = [NSMutableArray array];

    for (id<MCFeatureController> featureController in self.featureControllers) {
        if ([self willFeatureControllerConnectToRHMI:featureController]) //only connect features that are the most recent used in their respective category
        {
            [connectableFeatureControllers addObject:featureController];
        }
    }
    return connectableFeatureControllers;
}

- (NSArray *)connectedFeatureControllers
{
    NSPredicate *connectedPredicate = [NSPredicate predicateWithFormat:@"isConnected == YES"];
    return [self.featureControllers filteredArrayUsingPredicate:connectedPredicate];
}

- (NSArray *)allFeatureControllers
{
    NSMutableArray *allFeatures = [NSMutableArray arrayWithArray:self.featureControllers];
    return allFeatures;
}

- (BOOL)willFeatureControllerConnectToRHMI:(id<MCFeatureController>)featureController
{
    return YES;
}

- (BOOL)willFeatureConnectToRHMI:(MCFeatureIdentifier *)featureIdentifier {
    for (id<MCFeatureController>featureController in [self connectableFeatureControllers]) {
        if ([[featureController featureIdentifier] isEqual:featureIdentifier]) {
            return YES;
        }
    }
    return NO;
}

- (id<MCFeatureController>) featureControllerForIdentifier:(MCFeatureIdentifier *)featureId {
    for (id<MCFeatureController> featureController in self.featureControllers) {
        if ([[featureController featureIdentifier] isEqual:featureId]) {
            return featureController;
        }
    }
    return nil;
}


@end
