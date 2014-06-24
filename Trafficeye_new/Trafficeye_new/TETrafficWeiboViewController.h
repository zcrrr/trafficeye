//
//  TETrafficWeiboViewController.h
//  Trafficeye_new
//
//  Created by 张 驰 on 13-6-17.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TEFisrtLevelViewController.h"

@interface TETrafficWeiboViewController : TEFisrtLevelViewController<UIWebViewDelegate>
@property (strong, nonatomic) NSMutableString *province;
@property (strong, nonatomic) NSMutableString *city;
@property (strong, nonatomic) NSMutableString *cityName;
@property (strong, nonatomic) NSMutableString *type;
@property (retain, nonatomic) IBOutlet UIWebView *springWeiboWebView;
@property (strong, nonatomic) IBOutlet UILabel *pageLabel;

@property (strong, nonatomic) IBOutlet UIImageView *loadingImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

- (IBAction)firstPage:(id)sender;
- (IBAction)previousPage:(id)sender;
- (IBAction)nextPage:(id)sender;
- (IBAction)lastPage:(id)sender;
- (IBAction)button_setting_clicked:(id)sender;
- (IBAction)button_refresh_clicked:(id)sender;

@end
