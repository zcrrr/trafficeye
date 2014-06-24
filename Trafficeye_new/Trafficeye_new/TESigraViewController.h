//
//  TESigraViewController.h
//  Trafficeye_new
//
//  Created by 张 驰 on 13-6-17.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TEFisrtLevelViewController.h"

@interface TESigraViewController : TEFisrtLevelViewController<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong,nonatomic) NSMutableArray *favRouteList;
@property (strong, nonatomic) NSString *weiboText;

@property (strong, nonatomic) IBOutlet UIImageView *loadingImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
