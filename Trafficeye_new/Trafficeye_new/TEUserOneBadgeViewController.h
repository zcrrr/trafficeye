//
//  TEUserOneBadgeViewController.h
//  Trafficeye_new
//
//  Created by zc on 13-9-17.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEBadge.h"
#import "TESecondLevelViewController.h"

@interface TEUserOneBadgeViewController : TESecondLevelViewController

@property (strong,nonatomic) TEBadge* badge;

@property (strong, nonatomic) IBOutlet UILabel *label_badge_name;
@property (strong, nonatomic) IBOutlet UIImageView *imageview_badge;
@property (strong, nonatomic) IBOutlet UILabel *label_condition;
- (IBAction)button_back_clicked:(id)sender;

@end
