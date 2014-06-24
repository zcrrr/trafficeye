//
//  TETaxiHelpViewController.h
//  Trafficeye_new
//
//  Created by zc on 13-11-1.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TESecondLevelViewController.h"
#import "GADBannerView.h"


@interface TETaxiHelpViewController : TESecondLevelViewController
@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) GADBannerView *bannerView_;
- (IBAction)button_back_clicked:(id)sender;



@end
