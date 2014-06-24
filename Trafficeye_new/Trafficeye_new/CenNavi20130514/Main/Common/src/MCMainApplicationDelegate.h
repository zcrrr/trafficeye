//
//  Connected
//
//  Created by Wolfram Manthey on 02.02.10.
//  Copyright 2010 BMW Group. All rights reserved.
//


#import "MCApplicationDataSource.h"
#import "MCOnboardViewController.h"

@class IDLogAppender;


@interface MCMainApplicationDelegate : NSObject <MCApplicationDataSource>
{
    // view controllers managed by MCMainApplicationDelegate
    MCOnboardViewController*    onboardViewController;          // 
    
    BOOL     _carConnected;
}

@property (readonly) BOOL           carConnected;


- (void)startup;
- (BOOL)mcMainHandleOpenURL:(NSURL*)url;

@end






