/*  
 *  IDApplication.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "IDPropertyTypes.h"


@class IDApplication;
@class IDVersionInfo;
@class IDHmiService;
@class IDCdsService;
@class IDAudioService;
@class IDVehicleInfo;
@class IDView;

@protocol IDHmiProvider;

#pragma mark -

/*!
 @protocol IDApplicationDataSource
 @discussion The IDApplicationDataSource protocol provides an @link IDApplication @/link object with the information it needs.
 */
@protocol IDApplicationDataSource <NSObject>

@required

/*!
 @abstract Asks the data source to provide the manifest for the IDApplication.
 @discussion The source of the manifest is a plist file. The manifest contains metadata about the application (e.g. name, version, vendor), the AppModel and signatures. The AppModel is required by the AppSwitcher. This model contains the information that is shown in the AppSwitcher, e.g. a 50*50 px png-icon, the name translated to the 23 supported HMI languages for i18n purposes, the app's URL, ... The signatures are created by BMW and verify that your application has been reviewed by BMW and is allowed to connect to vehicles. The application manifest dictionary returned from the delegate will be cached within IDApplication. Setting the datasource delegate again will flush the cached manifest.
 @param application An object representing the application requesting this information.
 @return dictionary respresentation of the AppSwitcher model
 */
- (NSDictionary *)manifestForApplication:(IDApplication *)application;

@optional

/*!
 @method hmiDescriptionForApplication:
 @abstract Asks the data source to return the HMI description for a Remote HMI application.
 @discussion A HMI service will only be created if the data source provides an hmi description.
 @param application
    An object representing the application requesting this information.
 @result  A NSData object containing the HMI description.
 */
- (NSData *)hmiDescriptionForApplication:(IDApplication *)application;

/*!
 @method textDatabasesForApplication:
 @abstract Asks the data source to return the text databases for a Remote HMI application.
 @param application  An object representing the application requesting this information.
 @result  An array of NSData objects containing the text databases.
 @discussion The resulting array can contain multiple text databases to be used. The application determines which text
    databases it needs to provide depending on the properties brand and hmiType of the currently connected vehicle (refer to @link
    //apple_ref/occ/cl/IDVehicleInfo @/link). If multiple databases contain a text resource with the same identifier, the text resource in
    the database with the highest index in the returned array will be used.
 */
- (NSArray *)textDatabasesForApplication:(IDApplication *)application;

/*!
 @method imageDatabasesForApplication:
 @abstract Asks the data source to return the image databases for a Remote HMI application.
 @param application
    An object representing the application requesting this information.
 @result  An array of NSData objects containing the image databases.
 @discussion The resulting array can contain multiple image databases to be used. The application determines which image databases it needs to provide depending on the properties brand and hmiType of the currently connected vehicle (refer to @link //apple_ref/occ/cl/IDVehicleInfo @/link). If multiple databases contain an image with the same identifier, the image in the database with the highest index in the returned array will be used.
 */
- (NSArray *)imageDatabasesForApplication:(IDApplication *)application;

@end

#pragma mark -

/*!
 @protocol IDApplicationDelegate
 @discussion The IDApplicationDelegate protocol provides an @link //apple_ref/occ/cl/IDApplication @/link object with the information it needs.
 */
@protocol IDApplicationDelegate <NSObject>

/*!
 @method applicationRestoreMainHmiState:
 @abstract Delegate method to signal that an application should restore its main hmi state.
 @discussion When this message is received, the application should restore its main hmi state. Restoring the main HMI state is also known as LUM (Last User Mode). Be aware that LUM is not supported in all countries. If LUM is not supported this method will not be called. This method might get called before or after the application did start (refer to @link applicationDidStart: @/link).
 @param application the application instance that did fail to start (refer to @link IDApplication @/link)
 */
- (void)applicationRestoreMainHmiState:(IDApplication *)application;
@optional

/*!
 @method application:didConnectToVehicle:
 @abstract This delegate method will be called when the application is connected to the vehicle.
 @discussion Connected means that the a communication channel between the application and the vehicle is established. The CDS servcie (refer to @link //apple_ref/occ/cl/IDCdsService @/link) and the HMI service (refer to @link //apple_ref/occ/cl/IDHmiService @/link) (if required by the application) are registered with the remote HMI and ready to use. This is the right place to register for CDS values and HMI events. Be aware that the HMI service is only registered, the HMI itself has not been started yet. The AUDIO service (refer to @link //apple_ref/occ/cl/IDAudioService @/link) has not yet been registered.
 @param application
    the application instance that did connect to the vehicle (refer to @link IDApplication @/link)
 @param vehicleInfo
    some information about the connected vehicle (refer to @link //apple_ref/occ/cl/IDVehicleInfo @/link)
 */
