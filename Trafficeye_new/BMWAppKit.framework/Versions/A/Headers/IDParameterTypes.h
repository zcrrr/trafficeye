/*  
 *  IDParameterTypes.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

// TODO: review and complete documentation

/*!
 @enum IDParameterTypes
 @abstract Defines various possible parameter types.
 @constant IDParameterInvalid An invalid parameter type.
 @constant IDParameterValue The parameter is a value.
 @constant IDParameterActionEventListIndex The parameter is a list index.
 @constant IDParameterActionEventSelectedValue The parameter is the value selected by a gauge component.
 @constant IDParameterActionEventChecked The parameter represents the state of a checkbox component.
 @constant IDParameterHmiEventFocus The parameter represents the focus state (i.e. did a view gain or lose the focus)
 @constant IDParameterHmiEventRequestDataFrom 
 @constant IDParameterHmiEventRequestDataSize
 @constant IDParameterHmiEventSplitscreen
 @constant IDParameterActionEventSpellerInput The parameter represents the user input of a speller component.
 @constant IDParameterActionEventKeyCode
 @constant IDParameterHmiEventChannelStatus
 @constant IDParameterHmiEventConnectionStatus
 @constant IDParameterHmiEventVisible The parameter represents a HMI state's visible state
    (i.e. did a view appear or disappear on the view stack?)
 @constant IDParameterHmiEventMoviesPermission
 @constant IDParameterHmiEventTUIMode
 @constant IDParameterActionEventLocationInput The parameter represents the result of a location input.
 @constant IDParameterHmiEventListIndex
 @constant IDParameterActionEventSelectionText
 @constant IDParameterActionEventInvokedBy
 */
typedef enum IDParameterTypes
{
    IDParameterInvalid = 255,
    IDParameterValue = 0,
    IDParameterActionEventListIndex = 1,
    IDParameterActionEventSelectedValue = 2,
    IDParameterActionEventChecked = 3,
    IDParameterHmiEventFocus = 4,
    IDParameterHmiEventRequestDataFrom = 5,
    IDParameterHmiEventRequestDataSize = 6,
    IDParameterHmiEventSplitscreen = 7,
    IDParameterActionEventSpellerInput = 8,
    IDParameterActionEventKeyCode = 20,
    IDParameterHmiEventKeyCode = 20,
    IDParameterHmiEventChannelStatus = 21,
    IDParameterHmiEventConnectionStatus = 22,
    IDParameterHmiEventVisible = 23,
    IDParameterHmiEventMoviesPermission = 24,
    IDParameterHmiEventTUIMode = 25,
    IDParameterActionEventLocationInput = 40,
    IDParameterHmiEventListIndex = 41,
    IDParameterActionEventSelectionText = 42,
    IDParameterActionEventInvokedBy = 43
} IDParameterTypes;
