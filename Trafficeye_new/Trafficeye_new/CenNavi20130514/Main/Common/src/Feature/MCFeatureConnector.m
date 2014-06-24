//
//  MCFeatureConnector.m
//  Connected
//
//  Created by Sebastian Cohausz on 01.06.12.
//  Copyright (c) 2012 BMW Group. All rights reserved.
//

#import "MCFeatureConnector.h"

@interface IDCountingCondition : NSObject
- (id)initWithCount:(NSUInteger)count;
- (void)increment;
- (void)decrement;
- (void)waitForZero;
@end

@interface MCFeatureConnector () {
    NSOperationQueue* _operations;
}
- (NSNumber *) internalStartFeatures:(NSArray *)featuresToStart;
- (void) internalStopFeatures:(NSArray *)featuresToStop;
- (void) connectFeatureController:(id<MCFeatureController>)featureController withCompletionBlock:(void (^)(NSError*))block;
@end

@implementation MCFeatureConnector

static NSString *const LOG_CATEGORY_NAME = @"FeatureConnector";

- (id) init {
    if ((self = [super init])) {
        _operations = [NSOperationQueue new];
        [_operations setMaxConcurrentOperationCount:1];
    }
    return self;
}

- (void) dealloc {
    [_operations waitUntilAllOperationsAreFinished];
    [_operations release];
    [super dealloc];
}

- (BOOL) startFeatures:(NSArray *)featuresToStart {
    NSInvocationOperation* op;
    @synchronized(self)
    {
        if(_operations.operationCount)
        {
            MCLogWithCategory(IDLogLevelDebug, LOG_CATEGORY_NAME, @"canceling all outstanding operations");
            [_operations cancelAllOperations];
        }

        op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(internalStartFeatures:) object:featuresToStart];

        [_operations addOperation:op];
    }

    [op waitUntilFinished];
    BOOL result = NO;
    if (![op isCancelled]) {
        result = [(NSNumber *)[op result] boolValue];
    }
    [op release];
    MCLogWithCategory(IDLogLevelInfo, LOG_CATEGORY_NAME, @"finished connecting features");
    return result;
}

- (NSNumber *) internalStartFeatures:(NSArray *)featuresToStart {
    // this counting condition increases with the number of applications to connect
    IDCountingCondition* condition = [[IDCountingCondition alloc] initWithCount:[featuresToStart count]];
    __block BOOL successful = YES;
	for (id<MCFeatureController> featureController in featuresToStart)
    {
        MCLogWithCategory(IDLogLevelInfo, LOG_CATEGORY_NAME, @"connecting feature '%@'", [featureController featureIdentifier]);
        [self connectFeatureController:featureController withCompletionBlock:^(NSError* error) {
            // decrement the counting condition
            [condition decrement];
            if (!error) {
                MCLogWithCategory(IDLogLevelInfo, LOG_CATEGORY_NAME, @"feature '%@' connected", [featureController featureIdentifier]);
            } else {
                MCLogWithCategory(IDLogLevelError, LOG_CATEGORY_NAME, @"%s:%d: feature '%@' NOT connected - %@", __PRETTY_FUNCTION__, __LINE__, [featureController featureIdentifier], [error description]);
                successful = NO;
            }
        }];
    }

    [condition waitForZero];
    [condition release];
    MCLogWithCategory(IDLogLevelDebug, LOG_CATEGORY_NAME, @"%s - finished connecting all features!", __PRETTY_FUNCTION__);
    return [NSNumber numberWithBool:successful];
}

- (void) connectFeatureController:(id<MCFeatureController>)featureController withCompletionBlock:(void (^)(NSError*))block
{
    MCLogWithCategory(IDLogLevelInfo, LOG_CATEGORY_NAME, @"%s - Trying to connect feature '%@'", __PRETTY_FUNCTION__, [[featureController featureIdentifier] name]);
    [featureController.application startWithCompletionBlock:block];
}

- (void) stopFeatures:(NSArray *)featuresToStop {
    MCLogWithCategory(IDLogLevelInfo, LOG_CATEGORY_NAME, @"disconnecting features...");

    NSInvocationOperation* op;
    @synchronized(self)
    {
        if(_operations.operationCount)
        {
            MCLogWithCategory(IDLogLevelDebug, LOG_CATEGORY_NAME, @"canceling all outstanding operations");
            [_operations cancelAllOperations];
        }
        op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(internalStopFeatures:) object:featuresToStop];
        [_operations addOperation:op];

    }
    [op waitUntilFinished];
    [op release];
    MCLogWithCategory(IDLogLevelInfo, LOG_CATEGORY_NAME, @"disconnecting features completed");
}

- (void)internalStopFeatures:(NSArray *)featuresToStop
{
    if (featuresToStop.count > 0) {

        // this counting condition signals after all features disconnected
        IDCountingCondition* condition = [[IDCountingCondition alloc] initWithCount:[featuresToStop count]];

        // disconnect all features in parallel (each disconnect call is asynchronous returning immediately)
        for (id<MCFeatureController> featureController in featuresToStop) {
            MCLogWithCategory(IDLogLevelInfo, LOG_CATEGORY_NAME, @"diconnecting feature '%@'", [featureController featureIdentifier]);
            [featureController.application stopWithCompletionBlock:^(void) {
                // decrement the counting condition
                [condition decrement];
                MCLogWithCategory(IDLogLevelInfo, LOG_CATEGORY_NAME, @"feature '%@' disconnected", [featureController featureIdentifier]);
            }];
        }

        // wait until all features asynchronously disconnected
        [condition waitForZero];
        [condition release];
    }
}

@end
