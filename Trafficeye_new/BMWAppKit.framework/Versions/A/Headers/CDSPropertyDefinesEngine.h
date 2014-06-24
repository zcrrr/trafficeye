/*  
 *  CDSPropertyDefinesEngine.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

/*!
 @constant CDSEngineElectricVehicleMode
 @abstract Returns the value of the EV-Mode status.
 @discussion (engine.electricVehicleMode) Stored as enumeration of type eCDSEngineElectricVehicleMode.
 */
extern NSString * const CDSEngineElectricVehicleMode;

/*!
 @enum eCDSEngineElectricVehicleMode
 @abstract EV-Mode states.
 @constant CDSEngineElectricVehicleMode_EV_OFF
 @constant CDSEngineElectricVehicleMode_EV_ON
 @constant CDSEngineElectricVehicleMode_INVALID
 */
enum eCDSEngineElectricVehicleMode
{
    CDSEngineElectricVehicleMode_EV_OFF = 0,
    CDSEngineElectricVehicleMode_EV_ON = 1,
    CDSEngineElectricVehicleMode_INVALID = 15
};

/*!
 @constant CDSEngineRangeCalc
 @abstract The energy consumption or generation.
 @discussion (engine.rangeCalc) Values are stored in a dictionary with keys "energyREXGenerator", "energyEMotorTraction", "energyEMotorRecuperation","auxConsumerEnergy" and "auxConsumerEnergyBaseLoad".
 */
extern NSString * const CDSEngineRangeCalc;

/*!
 @constant CDSEngineStatus
 @abstract Returns the value of the engine status.
 @discussion (engine.status) Stored as enumeration of type eCDSEngineStatus.
 */
extern NSString * const CDSEngineStatus;

/*!
 @enum eCDSEngineStatus
 @abstract The engine states.
 @constant CDSEngineStatus_OFF
 @constant CDSEngineStatus_STARTING
 @constant CDSEngineStatus_RUNNING
 @constant CDSEngineStatus_INVALID
 */
enum eCDSEngineStatus
{
    CDSEngineStatus_OFF = 0,
    CDSEngineStatus_STARTING = 1,
    CDSEngineStatus_RUNNING = 2,
    CDSEngineStatus_INVALID = 3
};
