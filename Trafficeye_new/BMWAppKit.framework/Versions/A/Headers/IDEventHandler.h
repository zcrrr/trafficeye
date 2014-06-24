/*  
 *  IDEventHandler.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */


#import <Foundation/Foundation.h>

@class IDVariantMap;

@protocol IDEventHandler <NSObject>

@optional
- (void)handleHmiEvent:(NSString*)eventKey component:(NSUInteger)componentId info:(IDVariantMap*)info;
- (void)handleActionEvent:(NSString*)eventKey info:(IDVariantMap*)info;
- (void)handleAsyncPropertyEvent:(NSString*)ident value:(id)propertyValue;
- (void)handlePropertyChangedEvent:(NSString*)propertyName value:(id)propertyValue;

@end
