/*  
 *  CDSPropertyDefinesControls.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

/*!
 @constant CDSControlsHeadlights
 @abstract This gives the value pertaining to the current status of the vehicle's exterior headlight status
 @discussion (controls.headlights) Stored in response key "headlights" as enumeration of type eCDSControlsLights.
 */
extern NSString * const CDSControlsHeadlights;

/*!
 @enum eCDSControlsLights
 @abstract Status of the vehicle's exterior headlight.
 @constant CDSControlsLights_OFF
 @constant CDSControlsLights_ON
 */
enum eCDSControlsLights
{
    CDSControlsLights_OFF = 0,
    CDSControlsLights_ON = 1
};
