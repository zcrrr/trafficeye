/*  
 *  IDCdsService.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "IDService.h"
#import "IDEventHandler.h"


@class IDVersionInfo;

/*!
 @class IDCdsService
 @abstract This service class provides the communication layer to the car data service (aka CDS).
 @discussion To be able to use the car data service an IDApplication must state that it requires access to the service in its manifest.
    If access to the car data service is granted this class can be used to retrieve information from the service.
    For all available properties (refer to @link //apple_ref/doc/header/CDSPropertyDefines.h @/link) there are in general two ways of retrieving their current value: binding to the property for retrieving updates for all changes of the propertie's value and getting the current value once.
 @updated 2012-05-24
 */
@interface IDCdsService : IDService <IDEventHandler>

/*!
 @method bindProperty:target:selector:completionBlock:
 @abstract Bind to the value of a car data service property.
 @param propertyName
    Name of the car data service property which should become to.
 @param target
    The target object to receive the callback
 @param selector
    The selector to be called when the property changed. It get always called
 @param completionBlock
    The block that should be called at the end of the bind operation or nil.
 */
- (void)bindProperty:(NSString *)propertyName
              target:(id)target
            selector:(SEL)selector
     completionBlock:(IDServiceCallCompletionBlock)completionBlock;

/*!
 @method bindProperty:interval:target:selector:completionBlock:
 @abstract Bind to the value of a car data service property.
 @param propertyName
    Name of the car data service property which should become bound.
 @param interval
    The minimum data update time interval in seconds.
 @param target
    The target object to receive the callback
 @param selector
    The selector to be called when the property changed. It get always called
 @param completionBlock
    The block that should be called at the end of the bind operation or nil.
 */
- (void)bindProperty:(NSString *)propertyName
            interval:(NSTimeInterval)interval
              target:(id)target
            selector:(SEL)selector
     completionBlock:(IDServiceCallCompletionBlock)completionBlock;

/*!
 @method unbindProperty:completionBlock:
 @abstract Unbind from the value of a car data service property.
 @param propertyName
    Name of the car data service property which should become unbound.
 @param completionBlock
    The block that should be called at the end of the unbind operation or nil.
 */
- (void)unbindProperty:(NSString *)propertyName
       completionBlock:(IDServiceCallCompletionBlock)completionBlock;

/*!
 @method asyncGetProperty:target:selector:completionBlock:
 @abstract Asynchronously fetch the value of a car data service property.
 @param propertyName
    Name of the car data service property which should get fetched.
 @param target
    The target object to receive the callback
 @param selector
    The selector to be called when the property got fetched.
 @param completionBlock
    The block that should be called at the end of the get operation or nil.
 */
- (void)asyncGetProperty:(NSString *)propertyName
                  target:(id)target
                selector:(SEL)selector
         completionBlock:(IDServiceCallCompletionBlock)completionBlock;

/*!
 @property versionInfo
 @abstract The version of the crrently connected vehicle's car data service.
 */
@property (retain, readonly) IDVersionInfo *versionInfo;

@end
