//
//  MCFeatureManager.h
//  Connected
//
//  Created by Wolfram Manthey on 24.02.10.
//  Copyright 2010 BMW Group. All rights reserved.
//
//

/*!
 @class MCFeatureManager
 @abstract A singleton responsible for creating, connecting and disconnecting features.
 @discussion The purpose of this class is to have a single instance for managing the lifecycle of the available IDApplications (features). For every available feature an feature controller (MCFeatureController directly or a subclass of MCFeatureController) is initialized.
            refactoring 2012-06-05 scohausz: after refactoring, the following responsibilities haven been extracted to ancillary classes:
            - decision making about which features should be connected and disconnected (-> MCFeatureResolver) and related persistence (-> MCFeaturePersistence in MCFeatureResolver)
            - "raw" connecting and disconnecting (-> MCFeatureConnector)
 @author Wolfram Manthey
 @copyright Copyright 2011 BMW Group. All rights reserved.
 @updated 2012-06-11
 */

#import <Foundation/Foundation.h>
#import "MCFeatureController.h"
#import "MCFeatureIdentifier.h"

@interface MCFeatureManager : NSObject

@property (retain, readonly) NSArray* featureControllers;
@property (assign, readonly) id<MCFeatureController> mainFeatureController;
@property (readonly, getter=isConnected) BOOL connected;
@property (atomic, retain) MCFeatureIdentifier *calledAppSwitcherFeature;

+ (MCFeatureManager*)sharedManager;

/*!
 @method connect
 @abstract connect all recent and "alwaysConnected" features if feature switching is active, connect all features in the active profile if feature switching is inactive
 the hmiType determines which features will connect; most features do not have this constraint, but ECO PRO analyzer for instance will only connect to most NBT HMIs
 @discussion feature switching can be toggled with a constant bool variable found in MCFeatureResolver.m
 @param hmiType the type of HMI to which the connection has been established
 */
- (void) connectToHMIType:(IDVehicleHmiType)hmiType;

/*!
 @method connect
 @abstract connect all recent and "alwaysConnected" features if feature switching is active, connect all features in the active profile if feature switching is inactive
 @discussion feature switching can be toggled with a constant bool variable found in MCFeatureResolver.m
 */
- (void) connect;

/*!
 @method disconnect
 @abstract disconnect all features
 */
- (void) disconnect;

/*!
 @method areFeaturesConnected
 @abstract returns YES if at least one feature is connected
 @return YES if at least one feature is connected, NO otherwise
 */
- (BOOL)areFeaturesConnected;

@end
