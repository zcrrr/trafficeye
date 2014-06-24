//
//  TEMessageViewController.h
//  Trafficeye_new
//
//  Created by zc on 14-2-20.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TECommunityBaseViewController.h"
#import "TENetworkHandler.h"

@interface TEMessageViewController : TECommunityBaseViewController<UIWebViewDelegate,lookupFriendsDelegate,bindingDelegate,invitationDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) NSString* clientIP;

@end
