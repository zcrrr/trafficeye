//
//  TEEditPasswordViewController.h
//  Trafficeye_new
//
//  Created by zc on 13-9-10.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TESecondLevelViewController.h"
#import "TENetworkHandler.h"

@interface TEEditPasswordViewController : TESecondLevelViewController<UserEditPasswordDelegate>
@property (strong, nonatomic) IBOutlet UITextField *textfield_oldpwd;
@property (strong, nonatomic) IBOutlet UITextField *textfield_newpwd;
- (IBAction)save_new_pwd:(id)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) IBOutlet UIButton *button_back;
@property (strong, nonatomic) IBOutlet UIImageView *loadingImage;
- (IBAction)button_back_clicked:(id)sender;

@end
