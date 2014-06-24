//
//  TESurveyStep2ViewController.h
//  Trafficeye_new
//
//  Created by zc on 14-2-24.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TESecondLevelViewController.h"

@interface TESurveyStep2ViewController : TESecondLevelViewController<UIWebViewDelegate>
@property (retain, nonatomic) NSString* param_url;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) IBOutlet UIImageView *loadingImage;
@property (strong, nonatomic) IBOutlet UIWebView *webview;

@end
