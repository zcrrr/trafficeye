//
//  TEUserBadgeViewController.h
//  Trafficeye_new
//
//  Created by zc on 13-9-5.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TESecondLevelViewController.h"

@interface TEUserBadgeViewController : TESecondLevelViewController
@property (strong, nonatomic) IBOutlet UIImageView *imageview_avatar;
@property (strong, nonatomic) IBOutlet UILabel *label_username;
@property (strong, nonatomic) IBOutlet UILabel *label_badge_num;
@property (strong, nonatomic) IBOutlet UIButton *button_back;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview_content;
- (IBAction)button_back_clicked:(id)sender;

@end
