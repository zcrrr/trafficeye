//
//  TEUserOneBadgeViewController.m
//  Trafficeye_new
//
//  Created by zc on 13-9-17.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TEUserOneBadgeViewController.h"
#import "QuartzCore/QuartzCore.h"

@interface TEUserOneBadgeViewController ()

@end

@implementation TEUserOneBadgeViewController
@synthesize badge;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.badge)
    {
        self.imageview_badge.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@",self.badge.image_name] ofType:@"png"]];
        self.label_badge_name.text = self.badge.name;
        self.label_condition.text = self.badge.condition;
    }
//    //设置背景图
//    UIImage *image = [UIImage imageNamed:@"trafficeyebg.png"];
//    self.view.layer.contents = (id) image.CGImage;
//    // 如果需要背景透明加上下面这句
//    self.view.layer.backgroundColor = [UIColor clearColor].CGColor;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@901111",LOG_VERSION],
                           [TEUtil getUserLocationLat],
                           [TEUtil getUserLocationLon]];
    [TEUtil appendStringToPlist:logString];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button_back_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