- (void)application:(IDApplication *)application didConnectToVehicle:(IDVehicleInfo *)vehicleInfo;

/*!
 @method applicationDidStart:
 @abstract This delegate method will be called when the application is started.
 @discussion The application has started. All services (CDS, HMI, AUDIO) are registered. The HMI service is up and running.
 @param application
    the application instance that did start (refer to @link  IDApplication @/link)
 */
- (void)applicationDidStart:(IDApplication *)application;

/*!
 @method application:didFailToStartWithError:
 @abstract Delegate method to signal an error during application startup.
 @discussion The startup process of the application did fail. The error parameter will give hints on what went wrong.
 @param application
    the application instance that did fail to start (refer to @link IDApplication @/link)
 @param error
    an error instance with some information on what went wrong
 */
- (void)application:(IDApplication *)application didFailToStartWithError:(NSError *)error;

/*!
 @method applicationDidStop:
 @abstract Delegate method to signal that the application did stop.
 @discussion The application has been stopped. All services have been shut down (CDS, HMI, AUDIO). There is no need to deregister from CDS values or unsubscribe from HMI events.
 @param application
    the application instance that did stop (refer to @link IDApplication @/link)
 */
- (void)applicationDidStop:(IDApplication *)application;

@end

#pragma mark -

/*!
 @class IDApplication
 @abstract This class is the interaction hub for any remote application.
 @discussion Each IDApplication represents an instance of a remote application. When connected to a vehicle (i.e. when a
    @link //apple_ref/c/data/IDAccessoryDidConnectNotification/IDAccessoryDidConnectNotification @/link was received the lifecycle methods @link startWithCompletionBlock: @/link
    and @link stopWithCompletionBlock: @/link can be used to start and stop the application.
    Once the application was successfully started the different services (CDS service, Audio service and HMI service) can
    be used to interact with the vehicle.
 @updated 2012-11-27
 */
@interface IDApplication : NSObject

/*!
 @method registerApplicationManifestForAppSwitching:
 @abstract Method to register an application manifests for app switching. (opt-in)
 @discussion An application will only be switchable if the manifest was registered with the app switcher. For each registered manifest, the appswichter will show a single list entry. The entry allows switching to the application that registered the manifest. When a manifest is registered, it will replace any existing manifest with the same URL.
 @param manifests an app manifest dictionary
 */
+ (void)registerApplicationManifestForAppSwitching:(NSDictionary *)manifest __attribute__((deprecated));

/*!
 @method registerApplicationManifestsForAppSwitching:
 @abstract Method to register an array of application manifests for app switching. (opt-in)
 @discussion An application will only be switchable if the manifest was registered with the app switcher. For each registered manifest, the appswichter will show a single list entry. The entry allows switching to the application that registered the manifest. When a manifest is registered, it will replace any existing manifest with the same URL.
 @param manifests an array of app manifest dictionaries
 */
+ (void)registerApplicationManifestsForAppSwitching:(NSArray *)manifests __attribute__((deprecated));

/*!
 @method deregisterApplicationManifestFromAppSwitching:
 @abstract Deregister an application manifests from app switching.
 @discussion This is a noop if the provided manifest was not registered before.
 @param manifests an app manifest dictionary
 */
+ (void)deregisterApplicationManifestFromAppSwitching:(NSDictionary *)manifest __attribute__((deprecated));

/*!
 @method deregisterApplicationManifestsFromAppSwitching:
 @abstract Deregister an array of application manifests from app switching.
 @discussion This is a noop for any manifest that was not registered before.
 @param manifests an array of app manifest dictionaries
 */
+ (void)deregisterApplicationManifestsFromAppSwitching:(NSArray *)manifests __attribute__((deprecated));

/*!
 @method initWithHmiProvider:
 @abstract Initalization method for a new IDApplication instance.
 @discussion The application instance returned by this method will use the given IDHmiProvider to initialize the IDApplication and connect to the default HMI url.
 @param hmiProvider   An object implementing the IDHmiProvider protocol. This will typically be generated by the Remote HMI Editor.
 @return an initialized instance of IDApplication
 */
- (id)initWithHmiProvider:(id<IDHmiProvider>)hmiProvider;

