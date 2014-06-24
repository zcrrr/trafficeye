//
//  TEUserViewController.m
//  Trafficeye_new
//
//  Created by 张 驰 on 13-6-17.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//  默认显示登录的界面，自动登录过程中显示菊花，如果登录了则显示个人信息。
//

#import "TEUserViewController.h"
#import "TERewardViewController.h"
#import "TERegisterViewController.h"
#import "TEUserInfoViewController.h"
#import "TEPersistenceHandler.h"
#import "TEForgetPasswordViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "TEChangeNameViewController.h"

@interface TEUserViewController ()

@end

@implementation TEUserViewController
@synthesize textField_email;
@synthesize textFiled_secret;
@synthesize userInfo4ChangeName;

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
    if([TEAppDelegate getApplicationDelegate].isLogin == 1){
        [self turnToUserInfoView];
    }else if([TEAppDelegate getApplicationDelegate].isLogin == 2){//正在登录
        [self displayLoading];
        //add notification
        NSString* NOTIFICATION_TURNTO_USERINFO = @"notification_turnto_userinfo";
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(turnToUserInfoView) name:NOTIFICATION_TURNTO_USERINFO object:nil];
    }
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO animated:false];
    self.textFiled_secret.delegate = self;
    self.textField_email.delegate = self;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@901101",LOG_VERSION],
                           [TEUtil getUserLocationLat],
                           [TEUtil getUserLocationLon]];
    [TEUtil appendStringToPlist:logString];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)resignAllTextField{
    [self.textFiled_secret resignFirstResponder];
    [self.textField_email resignFirstResponder];
}
- (IBAction)backgroundTap:(id)sender{
    [self resignAllTextField];
    [self resetViewFrame];
}
- (void)resetViewFrame{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
}
# pragma mark - click btn
- (IBAction)clickLogin:(id)sender {
    //先将整个view移动到合理位置（因为可能用户在键盘显示的时候就点击了登录）
    [self resetViewFrame];
    [self resignAllTextField];
    if([self checkStatus]){
        NSString* email = self.textField_email.text;
        NSString* password = self.textFiled_secret.text;
        NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
        [params setValue:email forKey:@"email"];
        [params setValue:password forKey:@"passwd"];
        [TEAppDelegate getApplicationDelegate].networkHandler.delegate_login = self;
        [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_login:params];
        [self displayLoading];
    }
}

- (IBAction)clickForetPassword:(id)sender {
    TEForgetPasswordViewController* forgetPasswdVC = [[TEForgetPasswordViewController alloc]init];
    [self.navigationController pushViewController:forgetPasswdVC animated:YES];
}

- (IBAction)clickReg:(id)sender {
    TERegisterViewController *registerVC = [[TERegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)click_sina_login:(id)sender {
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               if (result)
                               {
                                   [self loginWithSNSData:userInfo :@"sinaweibo"];
                               }
                           }];
}


