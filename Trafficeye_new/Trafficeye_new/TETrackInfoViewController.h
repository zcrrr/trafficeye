//
//  TETrackInfoViewController.h
//  Trafficeye_new
//
//  Created by zc on 13-10-30.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TENetworkHandler.h"
#import "TESecondLevelViewController.h"

@interface TETrackInfoViewController : TESecondLevelViewController<eventDetailDelegate,optionDelegate>
@property (assign, nonatomic) int trackid;
@property (strong, nonatomic) NSString *track_uid;//轨迹的用户uid
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *avatar_url;
@property (assign, nonatomic) float speedValue;

@property (assign, nonatomic) BOOL canVote;
@property (assign, nonatomic) int agreeY;//记录赞同列表下一行的开始y
@property (assign, nonatomic) int disagreeY;//记录反对列表下一行的开始y
@property (assign, nonatomic) int lastOptionType;

@property (strong, nonatomic) IBOutlet UIImageView *imageview_avatar;
@property (strong, nonatomic) IBOutlet UILabel *label_username;
@property (strong, nonatomic) IBOutlet UILabel *label_refreshTime;
@property (strong, nonatomic) IBOutlet UILabel *label_speed;
@property (strong, nonatomic) IBOutlet UIButton *button_agree;
@property (strong, nonatomic) IBOutlet UIButton *button_disagree;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview_agree;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview_disagree;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) IBOutlet UIImageView *loadingImage;
@property (strong, nonatomic) IBOutlet UIButton *button_close;
- (IBAction)button_vote_clicked:(id)sender;
- (IBAction)button_close_clicked:(id)sender;
@end
