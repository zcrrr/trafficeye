//
//  TEAboutBMWViewController.h
//  Trafficeye_new
//
//  Created by zc on 14-2-28.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TESecondLevelViewController.h"

@interface TEAboutBMWViewController : TESecondLevelViewController
@property (strong, nonatomic) IBOutlet UIWebView *webview;
- (IBAction)button_back_clicked:(id)sender;

@end
