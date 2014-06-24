//
//  TESigraAddCityViewController.h
//  Trafficeye_new
//
//  Created by zc on 14-1-14.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TESecondLevelViewController.h"

@interface TESigraAddCityViewController : TESecondLevelViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
- (IBAction)button_city_clicked:(id)sender;
- (IBAction)button_back_clicked:(id)sender;

@end
