/*
 *  MCNotifications.h
 *  Connected
 *
 *  Created by Wolfram Manthey on 16.06.10.
 *  Copyright 2010 BMW Group. All rights reserved.
 *
 *  $Id$
 */


DECL_NOTIFICATION (MCConnectionDidStartNotification)
DECL_NOTIFICATION (MCConnectionDidFinishNotification)


DECL_NOTIFICATION (MCCommunicationCurrentCallInfoDidChangeNotification)
extern NSString *const MCCommunicationCurrentCallInfoNameKey;
extern NSString *const MCCommunicationCurrentCallInfoNumberKey;