- (IBAction)click_qq_login:(id)sender {
    [ShareSDK getUserInfoWithType:ShareTypeTencentWeibo
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               if (result)
                               {
                                   [self loginWithSNSData:userInfo :@"qqweibo"];
                               }
                           }];
}
- (void)loginWithSNSData:(id<ISSPlatformUser>)userInfo :(NSString*)type{
    NSLog(@"nickname :%@",[userInfo nickname]);
    NSLog(@"gender :%d",[userInfo gender]);
    NSLog(@"avatar :%@",[userInfo profileImage]);
    NSLog(@"uid :%@",[userInfo uid]);
    NSLog(@"birthday :%@",[userInfo birthday]);
    NSString* nickname = [userInfo nickname];
    NSString* gender;
    switch ([userInfo gender]) {
        case 0:
            gender = @"M";
            break;
        case 1:
            gender = @"F";
            break;
        case 2:
            gender = @"S";
            break;
        default:
            break;
    }
    NSString* avatar = [userInfo profileImage];
    NSString* uid = [userInfo uid];
    NSString* birthday = @"";//birthday暂时不用
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setObject:type forKey:@"media_type"];
    [dic setObject:uid forKey:@"unitId"];
    [dic setObject:birthday forKey:@"birthday"];
    [dic setObject:gender forKey:@"sex"];
    [dic setObject:nickname forKey:@"username"];
    [dic setObject:avatar forKey:@"headurl"];
    userInfo4ChangeName = dic;
    [TEAppDelegate getApplicationDelegate].networkHandler.delegate_snsLogin = self;
    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_snsLogin:dic];
    [self displayLoading];
}
# pragma mark - textfield delegate
- (void)keyboardWillShow:(NSNotification *)noti
{
    //键盘输入的界面调整
    //键盘的高度
    float height = 216.0;
    CGRect frame = self.view.frame;
    frame.size = CGSizeMake(frame.size.width, frame.size.height - height);
    [UIView beginAnimations:@"Curl"context:nil];//动画开始
    [UIView setAnimationDuration:0.30];
    [UIView setAnimationDelegate:self];
    [self.view setFrame:frame];
    [UIView commitAnimations];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resetViewFrame];
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint point = [textField.superview convertPoint:textField.frame.origin toView:nil];
    int offset = point.y + 80 - (self.view.frame.size.height - 216.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        self.view.frame = rect;
    }
    [UIView commitAnimations];
}
#pragma mark -loginDelegate
- (void)loginDidSuccess:rewardDic{
    NSLog(@"loginDidSuccess");
    //下载个人设置
    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_downloadUserSetting];
    [TEAppDelegate getApplicationDelegate].isLogin = 1;
    [self hideLoading];
    //保存用户登录信息
    NSString* filePath = [TEPersistenceHandler getDocument:@"userLogin.plist"];
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    if(!dic){
        dic = [[NSMutableDictionary alloc]init];
    }
    [dic setObject:@"1" forKey:@"needLogin"];
    [dic setObject:self.textField_email.text forKey:@"email"];
    [dic setObject:self.textFiled_secret.text forKey:@"passwd"];
    [dic writeToFile:filePath atomically:YES];
    if(rewardDic){
        //弹出奖励窗口后延迟1秒执行跳转页面
        [self performSelector:@selector(turnToUserInfoView) withObject:nil afterDelay:1];
        
    }else{
        //跳转到个人详细信息页面
        [self turnToUserInfoView];
    }
}
- (void)loginDidFailed:(NSString*)mes{
    NSLog(@"loginDidFailed:%@",mes);
    [TEAppDelegate getApplicationDelegate].isLogin = 0;
    UIAlertView* alert =[[UIAlertView alloc] initWithTitle:nil message:mes delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [self hideLoading];
}
#pragma mark -sns login Delegate
- (void)snsLoginDidSuccess:(NSDictionary *)dic{
    [self hideLoading];
    NSDictionary* stateDic = [dic objectForKey:@"state"];
    NSString* code = [stateDic objectForKey:@"code"];
    NSLog(@"code is %@",code);
    if([code isEqualToString:@"0"]){
        //登录成功
        //下载个人设置
        [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_downloadUserSetting];
        [TEAppDelegate getApplicationDelegate].isLogin = 1;
        NSString* filePath = [TEPersistenceHandler getDocument:@"userLogin.plist"];
        NSMutableDictionary* dic_plist = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
        if(!dic_plist){
            dic_plist = [[NSMutableDictionary alloc]init];
        }
        [dic_plist setObject:@"1" forKey:@"needLogin"];
        [dic_plist writeToFile:filePath atomically:YES];
        [TEAppDelegate getApplicationDelegate].userInfoDictionary = [dic objectForKey:@"userInfo"];
        //将徽章单独保存一下
        NSArray* arrayTemp = [[dic objectForKey:@"userInfo"] objectForKey:@"has_badges_id"];
        if(arrayTemp){
            int length = [arrayTemp count];
            for(int i = length-1;i >= 0;i--){
                NSArray* oneBadge = [arrayTemp objectAtIndex:i];
                [[TEAppDelegate getApplicationDelegate].hasBadges addObject:[oneBadge objectAtIndex:0]];
            }
        }
        NSDictionary* rewardDic = [dic objectForKey:@"reward"];
        if(rewardDic){
            TERewardViewController* rewardVC = [[TERewardViewController alloc]init];
            rewardVC.reward_dic = rewardDic;
            rewardVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            UIViewController* rootViewController =  [[UIApplication sharedApplication] keyWindow].rootViewController;
            rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
            [rootViewController presentViewController:rewardVC animated:YES completion:^(void){NSLog(@"rewardvc");}];
            //弹出奖励窗口后延迟1秒执行跳转页面
            [self performSelector:@selector(turnToUserInfoView) withObject:nil afterDelay:1];
        }else{
            //跳转到个人详细信息页面
            [self turnToUserInfoView];
        }
    }else if([code isEqualToString:@"-2"]){
        NSLog(@"名字有重复");
        TEChangeNameViewController* changeNameVC = [[TEChangeNameViewController alloc]init];
        [self.navigationController pushViewController:changeNameVC animated:YES];
        changeNameVC.userInfo = self.userInfo4ChangeName;
        
    }
}
- (void)snsLoginDidFailed:(NSString *)mes{
    [self hideLoading];
}
- (void)turnToUserInfoView{
    if([TEAppDelegate getApplicationDelegate].isLogin == 1){//成功登录之后才会跳转，登录失败只需要停止loading的动画
        TEUserInfoViewController* userInfoVC = [[TEUserInfoViewController alloc]init];
        [self.navigationController pushViewController:userInfoVC animated:YES];
    }
    [self hideLoading];
}
- (BOOL)checkStatus
{
    BOOL result = YES;
    NSString* string_alertMessage = @"";
    if (textField_email.text == nil || [textField_email.text isEqualToString:@""])
    {
        result = NO;
        string_alertMessage = @"请输入邮箱";
    }
    else if (textFiled_secret.text == nil || [textFiled_secret.text isEqualToString:@""])
    {
        result = NO;
        string_alertMessage = @"请输入密码";
    }
    else if ([textField_email.text rangeOfString:@"@" options:NSCaseInsensitiveSearch].location
             == NSNotFound)
    {
        result = NO;
        string_alertMessage = @"邮箱地址不符合规范";
    }
    else
    {
        NSSet* set = [NSSet setWithObjects:@"-", @"/", @":", @";", @"(", @")", @"$", @"&", @"@", @"\"", @",", @".", @"?", @"!", @"'",
                      @"[", @"]", @"{", @"}", @"#", @"%", @"^", @"*", @"+", @"=", @"_", @"~", @"<", @">", @"|", nil];
        
        for (int i = 0; i < [textFiled_secret.text length]; i++)
        {
            char c = [textFiled_secret.text characterAtIndex:i];
            NSString* str_char = [NSString stringWithFormat:@"%c", c];
            if (('a' <= c && 'z' >= c) || ('A' <= c && 'Z' >= c) || ('0' <= c && '9' >= c) ||
                [set containsObject:str_char])
            {
                
            }
            else
            {
                result = NO;
                //                string_alert = @"密码不符合规范";
                string_alertMessage = @"密码不符合规范，应为6-16位字母、数字、符号组成，区分大小写。";
                break;
            }
        }
        
        if ([textFiled_secret.text length] < 6 || [textFiled_secret.text length] > 16)
        {
            result = NO;
            string_alertMessage = @"密码不符合规范，应为6-16位字母、数字、符号组成，区分大小写。";
            //        string_alert = [_textField_password.text length] < 6?@"输入密码过短":@"输入密码过长";
        }
    }
    
    if (result == NO)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:string_alertMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    return result;
}
- (void)displayLoading{
    self.loadingImage.hidden = NO;
    [self.indicator startAnimating];
}
- (void)hideLoading{
    self.loadingImage.hidden = YES;
    [self.indicator stopAnimating];
}



@end
