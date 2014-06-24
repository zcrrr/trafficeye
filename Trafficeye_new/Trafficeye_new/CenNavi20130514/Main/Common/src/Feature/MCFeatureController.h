//
//  MCFeatureController.h
//  Connected
//
//  Created by Anton Wolf on 29.09.11.
//  Copyright (c) 2011 BMW Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCFeatureConfiguration.h"
#import "MCFeatureIdentifier.h"
#import "MCFunctionIdentifier.h"
#import "IDHmiService+Connected.h"

@protocol MCFeatureController <NSObject>

@required
@property (readonly) IDApplication *application;
@property (readonly) MCFeatureConfiguration *featureConfiguration;
@property (readonly, getter = isConnected) BOOL connected;

/*!
 @method initWithApplication:identifier:
 @abstract Designated initializer for MCFeatureController
 @discussion retains the given application and the identifier
 */
- (id)initWithApplication:(IDApplication *)application featureConfiguration:(MCFeatureConfiguration*)configuration;

/*!
 @method featureIdentifier
 @abstract Return the featureIdentifier for this feature.
 @return an MCFeatureIdentifier
 */
- (MCFeatureIdentifier *)featureIdentifier;


/*!
 @method featureVersion
 @abstract Method returns the version of the feature.
 @discussion The version of the feature is usesd internally by BMWAppKit.
 @return the version of the feature
 */
- (IDVersionInfo *)featureVersion;


/*!
 @method featureRequiresNBT
 @abstract Method should return YES if this feature requires a NBT Headunit (e.g. it will not be displayed on CIC).
 @result YES if feature must not be displayed on CIC
 */
- (BOOL)featureRequiresNBT;

/*!
 @method featureUsesRemoteHMI
 @abstract Method should return YES if this feature uses the RemoteHMI and NO if the feature uses the iPhone UI only.
 @result YES if features uses remote hmi, NO otherwise.
 */
- (BOOL)featureUsesRemoteHMI;

/*!
 @method featureRequiresConnectionToVehicle
 @abstract Method should return YES if this feature requires a connection to the vehicle (e.g. utilizes IDHmiService).
 @result YES if vehicle connection is required, NO otherwise
 */
- (BOOL)featureRequiresConnectionToVehicle;

/*!
 @method hmiService
 @abstract Method to access the hmi service for this feature.
 @return an IDHmiService
 */
- (IDHmiService *)hmiService;

/*!
 @method cdsService
 @abstract Method to access the cds service for this feature.
 @return an IDCdsService
 */
- (IDCdsService *)cdsService;

/*!
 @method audioService
 @abstract Method to access the audio service for this feature.
 @return an IDAudioService
 */
- (IDAudioService *)audioService;

/*!
 @method registerWithAppSwitcher
 @abstract registers this feature with the AppSwitcher, if it can be used with the AppSwitcher
 @discussion this method calls the featureUsesAppSwitcher method declared in the MCFeatureController protocol
 */
- (void)registerWithAppSwitcher;

/*!
 @method deregisterFromAppSwitcher
 @abstract deregisters this feature from the AppSwitcher
 */
- (void)deregisterFromAppSwitcher;

@optional

/*!
 @method viewController
 @abstract Method to access viewcontroller of this feature used in the iPhone UI.
 @return an UIViewController
 */
- (UIViewController *)viewController;

/*!
 @method featureVendor
 @abstract Method returns an string that represents the vendor of the feature.
 @discussion The vendor will be used internally in BMWAppKit.
 @return an UIViewController
 */
- (NSString *)featureVendor;

/*!
 @see IDApplicationDelegate application:didConnectToVehicle:
 */
- (void)featureDidConnectToVehicle:(IDVehicleInfo *)vehicleInfo;

/*!
 @see IDApplicationDelegate applicationDidStart:
 */
- (void)featureDidStart;

/*!
 @see IDApplicationDelegate application:didFailToStartWithError:
 */
- (void)featureDidFailToStartWithError:(NSError *)error;

/*!
 @method featureShouldRestoreHmiWithComponents
 @abstract Used for LastUserMode (LUM)
 @discussion Use this to determine whether the application was used before and check for the LastUserMode. 
   @see IDApplicationDelegate application:shouldRestoreHmiWithComponents:
   if you overwrite this method make sure to call super(); before any other code in its implementation
 @param components hmi components
 */
- (void)featureShouldRestoreHmiWithComponents:(NSArray *)components;

/*!
 @see IDApplicationDelegate applicationDidStop:
 */
- (void)featureDidStop;

/*!
 @method featureDoesHandleURL:
 @abstract Method returns wether the feature does handle a given URL.
 @discussion This method is usually used when using OAuth2 via mobile Safari. (e.g. Foursquare, Facebook, Twitter)
 @param url an NSURL
 @return YES if the feature can handle the URL, NO otherwise.å
 */
- (BOOL)featureDoesHandleURL:(NSURL *)url;


@end
