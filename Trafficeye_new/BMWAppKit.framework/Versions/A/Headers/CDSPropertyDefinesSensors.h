/*  
 *  CDSPropertyDefinesSensors.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

/*!
 @constant CDSSensorsBatteryTemp
 @abstract The battery temperature.
 @discussion (sensors.batteryTemp) Value is stored in response key "batteryTemp" as a number.
 */
extern NSString * const CDSSensorsBatteryTemp;

/*!
 @constant CDSSensorsFuel
 @abstract The amount of driving range given the current fuel level expressed in km and if the reserve tank is being used.
 @discussion (sensors.fuel) Stored in response key "fuel" as dictionary with keys "range", "tanklevel" and "reserve".  tanlevel and range are returned as numbers while reserve is returned as an enumeration of type eCDSSensorsFuelReserve.
 */
extern NSString * const CDSSensorsFuel;

/*!
 @enum eCDSSensorsFuelReserve
 @abstract If the reserve tank is being used.
 @constant CDSSensorsFuelReserve_NO
 @constant CDSSensorsFuelReserve_YES
 @constant CDSSensorsFuelReserve_INVALID
 */
enum eCDSSensorsFuelReserve
{
    CDSSensorsFuelReserve_NO = 0,
    CDSSensorsFuelReserve_YES = 1,
    CDSSensorsFuelReserve_INVALID = 3
};

/*!
 @constant CDSSensorsSOCBatteryHybrid
 @abstract The charge level of the battery expressed in percentage.
 @discussion (sensors.SOCBatteryHybrid) Value is stored in response key "SOCBatteryHybrid" as a number. The value is a percentage (0-100) with approximacy 0.5.
 */
extern NSString * const CDSSensorsSOCBatteryHybrid;
