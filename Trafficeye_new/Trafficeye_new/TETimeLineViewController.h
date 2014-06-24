//
//  TETimeLineViewController.h
//  Trafficeye_new
//
//  Created by zc on 14-2-20.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TENetworkHandler.h"
#import "TECommunityBaseViewController.h"

@interface TETimeLineViewController : TECommunityBaseViewController<UIWebViewDelegate,lookupFriendsDelegate,bindingDelegate,invitationDelegate>
@property (strong, nonatomic) NSString* clientIP;
@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) NSString* pageName;
@property (strong, nonatomic) NSString* goto_param;

@end
