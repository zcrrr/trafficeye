/*  
 *  CDSPropertyDefines.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "CDSPropertyDefinesControls.h"
#import "CDSPropertyDefinesDriving.h"
#import "CDSPropertyDefinesEngine.h"
#import "CDSPropertyDefinesEntertainment.h"
#import "CDSPropertyDefinesNavigation.h"
#import "CDSPropertyDefinesSensors.h"
#import "CDSPropertyDefinesVehicle.h"

/*!
 @enum CDSError
 @abstract Possible values for CDS errors.
 @constant CDSErrorInvalidProperty
 @constant CDSErrorPropertyUnavailable
 @constant CDSErrorPropertyForbidden
 */
typedef enum
{
    CDSErrorInvalidProperty = 400,
    CDSErrorPropertyUnavailable = 401,
    CDSErrorPropertyForbidden = 402
} CDSError;
