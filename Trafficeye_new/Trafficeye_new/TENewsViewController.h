//
//  TENewsViewController.h
//  Trafficeye_new
//
//  Created by zc on 13-10-15.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEFisrtLevelViewController.h"

@interface TENewsViewController : TEFisrtLevelViewController<UIWebViewDelegate>
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) NSString *city;

@property (strong, nonatomic) IBOutlet UIImageView *loadingImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
