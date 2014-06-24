//
//  MCDefaultFeatureController.h
//  Connected
//
//  Created by Anton Wolf on 27.10.2011
//  Copyright 2011 BMW Group. All rights reserved.
//

/*!
 @class MCDefaultFeatureController
 @abstract Base class for all feature controller classes.
 @discussion Naming convention: class name has to be <feature identifier>FeatureController. For <feature identifier> @see MCFeatureIdentifiers. 
 */

#import "MCFeatureController.h"
#import "IDHmiService+Connected.h"

@interface MCDefaultFeatureController : NSObject <MCFeatureController>


/*!
 @method featureUsesRemoteHMI
 @abstract @see MCFeatureController protocol
 @discussion Default implementation returns YES if the application has a hmi description
 @return @see MCFeatureController protocol
 */
- (BOOL)featureUsesRemoteHMI;

/*!
 @method featureRequiresConnectionToVehicle
 @abstract @see MCFeatureController protocol
 @discussion Default implementation returns result from method featureUsesRemoteHMI
 @return @see MCFeatureController protocol
 */
- (BOOL)featureRequiresConnectionToVehicle;

@end
