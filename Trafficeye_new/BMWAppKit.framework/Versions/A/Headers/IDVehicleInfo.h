/*  
 *  IDVehicleInfo.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */


/*!
 @class IDVehicleInfo
 @abstract IDVehicleInfo holds detailed information about the currently connected vehicle.
 @discussion An instance if IDVehicleInfo holds information about the brand (IDVehicleBrand), the country the vehicle was produced for (IDVehicleCountry), the version of the vehicle's HMI (IDVehicleHmiVersion), and the type of the vehicle's HMI (IDVehicleHmiType).
 */
@interface IDVehicleInfo : NSObject

/*!
 @enum IDVehicleBrand
 @abstract Enumeration of supported vehicle brands.
 @constant IDVehicleBrandUnknown        unknown vehicle brand
 @constant IDVehicleBrandBMW            BMW brand
 @constant IDVehicleBrandMINI           MINI brand
 @constant IDVehicleBrandRollsRoyce     RollsRoyce brand
 */
typedef enum  {
    IDVehicleBrandUnknown = 0,
    IDVehicleBrandBMW = 1,
    IDVehicleBrandMINI = 2,
    IDVehicleBrandRollsRoyce = 3
} IDVehicleBrand;

/*!
 @enum IDVehicleCountry
 @abstract Enumeration of available vehicle countrys. This represents the country the vehicle was produced for. There is no connection to the language setting in the hmi.
 @constant IDVehicleCountryUnknown      unknown country
 @constant IDVehicleCountryGermany     "Deutschland"
 @constant IDVehicleCountryEgypt       "_gypten"
 @constant IDVehicleCountryAustralia   "Australien"
 @constant IDVehicleCountryChina       "China"
 @constant IDVehicleCountryECE         "ECE"
 @constant IDVehicleCountryHongKong    "Hongkong"
 @constant IDVehicleCountryJapan       "Japan"
 @constant IDVehicleCountryCanada      "Kanada"
 @constant IDVehicleCountryKorea       "Korea"
 @constant IDVehicleCountryTaiwan      "Taiwan"
 @constant IDVehicleCountryUSA         "US"
 */
typedef enum {
    IDVehicleCountryUnknown = 0,
    IDVehicleCountryGermany = 1,
    IDVehicleCountryEgypt = 2,
    IDVehicleCountryAustralia = 3,
    IDVehicleCountryChina = 4,
    IDVehicleCountryECE = 5,
    IDVehicleCountryHongKong = 6,
    IDVehicleCountryJapan = 7,
    IDVehicleCountryCanada = 8,
    IDVehicleCountryKorea = 9,
    IDVehicleCountryTaiwan = 10,
    IDVehicleCountryUSA = 11
} IDVehicleCountry;

/*!
 @enum IDVehicleHmiVersion
 @abstract Enumeration of available HMI versions.
 @constant IDVehicleHmiVersionSimulator HMI Simulator (no specific hmi version)
 @constant IDVehicleHmiVersion1011      November 2010 release.
 @constant IDVehicleHmiVersion1011      November 2010 release.
 @constant IDVehicleHmiVersion1103      March 2011 release.
 @constant IDVehicleHmiVersion1107      July 2011 release.
 @constant IDVehicleHmiVersion1111      November 2011 release.
 @constant IDVehicleHmiVersion1203      March 2012 release.
 @constant IDVehicleHmiVersion1207      July 2012 release.
 @constant IDVehicleHmiVersion1211      November 2012 release.
 @constant IDVehicleHmiVersion1303      March 2013 release.
 @constant IDVehicleHmiVersion1307      July 2013 release.
 @constant IDVehicleHmiVersion1309      September 2013 release.
 @constant IDVehicleHmiVersion1311      November 2013 release.
 @constant IDVehicleHmiVersion1403      March 2014 release.
 @constant IDVehicleHmiVersion1407      July 2014 release.
 */
typedef enum  {
    IDVehicleHmiVersionUnknown = 0,
    IDVehicleHmiVersionSimulator = 1,
    IDVehicleHmiVersion1011 = 2,
    IDVehicleHmiVersion1103 = 3,
    IDVehicleHmiVersion1107 = 4,
    IDVehicleHmiVersion1111 = 5,
    IDVehicleHmiVersion1203 = 6,
    IDVehicleHmiVersion1207 = 7,
    IDVehicleHmiVersion1211 = 8,
    IDVehicleHmiVersion1303 = 9,
    IDVehicleHmiVersion1307 = 10,
    IDVehicleHmiVersion1309 = 11,
    IDVehicleHmiVersion1311 = 12,
    IDVehicleHmiVersion1403 = 13,
    IDVehicleHmiVersion1407 = 14
} IDVehicleHmiVersion;

/*!
 @enum IDVehicleHmiType
 @abstract Enumeration of available HMI types.
 @constant IDVehicleHmiTypeUnknown      unknown hmi type
 @constant IDVehicleHmiTypeID4          ID4 (2D hmi)
 @constant IDVehicleHmiTypeID4PlusPlus  ID4++ (3D hmi)
 */
typedef enum {
    IDVehicleHmiTypeUnknown = 0,
    IDVehicleHmiTypeID4 = 1,
    IDVehicleHmiTypeID4PlusPlus = 2
} IDVehicleHmiType;

/*!
 @property brand
 @abstract The brand of the currently connected vehicle.
 */
@property (assign, readonly) IDVehicleBrand brand;

/*!
 @property hmiVersion
 @abstract The hmi version of the currently connected vehicle.
 */
@property (assign, readonly) IDVehicleHmiVersion hmiVersion;

/*!
 @property hmiType
 @abstract The hmi type of the currently connected vehicle.
 */
@property (assign, readonly) IDVehicleHmiType hmiType;

/*!
 @property country
 @abstract The country of the currently connected vehicle.
 */
@property (assign, readonly) IDVehicleCountry country;

/*!
 @property vehicleType
 @abstract The type of the connected vehicle. (e.g. E90, F10, R61, ...)
 */
@property (strong, readonly) NSString *vehicleType;

@end
