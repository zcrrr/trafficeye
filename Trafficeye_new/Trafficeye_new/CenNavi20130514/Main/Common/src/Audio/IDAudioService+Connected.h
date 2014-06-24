//
//  Created by Andreas Streuber on 06.12.11.
//  Copyright (c) 2011 BMW Group. All rights reserved.
//

#import <BMWAppKit/BMWAppKit.h>

@interface IDAudioService (Connected)

+ (NSString *)stringWithIDAudioState:(IDAudioState)state;
+ (NSString *)stringWithIDAudioButtonEvent:(IDAudioButtonEvent)event;

@end
