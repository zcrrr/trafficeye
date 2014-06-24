//
//  MCFeatureResolver.h
//  Connected
//
//  Created by Sebastian Cohausz on 01.06.12.
//  Copyright (c) 2012 BMW Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCFeatureIdentifier.h"
#import "MCFeatureController.h"

/*!
 @class FeatureResolver
 @abstract This class is responsible to make decisions about which features have to be connected or disconnected depending on the current state of the feature controllers and optional additional constraints (i.e. additional feature controllers about to connect)
 @discussion Methods in this class return arrays of features that have to be connected (or disconnected) depending on the current connection state of the feature controllers, on whether feature switching is active and depending on additional features that may be passed in. MCFeaturePersistence is used to store the last recent used features for feature switching.
 @updated 2012-06-11
 */
@interface MCFeatureResolver : NSObject

- (id) initWithFeatureControllers:(NSArray *)featureControllers 
            featureConfigurations:(NSDictionary *)featureConfigs;

/*!
 @method featuresToStopForAdditionalFeature
 @abstract  returns an NSArray containing Feature Controllers that have to be disconnected / stopped before the given feature can be connected
 @param additionalController a controller to be taken into consinderation for the decision
 @return an array of features that have to be disconnected before the given feature can be connected
 */
- (NSArray *)featuresToStopForAdditionalFeature:(id<MCFeatureController>)additionalController;

/*!
 @method featuresToStartWithAdditionalFeature:
 @abstract returns an NSArray containing Feature Controllers that have yet to be connected under consideration of the given feature
 @discussion the given feature is NOT contained in the returned Feature Controllers
 @param additionalController an additional controller to be taken into consinderation for the decision; set to nil if no additional feature will be connected
 @return an array of features that have yet to be connected in addition to the given controller
 */
- (NSArray *)featuresToStartWithAdditionalFeature:(id<MCFeatureController>)additionalFeature;

/*!
 @method connectedFeatureControllers
 @abstract returns all connected feature controllers
 @return all connected feature controllers in an NSArray
 */
- (NSArray *)connectedFeatureControllers;

/*!
 @method allFeatureControllers
 @abstract returns an NSArray* containing all feature controllers, including dummy features if available
 @return see above
 */
- (NSArray *)allFeatureControllers;


/*!
 @method featureControllerForIdentifier:
 @abstract returns the feature controller corresponding to the given identifier
 @discussion this method doesn't map identifiers to feature controllers but checks every feature controller if it is identified by the given identifier
 @param featureId the given feature identifier
 @return returns the feature controller (id<MCFeatureController) corresponding to the given feature identifier
 */
- (id<MCFeatureController>)featureControllerForIdentifier:(MCFeatureIdentifier *)featureId;


@end
