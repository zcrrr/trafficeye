//
//  TEReportEventViewController.h
//  Trafficeye_new
//
//  Created by zc on 13-10-15.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TENetworkHandler.h"

@interface TEReportEventViewController : UIViewController<UITextViewDelegate,ReportEventDelegate>

@property (assign,nonatomic) int eventType;
@property (strong, nonatomic) UIImage* eventImage;
@property (assign, nonatomic) float lat;
@property (assign, nonatomic) float lon;

@property (retain, nonatomic) IBOutlet UITextView *textview_content;
@property (retain, nonatomic) IBOutlet UILabel *label_letter_num;
@property (retain, nonatomic) IBOutlet UIImageView *imageview_test;
@property (strong, nonatomic) IBOutlet UIImageView *loadingImage;
@property (strong, nonatomic) IBOutlet UIButton *button_close;
@property (strong, nonatomic) IBOutlet UIButton *button_submit;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
- (IBAction)closeClicked:(id)sender;
- (IBAction)publishClicked:(id)sender;

@end
