//
//  MCFeatureConnector.h
//  Connected
//
//  Created by Sebastian Cohausz on 01.06.12.
//  Copyright (c) 2012 BMW Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCFeatureController.h"

/*!
 @class FeatureConnector
 @abstract This class is used by the Feature Manager to connect and disconnect features
 @updated 2012-06-11
 */
@interface MCFeatureConnector : NSObject

/*!
 @method startFeatures:
 @abstract start features in the array
 @param featuresToStart: an NSArray of id<MCFeatureController>s
 @return YES if all features have been connected successfully, NO if at least one feature was not connected successfully.
 */
- (BOOL) startFeatures:(NSArray *)featuresToStart;

/*!
 @method stopFeatures:
 @abstract stop features in the array
 @param featuresToStop an NSArray of id<MCFeatureController>s to stop
 */
- (void) stopFeatures:(NSArray *)featuresToStop;

@end
