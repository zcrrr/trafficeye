/*  
 *  IDFlushProtocol.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <UIKit/UIKit.h>



/**
 *
 */
typedef enum IDFlushPriority {
	IDFlushPriorityHigh,
	IDFlushPriorityNormal
} IDFlushPriority;


/**
 *
 */
typedef enum IDFlushSpeed {
	IDFlushSpeedEarlyFast,
	IDFlushSpeedFast,
	IDFlushSpeedLateFast,
	IDFlushSpeedMedium,
	IDFlushSpeedFull
} IDFlushSpeed;



@protocol IDFlushProtocol

/**
 *
 */
-(IDFlushPriority)priority;


/**
 *
 */
-(void)flush:(IDFlushSpeed)speed;

/**
 * Tells the object
 * that its flush method needs 
 * to be called again.
 */
-(void)setNeedsFlush;

@end
