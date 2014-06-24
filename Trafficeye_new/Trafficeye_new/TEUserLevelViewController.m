//
//  TEUserLevelViewController.m
//  Trafficeye_new
//
//  Created by zc on 13-9-5.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TEUserLevelViewController.h"
#import "TEUserLevelHandler.h"

@interface TEUserLevelViewController ()

@end

@implementation TEUserLevelViewController

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
    [self initUI];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@901105",LOG_VERSION],
                           [TEUtil getUserLocationLat],
                           [TEUtil getUserLocationLon]];
    [TEUtil appendStringToPlist:logString];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initUI{
    NSDictionary* dic = [TEAppDelegate getApplicationDelegate].userInfoDictionary;
    if([dic objectForKey:@"imageData"]){
        self.imageview_avatar.image = [[UIImage alloc] initWithData:[dic objectForKey:@"imageData"]];
    }
    self.label_username.text = [dic objectForKey:@"username"];
    int points = [[dic objectForKey:@"points"] intValue];
    int level = [TEUserLevelHandler generateLevelWithPoint:points];
    self.label_level.text = [NSString stringWithFormat:@"%d等级",level];
    self.label_empirical.text = [NSString stringWithFormat:@"%d/%d",points, [TEUserLevelHandler getNextLevelPoint:level]];
    int minValue = [TEUserLevelHandler getLevelPointWithLevel:level];
    int maxValue = [TEUserLevelHandler getLevelPointWithLevel:level+1];
    self.progressbar_empirical.progress = (float)(points-minValue)/(maxValue-minValue);
}

- (IBAction)button_back_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
