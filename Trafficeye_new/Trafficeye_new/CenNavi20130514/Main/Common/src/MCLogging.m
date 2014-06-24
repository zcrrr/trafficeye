//
//  MCLogging.c
//  Connected
//
//  Created by Andreas Netzmann on 14.05.12.
//  Copyright (c) 2012 BMW Group. All rights reserved.
//

#import "MCLogging.h"

static void MCLogV(IDLogLevel logLevel, NSString *category, NSString *format, va_list va)
{
    @autoreleasepool
    {
        NSString *message = [[[NSString alloc] initWithFormat:format arguments:va] autorelease];
        
        [[IDLogger defaultLogger] logMessage:message tag:category level:logLevel];
    }
}

void MCLog(IDLogLevel level, NSString* format, ...)
{
    // To increase performance check here already if the default logger would process this message at all
    IDLogLevel maxLogLevel = [IDLogger defaultLogger].maximumLogLevel;
    if (IDLogLevelNone == level || level > maxLogLevel) { return; }
    
    va_list va;
    va_start(va, format);
    
    MCLogV(level, @"", format, va);
    
    va_end(va);
}

