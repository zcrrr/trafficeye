//
//  TERewardViewController.h
//  Trafficeye_new
//
//  Created by 张 驰 on 13-7-30.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TERewardViewController : UIViewController
@property (nonatomic, strong) NSDictionary* reward_dic;
@property (strong, nonatomic) IBOutlet UIScrollView *content_view;

@property (nonatomic, retain) NSTimer* timer_hide;

@end
