//
//  TEUserPointsViewController.h
//  Trafficeye_new
//
//  Created by zc on 13-9-5.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TESecondLevelViewController.h"
#import "TENetworkHandler.h"

@interface TEUserPointsViewController : TESecondLevelViewController<UserPointsDetailDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageview_avatar;
@property (strong, nonatomic) IBOutlet UILabel *label_username;
@property (strong, nonatomic) IBOutlet UILabel *label_points;
@property (strong, nonatomic) IBOutlet UILabel *label_pointsProgress;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview_content;
@property (strong, nonatomic) IBOutlet UIImageView *loadingImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) IBOutlet UIProgressView *progressbar_empirical;
@property (strong, nonatomic) IBOutlet UIButton *button_back;

@property (nonatomic) int usedY;
@property (nonatomic) BOOL isFull;
@property (nonatomic) int hasNum;
@property (nonatomic) int totalNum;
@property (strong, nonatomic) NSMutableArray *subviewArray;
- (IBAction)button_back_clicked:(id)sender;
@end
