//
//  TEEventInfoViewController.h
//  Trafficeye_new
//
//  Created by zc on 13-10-18.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TESecondLevelViewController.h"
#import "TENetworkHandler.h"

@interface TEEventInfoViewController : TESecondLevelViewController<eventDetailDelegate,optionDelegate>
@property (assign, nonatomic) int eventid;
@property (strong, nonatomic) NSString *event_uid;//用户uid
@property (strong, nonatomic) NSString *nicname;
@property (strong, nonatomic) NSString *avatar_url;
@property (assign, nonatomic) int type;
@property (assign, nonatomic) int jamDegree;
@property (strong, nonatomic) NSString *eventImageURL;
@property (assign, nonatomic) int lastOptionType;

@property (assign, nonatomic) BOOL canVote;
@property (assign, nonatomic) int agreeY;//记录赞同列表下一行的开始y
@property (assign, nonatomic) int disagreeY;//记录反对列表下一行的开始y

@property (strong, nonatomic) IBOutlet UILabel *label_title;
@property (strong, nonatomic) IBOutlet UIImageView *imageview_avatar;
@property (strong, nonatomic) IBOutlet UILabel *label_username;
@property (strong, nonatomic) IBOutlet UILabel *label_refreshTime;
@property (strong, nonatomic) IBOutlet UITextView *textview_describe;
@property (strong, nonatomic) IBOutlet UIButton *button_showBigPic;
@property (strong, nonatomic) IBOutlet UIButton *button_agree;
@property (strong, nonatomic) IBOutlet UIButton *button_disagree;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview_agree;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview_disagree;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) IBOutlet UIImageView *loadingImage;
@property (strong, nonatomic) IBOutlet UIButton *button_close;
@property (strong, nonatomic) IBOutlet UIView *view_big_image;
@property (strong, nonatomic) IBOutlet UIImageView *image_big;
- (IBAction)button_vote_clicked:(id)sender;
- (IBAction)button_close_clicked:(id)sender;
- (IBAction)button_show_big_pic:(id)sender;

@end
