/*  
 *  CDSPropertyDefinesDriving.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

/*!
 @constant CDSDrivingElectricalPowerDistribution
 @abstract The electrical power distribuition between different consumers (motor, air conditioner, seat heater)
 @discussion (driving.electricalPowerDistribution) Value is stored as dictionary with keys "rangeBoostAirConditioner", "rangeBoostSeatHeater", "power" and "powerAirConditioner".
 */
extern NSString * const CDSDrivingElectricalPowerDistribution;

/*!
 @constant CDSDrivingOdometer
 @abstract The total number of kilometers on a vehicle.  Should miles be required, the client should be responsible for the conversion.
 @discussion (driving.odometer) Stored in response key "odometer" as a number.
 */
extern NSString * const CDSDrivingOdometer;

/*!
 @constant CDSDrivingDisplayRangeElectricVehicle
 @abstract The amount of driving range with the current battery charge level.
 @discussion (driving.displayRangeElectricVehicle) Value is stored in response key "displayRangeElectricVehicle" as a number.
 */
extern NSString * const CDSDrivingDisplayRangeElectricVehicle;

/*!
 @constant CDSDrivingSOCHoldState
 @abstract Information about SOC hold activation.
 @discussion (driving.SOCHoldState) Value is stored in response key "SOCHoldState" as enumeration of type eCDSDrivingSOCHoldState.
 */
extern NSString * const CDSDrivingSOCHoldState;

/*!
 @enum eCDSDrivingSOCHoldState
 @abstract The SOC hold states.
 @constant CDSDrivingSOCHoldState_INACTIVE
 @constant CDSDrivingSOCHoldState_ACTIVE
 @constant CDSDrivingSOCHoldState_INVALID
 */
enum eCDSDrivingSOCHoldState
{
    CDSDrivingSOCHoldState_INACTIVE = 0,
    CDSDrivingSOCHoldState_ACTIVE = 1,
    CDSDrivingSOCHoldState_INVALID = 3
};

/*!
 @constant CDSDrivingSpeedActual
 @abstract The current actual driving speed reported in km/h.
 @discussion (driving.speedActual) Value is stored in response key "speedActual" as a number.
 */
extern NSString * const CDSDrivingSpeedActual;

/*!
 @constant CDSDrivingDrivingStyle
 @abstract The evaluation of the driver style.
 @discussion (driving.drivingStyle) Value is stored as dictionary with keys "accellerate", "brake" and "shift".
 */
extern NSString * const CDSDrivingDrivingStyle;
