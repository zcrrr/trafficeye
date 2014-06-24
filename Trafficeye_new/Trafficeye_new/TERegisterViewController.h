//
//  TERegisterViewController.h
//  Trafficeye_new
//
//  Created by 张 驰 on 13-7-31.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TESecondLevelViewController.h"
#import "TENetworkHandler.h"

@interface TERegisterViewController : TESecondLevelViewController<UITextFieldDelegate,registerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *tf_email;
@property (strong, nonatomic) IBOutlet UITextField *tf_nickname;
@property (strong, nonatomic) IBOutlet UITextField *tf_password;
@property (strong, nonatomic) IBOutlet UIImageView *loadingImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;


- (IBAction)backgroundTap:(id)sender;
- (IBAction)register:(id)sender;
- (IBAction)button_back_clicked:(id)sender;

@end
