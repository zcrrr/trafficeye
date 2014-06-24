/*
 *  MCNotifications.m
 *  Connected
 *
 *  Created by Wolfram Manthey on 16.06.10.
 *  Copyright 2010 BMW Group. All rights reserved.
 *
 *  $Id$
 */

#import "MCNotifications.h"


IMPL_NOTIFICATION (MCConnectionDidStartNotification)
IMPL_NOTIFICATION (MCConnectionDidFinishNotification)

IMPL_NOTIFICATION (MCCommunicationCurrentCallInfoDidChangeNotification)
NSString *const MCCommunicationCurrentCallInfoNameKey = @"name";
NSString *const MCCommunicationCurrentCallInfoNumberKey = @"number";
