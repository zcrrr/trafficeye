//
//  MCLogging.h
//  Connected
//
//  Created by Andreas Netzmann on 14.05.12.
//  Copyright (c) 2012 BMW Group. All rights reserved.
//

//#ifndef MCLogging
#define MCLogging

@interface NSString (IDLogger)
+ (NSString *)stringForLogLevel:(IDLogLevel)level;
@end


#define MCFLog(level, fmt, ...) \
MCLog(level, (@"%s [Line %d] " fmt), __FUNCTION__, __LINE__, ##__VA_ARGS__);

#define MCLogWithCategory(level, category, fmt, ...) \
MCLog(level, (@"[%@] " fmt), category, ##__VA_ARGS__);

#ifdef __cplusplus
#define MY_EXTERN_C extern "C"
#else
#define MY_EXTERN_C extern
#endif

MY_EXTERN_C void MCLog(IDLogLevel level, NSString* format, ...);


//#endif
