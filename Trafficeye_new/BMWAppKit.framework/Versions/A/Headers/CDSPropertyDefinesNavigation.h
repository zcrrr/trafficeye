/*  
 *  CDSPropertyDefinesNavigation.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

/*!
 @constant CDSNavigationCurrentPositionDetailedInfo
 @abstract Provides info in human readable form about the current position of the vehicle.
 @discussion (navigation.currentPositionDetailedInfo) Stored in a response key "currentPositionDetailedInfo" as a dictionary with keys , "city", "country", "street", "houseNumber" and "crossStreet". All paramters are instances of NSSTring except houseNumber, which is a NSNumber. Only city, and country are reliably reported in all vehicles. Please do not rely on values for the street, houseNumber and crossStreet keys.
 */
extern NSString * const CDSNavigationCurrentPositionDetailedInfo;

/*!
 @constant CDSNavigationGuidanceStatus
 @abstract Returns the current state of the route guidance system.
 @discussion Stored in a response key "guidanceStatus" as a number representing a BOOL. Please use boolValue of NSNumber to obtain the result. (navigation.guidanceStatus)
 */
extern NSString * const CDSNavigationGuidanceStatus;

/*!
 @constant CDSNavigationNextDestination
 @abstract Returns the next destination of the vehicle as latitude, longitude coordinates along with the name and type of the destination.
 @discussion (navigation.nextDestination) Stored in a response key "nextDestination" as a dictionary with keys "latitude", "longitude" (both in numbers), "name" (as a string) and "type" (as an enumeration of type eCDSNavigationDestinationType). NOTE: This property does not currently support GET, only BIND. The value for the "name" key is not alway supported please only use the latitude, longitude and type values.
 */
extern NSString * const CDSNavigationNextDestination;

/*!
 @enum eCDSNavigationDestinationType
 @abstract The type of next destination.
 @constant CDSNavigationDestinationType_UNKNOWN
 @constant CDSNavigationDestinationType_COUNTRY
 @constant CDSNavigationDestinationType_CITY
 @constant CDSNavigationDestinationType_STREET
 @constant CDSNavigationDestinationType_POINT
 @constant CDSNavigationDestinationType_HOUSE_NUMBER
 */
enum eCDSNavigationDestinationType
{
    CDSNavigationDestinationType_UNKNOWN = 0,
    CDSNavigationDestinationType_COUNTRY = 1,
    CDSNavigationDestinationType_CITY = 2,
    CDSNavigationDestinationType_STREET = 3,
    CDSNavigationDestinationType_POINT = 4,
    CDSNavigationDestinationType_HOUSE_NUMBER = 5
};

/*!
 @constant CDSNavigationFinalDestination
 @abstract Returns the final destination of the vehicle as latitude, longitude coordinates.
 @discussion (navigation.finalDestination) Stored in a response key "finalDestination" as a dictionary with keys "latitude" and "longitude". Both paramters are numbers.
 */
extern NSString * const CDSNavigationFinalDestination;