/*!
 @method initWithHmiURL:
 @abstract Initalization method for a new IDApplication instance.
 @discussion This is the designated initializer.
 @param hmiProvider
    The view provider generated by the Remote HMI Editor.
 @param hmiURL An alternative URL.
    The url to the hmi.
 @return an initialized instance of IDApplication
 */
- (id)initWithHmiProvider:(id<IDHmiProvider>)hmiProvider hmiURL:(NSURL *)hmiURL;

/*!
 @method startWithCompletionBlock:
 @abstract Start the remote application asynchronously. The application delegate gets notified whether the startup was successfull or did fail.
 @discussion This method can be considered atomic, that is either the application is started and initialized completely, or not at all, if the startup attempt fails there is no cleanup work necessary. Additionally to get notified through the application delegate the result of the startup is passed to the completion blocks error parameter. If the passed error is nil the startup was successful. The block is guaranteed to execute after all application delegate callbacks have fired. The execution context for the completion block is the same thread the application delegate gets notified on.
 @param block
    a block to be executed after the application did start or did fail to start
 */
- (void)startWithCompletionBlock:(void (^)(NSError *))block;

/*!
 @method stopWithCompletionBlock:
 @abstract Stop the remote application asynchronously.
 @discussion This method can be considered atomic, if the stop attempt fails there is no cleanup work necessary. Additionally to get notified through the application delegate the completion block gets executed. The block is guaranteed to execute after all application delegate callbacks have fired. The execution context for the completion block is the same thread the application delegate gets notified on.
 @param block
    a block to be executed the after application did stop
 */
- (void)stopWithCompletionBlock:(void (^)(void))block;

/*!
 @method performLastUserModeWithView:
 @abstract Performs last user mode for RHMI applications
 @discussion This method should only be called when the RHMI application is expected to do last user mode, i.e. the IDApplicationDelegate received the callback @see applicationRestoreMainHmiState:. In this case the IDApplicationDelegate is expected to decide which IDView (usually the main screen of the Application) should be displayed in the HMI after reconnecting to the vehicle so that (from the user's point of view) it appears as if the App gets opened in the HMI automatically right after the iPhone connected to the HMI. Do not use this method to open HMI states programmatically during the app life cycle.

 @param view
    the view that should be opened in case of last user mode
 */
- (void)performLastUserModeWithView:(IDView *)view;

/*!
 @method name
 @abstract Return the name of the application.
 @discussion This method requires an app datasource and a valid application manifest.
 @return the name of the application
 */
- (NSString *)name;

/*!
 @method vendor
 @abstract Return the vendor of the application.
 @discussion This method requires an app datasource and a valid application manifest.
 @return the vendor of the application
 */
- (NSString *)vendor;

/*!
 @method version
 @abstract Return the version of the application.
 @discussion This method requires an app datasource and a valid application manifest.
 @return the version of the application
 */
- (IDVersionInfo *)version;

#pragma mark -

/*!
 @property connected
 @abstract Information about the connection status of the app.
 */
@property (readonly, getter = isConnected) BOOL connected;

/*!
 @property delegate
 @abstract The delegate must implement the @link IDApplicationDelegate @/link protocol. The delegate will not be retained
    by the IDApplication.
 */
@property (nonatomic, assign) id<IDApplicationDelegate> delegate;

/*!
 @property dataSource
 @abstract The data source must implement the @link IDApplicationDataSource @/link protocol. The data source will not
 be retained by the IDApplication. This property is not KVO compliant.
 */
@property (nonatomic, assign) id<IDApplicationDataSource> dataSource;

/*!
 @property hmiService
 @abstract An @link //apple_ref/occ/cl/IDHmiService @/link instance. This property is not KVO compliant.
 */
@property (retain, readonly) IDHmiService *hmiService;

/*!
 @property cdsService
 @abstract An @link //apple_ref/occ/cl/IDCdsService @/link instance. This property is not KVO compliant.
 */
@property (retain, readonly) IDCdsService *cdsService;

/*!
 @property audioService
 @abstract An @link //apple_ref/occ/cl/IDAudioService @/link instance. This property is not KVO compliant.
 */
@property (retain, readonly) IDAudioService *audioService;

/*!
 @property hmiProvider
 @abstract The @link //apple_ref/occ/cl/IDHmiProvider @/link instance used by this application. This property is not KVO compliant.
 */
@property (readonly) id<IDHmiProvider> hmiProvider;

/*!
 @property vehicleInfo
 @abstract Information about the currently connected vehicle. This property is not KVO compliant.
 */
@property (retain, readonly) IDVehicleInfo *vehicleInfo;

@end
