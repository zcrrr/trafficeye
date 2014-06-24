//
//  TEUserViewController.h
//  Trafficeye_new
//
//  Created by 张 驰 on 13-6-17.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TEFisrtLevelViewController.h"
#import "TENetworkHandler.h"

@interface TEUserViewController : TEFisrtLevelViewController<UITextFieldDelegate,loginDelegate,snsLoginDelegate>
@property (strong, nonatomic) IBOutlet UITextField *textField_email;
@property (strong, nonatomic) IBOutlet UITextField *textFiled_secret;
@property (strong, nonatomic) IBOutlet UIImageView *loadingImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) NSMutableDictionary* userInfo4ChangeName;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)clickLogin:(id)sender;
- (IBAction)clickForetPassword:(id)sender;
- (IBAction)clickReg:(id)sender;
- (IBAction)click_sina_login:(id)sender;
- (IBAction)click_qq_login:(id)sender;

@end
