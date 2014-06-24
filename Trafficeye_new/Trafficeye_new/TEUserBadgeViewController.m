//
//  TEUserBadgeViewController.m
//  Trafficeye_new
//
//  Created by zc on 13-9-5.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TEUserBadgeViewController.h"
#import "TEBadge.h"
#import "TEUserOneBadgeViewController.h"

@interface TEUserBadgeViewController ()

@end

@implementation TEUserBadgeViewController

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
                           [NSString stringWithFormat:@"I%@901108",LOG_VERSION],
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
    NSArray* badgeArray = [TEAppDelegate getApplicationDelegate].hasBadges;
    int count = [badgeArray count];
    self.label_badge_num.text = [NSString stringWithFormat:@"%i/%i",count,BADGE_TOTAL_NUM];
    
    int row;
    if(BADGE_TOTAL_NUM%4 == 0){
        row = BADGE_TOTAL_NUM/4;
    }else{
        row = BADGE_TOTAL_NUM/4+1;
    }
    self.scrollview_content.contentSize = CGSizeMake(310, row * 80);
    
    int i = 1;
    for (i = 1;i<=BADGE_TOTAL_NUM;i++){
        int rowOfThis = 0;
        int colOfThis = 0;
        if(i%4 == 0){
            rowOfThis = i/4-1;
        }else{
            rowOfThis = i/4;
        }
        if(i%4 == 0){
            colOfThis = 3;
        }else{
            colOfThis = i%4-1;
        }
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(80*colOfThis,  80*rowOfThis, 70, 70)];
        if(i<=[badgeArray count]){//先放置得到的徽章
            int num = [[badgeArray objectAtIndex:i-1]intValue];
            TEBadge* bd = [[TEAppDelegate getApplicationDelegate].badges objectForKey:[NSString stringWithFormat:@"%i",num]];
            [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@",bd.image_name] ofType:@"png"]] forState:UIControlStateNormal];
            
            button.tag = num;
            [button addTarget:self action:@selector(badgeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else{//还没得到的徽章
            [button setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"badge_unknown" ofType:@"png"]] forState:UIControlStateNormal];
        }
        [self.scrollview_content addSubview:button];
    }
}
- (void)badgeButtonClicked:sender
{
    //    NSLog(@"badge clicked");
    int tag = [(UIButton*)sender tag];
    TEBadge* bd = [[TEAppDelegate getApplicationDelegate].badges objectForKey:[NSString stringWithFormat:@"%i",tag]];
    TEUserOneBadgeViewController* bdShowVC = [[TEUserOneBadgeViewController alloc]init];
    bdShowVC.badge = bd;
    [self.navigationController pushViewController:bdShowVC animated:YES];
}

- (IBAction)button_back_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
