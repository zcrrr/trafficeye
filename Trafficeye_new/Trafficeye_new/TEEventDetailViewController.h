//
//  TEEventDetailViewController.h
//  Trafficeye_new
//
//  Created by zc on 14-2-20.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TECommunityBaseViewController.h"
#import "TENetworkHandler.h"

@interface TEEventDetailViewController : TECommunityBaseViewController<UIWebViewDelegate,lookupFriendsDelegate,bindingDelegate,invitationDelegate>
@property (assign, nonatomic) int eventID;
@property (strong, nonatomic) NSString* type;
@property (strong, nonatomic) NSString* clientIP;
@property (strong, nonatomic) IBOutlet UIWebView *webview;

@end
