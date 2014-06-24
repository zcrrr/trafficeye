/*  
 *  IDService.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

/*!
 service methods return block
 */
typedef void (^IDServiceCallCompletionBlock)(NSError *error);

@class IDApplication;

/*!
 @class IDService
    An abstract service base class.
 */
@interface IDService : NSObject

/*!
 @property application
    The application the service belongs to.
 */
@property (readonly) IDApplication* application;

/*!
 @property serviceId
    The unique identifier of the service.
 */
@property (readonly) NSUInteger serviceId;

@end
