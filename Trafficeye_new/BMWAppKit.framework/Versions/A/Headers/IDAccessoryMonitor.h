/*  
 *  IDAccessoryMonitor.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */


@class IDVehicleInfo;


/*!
 @constant IDAccessoryDidConnectNotification
 @discussion Gets posted when a supported external accessory was connected.
 */
extern NSString *const IDAccessoryDidConnectNotification;

/*!
 @constant IDAccessoryDidDisconnectNotification
 @discussion Gets posted when a supported external accessory was disconnected.
 */
extern NSString *const IDAccessoryDidDisconnectNotification;

/*!
 @constant IDAccessoryNetworkAccessDidChangeNotification
 @abstract Notification indicating network access by the accessory monitor (cellular or wifi).
 @discussion The notification is sent when the network access status of the monitor did change. Developers may use the notification to inform the user about network access. The userInfo dictionary of the notification contains a BOOL value whether the network is used by the monitor or not. The notification is posted on the main thread.
 */
extern NSString *const IDAccessoryNetworkAccessDidChangeNotification;
extern NSString *const IDAccessoryUsingNetworkKey;

/*!
 @class IDAccessoryMonitor
 @abstract This class is responsible for monitoring the availability of a BMWAppKit compatible accessory.
 @discussion The supported external accessory protocol string is: "com.bmw.a4a". The developer is responsible to add the protocol string to the Info.plist file and to register for local notification (external accessory). The class will send out notifications to inform about the connection status to the BMWAppKit compatible accessory.
 */
@interface IDAccessoryMonitor : NSObject

@property (strong, readonly) IDVehicleInfo *vehicleInfo;

/*!
 @method init
 @abstract Returns a preconfigured instance of a4a accessory monitor.
 @discussion The monitor will be configured depending on its environment. Keep a strong reference to the returned instance as long as the accessory monitor is required.
 @return The accessory monitor instance.
 */
- (id)init;

/*!
 @method startMonitoring
 @abstract Method to start monitoring for BMWAppKit compatible accessories.
 @discussion Make sure to register the a4a protocol string and enable local notification handler prior to calling this method. The accessory monitor will not post a4a accessory related notifications before this method was called.
 */
- (void)startMonitoring;

/*!
 @method stopMonitoring
 @abstract Method to stop monitoring for BMWAppKit compatible accessorys.
 @discussion After this method was called the accessory monitor will no longer post a4a accessory related notification.
 */
- (void)stopMonitoring;

@end
