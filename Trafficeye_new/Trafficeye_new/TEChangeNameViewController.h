//
//  TEChangeNameViewController.h
//  Trafficeye_new
//
//  Created by zc on 14-1-10.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TENetworkHandler.h"
#import "TESecondLevelViewController.h"

@interface TEChangeNameViewController : TESecondLevelViewController<snsLoginDelegate>
@property (strong, nonatomic) NSMutableDictionary* userInfo;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) IBOutlet UIImageView *loadingImage;
@property (strong, nonatomic) IBOutlet UIButton *button_back;
@property (strong, nonatomic) IBOutlet UIButton *button_submit;
@property (strong, nonatomic) IBOutlet UITextField *textfield_name;
- (IBAction)button_back_clicked:(id)sender;
- (IBAction)button_submit_clicked:(id)sender;
@end
