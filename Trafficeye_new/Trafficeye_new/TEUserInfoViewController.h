//
//  TEUserInfoViewController.h
//  Trafficeye_new
//
//  Created by zc on 13-9-2.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEFisrtLevelViewController.h"

@interface TEUserInfoViewController : TEFisrtLevelViewController<UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageViewAvatar;
@property (strong, nonatomic) IBOutlet UILabel *label_username;
@property (strong, nonatomic) IBOutlet UIImageView *imageView_SNSLogo;
@property (strong, nonatomic) IBOutlet UILabel *label_level;
@property (strong, nonatomic) IBOutlet UILabel *label_points;
@property (strong, nonatomic) IBOutlet UILabel *label_distance;
@property (strong, nonatomic) IBOutlet UILabel *label_badge;
@property (strong, nonatomic) IBOutlet UILabel *label_event;
- (IBAction)buttonClicked:(id)sender;

@end
