//
//  TEUserEventViewController.m
//  Trafficeye_new
//
//  Created by zc on 13-9-5.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TEUserEventViewController.h"

@interface TEUserEventViewController ()

@end

@implementation TEUserEventViewController
@synthesize usedY;
@synthesize isFull;
@synthesize hasNum;
@synthesize totalNum;

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
    [self requestList];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@901109",LOG_VERSION],
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
    int event_num = [[dic objectForKey:@"event_num"]intValue];
    self.label_event_num.text = [NSString stringWithFormat:@"%i",event_num];
    
}
- (void)requestList{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setValue:[NSString stringWithFormat:@"%i",self.hasNum] forKey:@"begin"];
    [TEAppDelegate getApplicationDelegate].networkHandler.delegate_userEventDetail = self;
    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_userEventDetail:params];
    [self displayLoading];
}
- (void)refreshList{
    int i = 0;
    for(i=0;i<[self.subviewArray count];i++){
        [[self.subviewArray objectAtIndex:i] removeFromSuperview];
    }
    self.usedY = 0;
    self.isFull = NO;
    self.hasNum = 0;
    self.totalNum = 0;
    [self requestList];
}
#pragma -mark user points detail delegate
- (void)userEventDetailDidFailed:(NSString *)mes{
    [self hideLoading];
}
- (void)userEventDetailDidSuccess:(NSDictionary *)dic{
    [self hideLoading];
    NSArray* array = [dic objectForKey:@"array"];
    int count = [array count];
    if(count<1)return;
    self.totalNum = [[dic objectForKey:@"totleNum"]intValue];
    self.hasNum = self.hasNum + count;
    if(self.hasNum == self.totalNum || self.hasNum >= 100){
        self.isFull = YES;
        NSLog(@"full");
    }
    [self addDataToView:array];
}
- (void)addDataToView:(NSArray*)array{
    int i=0;
    for(i=0;i<[array count];i++){
        NSDictionary *dic = [array objectAtIndex:i];
        UILabel* label_time = [[UILabel alloc]initWithFrame:CGRectMake(155, self.usedY+20, 155, 20)];
        label_time.text = [dic objectForKey:@"createdTimes"];
        label_time.backgroundColor = [UIColor clearColor];
        label_time.textColor = [UIColor lightGrayColor];
        label_time.textAlignment = NSTextAlignmentRight;
        label_time.font = [UIFont systemFontOfSize: 13];
        UILabel* label_content = [[UILabel alloc]initWithFrame:CGRectMake(0, self.usedY, 120, 30)];
        NSString* desc = [dic objectForKey:@"desc"];
        if([TEUtil isStringNULL:desc])desc = @"";
        label_content.text = desc;
        label_content.backgroundColor = [UIColor clearColor];
        label_content.textAlignment = NSTextAlignmentLeft;
        label_content.font = [UIFont systemFontOfSize: 15];
        UILabel* label_score = [[UILabel alloc]initWithFrame:CGRectMake(120, self.usedY, 35, 30)];
        label_score.text = [NSString stringWithFormat:@"+%i分",[[dic objectForKey:@"point"] intValue]];
        label_score.backgroundColor = [UIColor clearColor];
        label_score.textAlignment = NSTextAlignmentRight;
        label_score.font = [UIFont systemFontOfSize: 15];
        [self.scrollview_content addSubview:label_time];
        [self.scrollview_content addSubview:label_content];
        [self.scrollview_content addSubview:label_score];
        [self.subviewArray addObject:label_time];
        [self.subviewArray addObject:label_content];
        [self.subviewArray addObject:label_score];
        self.usedY += 50;
        [self.scrollview_content setContentSize:CGSizeMake(310, self.usedY)];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.frame.size.height || scrollView.contentSize.height < scrollView.frame.size.height)
    {
        NSLog(@"scroll to the end");
        if(isFull){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有更多数据了" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            [self requestList];
        }
    }
}
- (void)displayLoading{
    self.loadingImage.hidden = NO;
    [self.indicator startAnimating];
    [self disableAllButton];
}
- (void)hideLoading{
    self.loadingImage.hidden = YES;
    [self.indicator stopAnimating];
    [self enableAllButton];
}
- (void)disableAllButton{
    self.button_back.enabled = NO;
}
- (void)enableAllButton{
    self.button_back.enabled = YES;
}

- (IBAction)button_back_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
