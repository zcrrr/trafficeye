//
//  TEEventInfoViewController.m
//  Trafficeye_new
//
//  Created by zc on 13-10-18.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TEEventInfoViewController.h"
#import "ASIHTTPRequest.h"
#import "TERewardViewController.h"

@interface TEEventInfoViewController ()

@end

@implementation TEEventInfoViewController
@synthesize eventid;
@synthesize event_uid;
@synthesize nicname;
@synthesize avatar_url;
@synthesize type;
@synthesize jamDegree;
@synthesize canVote;
@synthesize agreeY;
@synthesize disagreeY;
@synthesize eventImageURL;
@synthesize lastOptionType;


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
    self.canVote = YES;//默认可以投票
    self.agreeY  = 5;
    self.disagreeY = 5;
    NSString* str = @"";
    [self.view addSubview:self.view_big_image];
    UITapGestureRecognizer* tapRecognizer_switch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideView)];
    [self.view_big_image addGestureRecognizer:tapRecognizer_switch];
    self.view_big_image.hidden = YES;
    switch (self.type) {
        case 1:
            str = @"道路拥堵";
            break;
        case 2:
            str = @"交通事故";
            break;
        case 3:
            str = @"道路施工";
            break;
        case 4:
            str = @"交通管制";
            break;
        case 5:
        {
            if(jamDegree == 1){
                str = @"街景随拍";
            }else if(jamDegree == 2){
                str = @"吼一嗓子";
            }
            else if(jamDegree == 3){
                str = @"无良驾驶";
            }
            break;
        }
        default:
            break;
    }
    self.label_title.text = str;
    self.label_username.text = self.nicname;
    if(self.avatar_url){
        NSString* imageURL = [NSString stringWithFormat:@"%@%@",ENDPOINTS,self.avatar_url];
        NSLog(@"avatar is %@",imageURL);
        NSURL *url = [NSURL URLWithString:imageURL];
        ASIHTTPRequest *Imagerequest = [ASIHTTPRequest requestWithURL:url];
        Imagerequest.tag = 1;
        Imagerequest.timeOutSeconds = 15;
        [Imagerequest setDelegate:self];
        [Imagerequest startAsynchronous];
        [self displayLoading];
    }else{
        [self requestEventInfo];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@101102",LOG_VERSION],
                           [TEUtil getUserLocationLat],
                           [TEUtil getUserLocationLon]];
    [TEUtil appendStringToPlist:logString];
}
#pragma -mark ASIHttpRequest delegate
- (void)requestFinished:(ASIHTTPRequest *)request{
    [self hideLoading];
    UIImage *image = [[UIImage alloc] initWithData:[request responseData]];
    if(request.tag == 1){
        self.imageview_avatar.image = image;
        [self requestEventInfo];
    }else if(request.tag == 2){
        [self.button_showBigPic setBackgroundImage:image forState:UIControlStateNormal];
    }else if(request.tag == 3){
        self.view_big_image.hidden = NO;
        self.image_big.image = image;
    }
    
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    [self hideLoading];
    NSLog(@"下载头像失败");
    if(request.tag == 1){
        [self requestEventInfo];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button_vote_clicked:(id)sender {
    if([TEAppDelegate getApplicationDelegate].isLogin == 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"亲，你还没有登录哦~~" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }else{
        if(self.canVote){
            NSString* uid = [[TEAppDelegate getApplicationDelegate] getUid];
            NSLog(@"uid is %@",uid);
            NSLog(@"eventuid is %@",self.event_uid);
            if([uid isEqualToString:self.event_uid]){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不能给自己投票" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                [self vote:[(UIButton*)sender tag]];
                self.canVote = NO;
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您已经投过票了" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}
- (void)vote:(int)optionType{
    lastOptionType = optionType;
    NSLog(@"投票");
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[NSString stringWithFormat: @"%d", self.eventid] forKey:@"objectId"];
    [params setObject:self.event_uid forKey:@"uid"];
    [params setObject:@"event" forKey:@"objectType"];
    [params setObject:[NSString stringWithFormat:@"%i",optionType] forKey:@"optionType"];
    [TEAppDelegate getApplicationDelegate].networkHandler.delegate_option = self;
    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_Option:params];
    [self displayLoading];
}

- (IBAction)button_close_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)button_show_big_pic:(id)sender {
    if(self.eventImageURL && ![self.eventImageURL isEqualToString:@""]){
        NSString *fileURL = [NSString stringWithFormat:@"%@%@",@"http://mobile.trafficeye.com.cn/",self.eventImageURL];
        NSLog(@"Image_url is %@",fileURL);
        NSURL *url = [NSURL URLWithString:fileURL];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        request.timeOutSeconds = 15;
        request.tag = 3;
        [request setDelegate : self];
        [request startAsynchronous];
        [self displayLoading];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户没有上传照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)hideView{
    self.view_big_image.hidden = YES;
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
    self.button_close.enabled = NO;
    self.button_agree.enabled = NO;
    self.button_disagree.enabled = NO;
    self.button_showBigPic.enabled = NO;
}
- (void)enableAllButton{
    self.button_close.enabled = YES;
    self.button_agree.enabled = YES;
    self.button_disagree.enabled = YES;
    self.button_showBigPic.enabled = YES;
}
- (void)requestEventInfo{
    [TEAppDelegate getApplicationDelegate].networkHandler.delegate_eventDetail = self;
    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_eventDetail:self.eventid :@"event"];
    [self displayLoading];
}
#pragma -mark event detail delegate
- (void)eventDetailDidFailed:(NSString *)mes{
    UIAlertView* alert =[[UIAlertView alloc] initWithTitle:nil message:mes delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [self hideLoading];
}
- (void)eventDetailDidSuccess:(NSDictionary *)dic{
    NSLog(@"event info is %@",dic);
    [self hideLoading];
    int supportCount = [[dic valueForKey:@"supportCount"] integerValue];
    [self.button_agree setTitle:[NSString stringWithFormat:@"赞同  %i",supportCount] forState:UIControlStateNormal];
    int oposeCount = [[dic valueForKey:@"oposeCount"] integerValue];
    [self.button_disagree setTitle:[NSString stringWithFormat:@"反对  %i",oposeCount] forState:UIControlStateNormal];
    NSString *isOption = [dic valueForKey:@"isOption"];
    if([isOption isEqualToString:@"-1"]){
        self.canVote = YES;
    }else{
        self.canVote = NO;
    }
    NSString *minute = [dic valueForKey:@"minis"];
    NSLog(@"minute is %@",minute);
    self.label_refreshTime.text = [NSString stringWithFormat:@"%@前更新",minute];
    NSString *contentStr = [dic valueForKey:@"contents"];
    NSLog(@"content is %@",contentStr);
    self.textview_describe.text = contentStr;
    NSArray *voteArray = [dic objectForKey:@"user"];
    for(int i = 0;i<[voteArray count];i++){
        NSDictionary *item = [voteArray objectAtIndex:i];
        NSLog(@"id is %@",[item valueForKey:@"id"]);
        NSLog(@"username is %@",[item valueForKey:@"username"]);
        NSLog(@"minis is %@",[item valueForKey:@"minis"]);
        [self addOneRow:[item valueForKey:@"optionType"] withName:[item valueForKey:@"username"] andMinute:[item valueForKey:@"minis"]];
    }
    NSString *smallImage_url = [dic valueForKey:@"smallImage"];
    if (![smallImage_url isEqualToString:@""]) {
        NSString *fileURL = [NSString stringWithFormat:@"%@%@",@"http://mobile.trafficeye.com.cn/",smallImage_url];
        NSLog(@"smallImage_url is %@",fileURL);
        NSURL *url = [NSURL URLWithString:fileURL];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        request.tag = 2;
        request.timeOutSeconds = 15;
        [request setDelegate : self];
        [request startAsynchronous];
        [self displayLoading];
    }
    self.eventImageURL = [dic valueForKey:@"imageUrl"];
}
- (void)addOneRow:(NSString*)optionType withName:(NSString*)username andMinute:(NSString*)minute{
    if([@"1" isEqualToString:optionType]){//支持
        UILabel* label_username = [[UILabel alloc]initWithFrame:CGRectMake(0, self.agreeY, 90, 20)];
        label_username.text = username;
        label_username.backgroundColor = [UIColor clearColor];
        label_username.textAlignment = NSTextAlignmentLeft;
        label_username.font = [UIFont systemFontOfSize: 12];
        UILabel* label_minute = [[UILabel alloc]initWithFrame:CGRectMake(90, self.agreeY, 50, 20)];
        label_minute.text = [NSString stringWithFormat:@"%@前",minute];
        label_minute.backgroundColor = [UIColor clearColor];
        label_minute.textAlignment = NSTextAlignmentRight;
        label_minute.font = [UIFont systemFontOfSize: 12];
        [self.scrollview_agree addSubview:label_username];
        [self.scrollview_agree addSubview:label_minute];
        self.agreeY += 20;
        [self.scrollview_agree setContentSize:CGSizeMake(140, self.agreeY)];
    }else if([@"2" isEqualToString:optionType]){//反对
        UILabel* label_username = [[UILabel alloc]initWithFrame:CGRectMake(0, self.disagreeY, 90, 20)];
        label_username.text = username;
        label_username.backgroundColor = [UIColor clearColor];
        label_username.textAlignment = NSTextAlignmentLeft;
        label_username.font = [UIFont systemFontOfSize: 12];
        UILabel* label_minute = [[UILabel alloc]initWithFrame:CGRectMake(90, self.disagreeY, 50, 20)];
        label_minute.text = [NSString stringWithFormat:@"%@前",minute];
        label_minute.backgroundColor = [UIColor clearColor];
        label_minute.textAlignment = NSTextAlignmentRight;
        label_minute.font = [UIFont systemFontOfSize: 12];
        [self.scrollview_disagree addSubview:label_username];
        [self.scrollview_disagree addSubview:label_minute];
        self.disagreeY += 20;
        [self.scrollview_disagree setContentSize:CGSizeMake(140, self.disagreeY)];
    }
}
#pragma -mark option delegate
- (void)optionDidFailed:(NSString *)mes{
    UIAlertView* alert =[[UIAlertView alloc] initWithTitle:nil message:mes delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [self hideLoading];
}
- (void)optionDidSuccess:(NSDictionary *)dic{
    [self hideLoading];
    if(dic){
        TERewardViewController* rewardVC = [[TERewardViewController alloc]init];
        rewardVC.reward_dic = dic;
        rewardVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        UIViewController* rootViewController =  [[UIApplication sharedApplication] keyWindow].rootViewController;
        rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [rootViewController presentViewController:rewardVC animated:YES completion:^(void){NSLog(@"rewardvc");}];
    }
    NSDictionary* dic_temp = [TEAppDelegate getApplicationDelegate].userInfoDictionary;
    [self addOneRow:[NSString stringWithFormat:@"%i",lastOptionType] withName:[dic_temp objectForKey:@"username"] andMinute:@"0秒"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}


@end
