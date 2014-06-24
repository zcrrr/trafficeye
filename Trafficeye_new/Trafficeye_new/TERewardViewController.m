//
//  TERewardViewController.m
//  Trafficeye_new
//
//  Created by 张 驰 on 13-7-30.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TERewardViewController.h"
#import "QuartzCore/CAlayer.h"
#import "TEBadge.h"
#import <ShareSDK/ShareSDK.h>
#import "UIImage+Rescale.h"
#import "PlaySound.h"

@interface TERewardViewController ()

@end

@implementation TERewardViewController
{
    int y_used;
}
@synthesize reward_dic;
@synthesize content_view;
@synthesize timer_hide;

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
    [PlaySound play];
    // Do any additional setup after loading the view from its nib.
//    UIImage *image = [UIImage imageNamed:@"trafficeyebg.png"];
//    self.view.layer.contents = (id) image.CGImage;
//    // 如果需要背景透明加上下面这句
//    self.view.layer.backgroundColor = [UIColor clearColor].CGColor;
    y_used = 40;
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [self displayContent];
    self.timer_hide = [NSTimer timerWithTimeInterval:8 target:self selector:@selector(hideSelf) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop]addTimer:self.timer_hide forMode:NSDefaultRunLoopMode];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
//    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
//                           [TEUtil getNowTime],
//                           [NSString stringWithFormat:@"添加页面编号"],
//                           [TEUtil getUserLocationLat],
//                           [TEUtil getUserLocationLon]];
//    [TEUtil appendStringToPlist:logString];
}
- (void)hideSelf{
    [self dismissViewControllerAnimated:YES completion:^(void){NSLog(@"close");}];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)close{
    [self dismissViewControllerAnimated:YES completion:^(void){NSLog(@"close");}];

}
- (void)displayContent{
    id id_arrayBadge = [self.reward_dic valueForKey:@"badge"];
    if (nil != id_arrayBadge && [NSNull null] != id_arrayBadge && [id_arrayBadge isKindOfClass:[NSArray class]])
    {
        //添加徽章小图标
        UIImageView* badge_icon = [[UIImageView alloc]initWithFrame:CGRectMake(5,y_used+5, 45, 45)];
        badge_icon.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"icon_personal_badge" ofType:@"png"]];
        [self.content_view addSubview:badge_icon];
        
        NSArray* arr_badge = id_arrayBadge;
        int badge_count = [arr_badge count];
        UIView *view_badge = [[UIView alloc]initWithFrame:CGRectMake(50, y_used+5, 245, 65*badge_count+5)];
        y_used += 5+65*badge_count+5;//记录
        [view_badge setBackgroundColor:[UIColor whiteColor]];
        [content_view addSubview:view_badge];
        for (int i = 0; i < badge_count; i++)
        {
            //取每一个徽章
            id id_oneBadge = [arr_badge objectAtIndex:i];
            if (nil != id_oneBadge && [id_oneBadge isKindOfClass:[NSDictionary class]])
            {
                NSDictionary* dic_oneBadge = id_oneBadge;
                NSString* badgeID = [NSString stringWithFormat:@"%@",[dic_oneBadge objectForKey:@"id"]];
                
                TEBadge* oneBadge = [[TEAppDelegate getApplicationDelegate].badges objectForKey:badgeID];
                //如果该版本有这一个徽章
                if (nil != oneBadge)
                {
                    UIImageView* imageView_badge = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5+65*i, 60,60 )];
                    //                        imageView_badge.image = [UIImage imageNamed:oneBadge.string_fileName];
                    imageView_badge.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@",oneBadge.image_name] ofType:@"png"]];
                    [view_badge addSubview:imageView_badge];
                    
                    UILabel* label_badgeName = [[UILabel alloc]initWithFrame:CGRectMake(80, 15+(65*i), 155, 20)];
                    label_badgeName.text = oneBadge.name;
                    label_badgeName.backgroundColor = [UIColor clearColor];
                    label_badgeName.textAlignment = NSTextAlignmentLeft;
                    label_badgeName.font = [UIFont systemFontOfSize: 18];
                    //                        label_badgeName.adjustsFontSizeToFitWidth = YES;
                    [view_badge addSubview:label_badgeName];
                    
                    UILabel* label_badgeDescription = [[UILabel alloc]initWithFrame:CGRectMake(80, 40+(65*i), 155, 15)];
                    label_badgeDescription.text = oneBadge.condition;
                    label_badgeDescription.backgroundColor = [UIColor clearColor];
                    label_badgeDescription.textAlignment = NSTextAlignmentLeft;
                    label_badgeDescription.font = [UIFont systemFontOfSize: 15];
                    //                        label_badgeDescription.adjustsFontSizeToFitWidth = YES;
                    [view_badge addSubview:label_badgeDescription];
                }
            }
        }
    }
    //显示等级的view
    id id_level = [self.reward_dic valueForKey:@"level"];
    if (nil != id_level && [NSNull null] != id_level)
    {
        int level = [[self.reward_dic valueForKey:@"level"]intValue];
        //添加level小图标
        UIImageView* level_icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, y_used+5, 45, 45)];
        level_icon.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"icon_personal_rank" ofType:@"png"]];
        [content_view addSubview:level_icon];
        
        UIView *view_rank = [[UIView alloc]initWithFrame:CGRectMake(50, y_used+5, 245, 45)];
        y_used += 5+45;//记录
        [view_rank setBackgroundColor:[UIColor whiteColor]];
        [content_view addSubview:view_rank];
        
        UILabel* label_level = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 235, 35)];
        label_level.textAlignment = NSTextAlignmentLeft;
        label_level.backgroundColor = [UIColor clearColor];
        label_level.font = [UIFont systemFontOfSize:20];
        label_level.text = [NSString stringWithFormat:@"恭喜您晋至 %d 级", level];
        [view_rank addSubview:label_level];
    }
    //显示积分view
    //总积分
    int point_total = 0;
    //处理积分
    id arr_point = [self.reward_dic valueForKey:@"points"];
    int credit_count = [arr_point count];
    UIImageView* credit_icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, y_used+5, 45, 45)];
    credit_icon.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"icon_personal_credit" ofType:@"png"]];
    [content_view addSubview:credit_icon];
    
    UIView *view_credit = [[UIView alloc]initWithFrame:CGRectMake(50, y_used+5, 245, 5+35+credit_count*20+5)];
    y_used += 5+5+35+credit_count*20+5;//记录
    [view_credit setBackgroundColor:[UIColor whiteColor]];
    [content_view addSubview:view_credit];
    
    
    if ([arr_point isKindOfClass:[NSArray class]])
    {
        //该次总得分行
        UILabel* label_score = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 180, 35)];
        label_score.textAlignment = NSTextAlignmentLeft;
        label_score.font = [UIFont systemFontOfSize:14];
        label_score.backgroundColor = [UIColor clearColor];
        [view_credit addSubview:label_score];
        label_score.text = @"获得奖励积分";
        
        UILabel* label_score2 = [[UILabel alloc]initWithFrame:CGRectMake(185, 5, 50, 35)];
        label_score2.textAlignment = NSTextAlignmentRight;
        label_score2.font = [UIFont systemFontOfSize:14];
        label_score2.backgroundColor = [UIColor clearColor];
        [view_credit addSubview:label_score2];
        
        for (int i = 0; i < credit_count; i++)
        {
            NSDictionary* dic_oneLine = [arr_point objectAtIndex:i];
            int point = [[dic_oneLine valueForKey:@"point"]intValue];
            point_total += point;
            NSString* str_description = [dic_oneLine valueForKey:@"title"];
            
            UILabel* label_oneLine = [[UILabel alloc]initWithFrame:CGRectMake(5, 40+i*20, 200, 20)];
            label_oneLine.textAlignment = NSTextAlignmentLeft;
            label_oneLine.text = [NSString stringWithFormat:@"%@", str_description];
            label_oneLine.font = [UIFont systemFontOfSize:14];
            label_oneLine.backgroundColor = [UIColor clearColor];
            [view_credit addSubview:label_oneLine];
            
            UILabel* label_onePoint = [[UILabel alloc]initWithFrame:CGRectMake(205,40+i*20, 30, 20)];
            label_onePoint.textAlignment = NSTextAlignmentRight;
            label_onePoint.text = [NSString stringWithFormat:@"+%d",point];
            label_onePoint.font = [UIFont systemFontOfSize:14];
            label_onePoint.backgroundColor = [UIColor clearColor];
            [view_credit addSubview:label_onePoint];
        }
        label_score2.text = [NSString stringWithFormat:@"%i", point_total];
    }
    UIButton* button_close = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_close setBackgroundImage:[UIImage imageNamed:@"button_white_up.png"] forState:UIControlStateNormal];
    [button_close setBackgroundImage:[UIImage imageNamed:@"button_white_dn.png"] forState:UIControlStateSelected];
    [button_close setTitle:@"关 闭" forState:UIControlStateNormal];
    [button_close setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button_close.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    [button_close setFrame:CGRectMake(5, y_used+5 , 140, 40)];
    [content_view addSubview:button_close];
    [button_close addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* button_share = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_share setBackgroundImage:[UIImage imageNamed:@"button_green_up.png"] forState:UIControlStateNormal];
    [button_share setBackgroundImage:[UIImage imageNamed:@"button_green_dn.png"] forState:UIControlStateSelected];
    [button_share setTitle:@"分 享" forState:UIControlStateNormal];
    [button_share setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button_share.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    [button_share setFrame:CGRectMake(155, y_used+5 , 140, 40)];
    y_used += 5+40;
    [content_view addSubview:button_share];
    [button_share addTarget:self action:@selector(displayShareView) forControlEvents:UIControlEventTouchUpInside];
    CGRect temp = content_view.frame;
    float height = y_used+5;
    //如果奖励太多超出了全屏
    if(height > [TEAppDelegate getApplicationDelegate].screenHeight-IOS7OFFSIZE){
        temp.size.height = [TEAppDelegate getApplicationDelegate].screenHeight-IOS7OFFSIZE-40;
        temp.size.width = 300;
        temp.origin.y = IOS7OFFSIZE+20;
        content_view.contentSize = CGSizeMake(300, height);
    }else{
        temp.size.height = height;
        temp.size.width = 300;
        temp.origin.y = IOS7OFFSIZE+([TEAppDelegate getApplicationDelegate].screenHeight - IOS7OFFSIZE-temp.size.height)/2;
    }
    content_view.frame = temp;
    
}
- (void)displayShareView{
    [self.timer_hide invalidate];
    NSString* share_content = @"我获得了#路况交通眼#的奖励。@路况交通眼——城市路况、城际路况、交通微博、交互路况。下载：http://mobile.trafficeye.com.cn";
    id<ISSContent> publishContent = [ShareSDK content:share_content
                                       defaultContent:@"路况交通眼"
                                                image:[ShareSDK pngImageWithImage:[self getWeiboImage]]
                                                title:@"路况交通眼"
                                                  url:@"http://mobile.trafficeye.com.cn"
                                          description:@"路况交通眼"
                                            mediaType:SSPublishContentMediaTypeImage];
    NSArray *shareList = [ShareSDK getShareListWithType:
                          ShareTypeSinaWeibo,
                          ShareTypeTencentWeibo,
                          ShareTypeWeixiSession,
                          ShareTypeWeixiTimeline,
                          ShareTypeQQSpace,
                          nil];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                    NSString* shareTypeString = @"sinaweibo";
                                    switch (type) {
                                        case ShareTypeSinaWeibo:
                                            shareTypeString = @"sinaweibo";
                                            break;
                                        case ShareTypeTencentWeibo:
                                            shareTypeString = @"qqweibo";
                                            break;
                                        case ShareTypeWeixiSession:
                                            shareTypeString = @"weChat";
                                            break;
                                        case ShareTypeWeixiTimeline:
                                            shareTypeString = @"weChatFriends";
                                            break;
                                        case ShareTypeQQSpace:
                                            shareTypeString = @"qzone";
                                            break;
                                        default:
                                            break;
                                    }
//                                    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_snsShare:shareTypeString];
                                    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_newShareSNS:shareTypeString :share_content :[self getWeiboImage]];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                                [self hideSelf];
                            }];
}
- (UIImage *)getWeiboImage{
    UIGraphicsBeginImageContext(CGSizeMake(320,self.view.frame.size.height));
    [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image_temp = UIGraphicsGetImageFromCurrentImageContext();
    UIImage* image_small = [image_temp rescaleImageToSize:CGSizeMake(240, self.view.frame.size.height/4*3)];
    NSData* imageData = UIImagePNGRepresentation(image_small);
    UIImage* image_compressed = [UIImage imageWithData:imageData];
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"test.png"]];   // 保存文件的名称
    //    BOOL result = [UIImagePNGRepresentation(image_compressed)writeToFile: filePath atomically:YES];
    //    NSLog(@"result is %i",result);
    return image_compressed;
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
