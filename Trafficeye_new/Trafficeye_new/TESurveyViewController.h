//
//  TESurveyViewController.h
//  Trafficeye_new
//
//  Created by zc on 14-2-21.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEFisrtLevelViewController.h"

@interface TESurveyViewController : TEFisrtLevelViewController<CheckUserDelegate>

@property (assign, nonatomic) int action;
@property (retain, nonatomic) IBOutlet UIButton *button_action;
@property (retain, nonatomic) IBOutlet UILabel *label_info;
@property (retain, nonatomic) IBOutlet UILabel *label_username;
@property (retain, nonatomic) IBOutlet UILabel *label_phonenum;
@property (retain, nonatomic) IBOutlet UILabel *label_sex;
@property (retain, nonatomic) IBOutlet UILabel *label_birthday;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollview;
@property (retain, nonatomic) NSString* url_param;



- (IBAction)button_click:(id)sender;

@end
