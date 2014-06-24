/*
 *  MCApplicationDataSource.h
 *  Connected
 *
 *  Created by Wolfram Manthey on 15.03.10.
 *  Copyright 2010 BMW Group. All rights reserved.
 *
 *  $Id$
 */
#import <BMWAppKit/BMWAppKit.h>
@protocol MCApplicationDataSource

@property (readonly, retain) IDVehicleInfo *connectedVehicleInfo;
@property (readonly, atomic, copy) NSDictionary *connectedVehicleState;



@end
