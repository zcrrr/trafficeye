//
//  TEForgetPasswordViewController.h
//  Trafficeye_new
//
//  Created by zc on 13-9-17.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TESecondLevelViewController.h"
#import "TENetworkHandler.h"

@interface TEForgetPasswordViewController : TESecondLevelViewController<UserForgetPasswordDelegate>
@property (strong, nonatomic) IBOutlet UITextField *textfield_email;
- (IBAction)button_clicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) IBOutlet UIButton *button_back;
@property (strong, nonatomic) IBOutlet UIImageView *loadingImage;
- (IBAction)button_back_clicked:(id)sender;
@end
