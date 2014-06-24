//
//  TERegisterViewController.m
//  Trafficeye_new
//
//  Created by 张 驰 on 13-7-31.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TERegisterViewController.h"
#import "TERewardViewController.h"
#import "TEUserInfoViewController.h"
#import "TEPersistenceHandler.h"
#import "NSString+Calculate.h"

@interface TERegisterViewController ()

@end

@implementation TERegisterViewController

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
    self.tf_email.delegate = self;
    self.tf_nickname.delegate = self;
    self.tf_password.delegate = self;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@901102",LOG_VERSION],
                           [TEUtil getUserLocationLat],
                           [TEUtil getUserLocationLon]];
    [TEUtil appendStringToPlist:logString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
# pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    switch ([textField tag]) {
        case 1:
            [self.tf_nickname becomeFirstResponder];
            break;
        case 2:
            [self.tf_password becomeFirstResponder];
            break;
        case 3:
            [textField resignFirstResponder];
            break;
            
        default:
            break;
    }
    return YES;
}
# pragma -mark 自定义
- (IBAction)backgroundTap:(id)sender{
    NSLog(@"zc");
    [self resignAllTextField];
    
}
- (void)resignAllTextField{
    [self.tf_email resignFirstResponder];
    [self.tf_nickname resignFirstResponder];
    [self.tf_password resignFirstResponder];
}

- (IBAction)register:(id)sender {
    [self resignAllTextField];
    if([self checkStatus]){
        NSString* email = self.tf_email.text;
        NSString* password = self.tf_password.text;
        NSString* nickname = self.tf_nickname.text;
        NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
        [params setValue:email forKey:@"email"];
        [params setValue:password forKey:@"passwd"];
        [params setValue:nickname forKey:@"username"];
        [TEAppDelegate getApplicationDelegate].networkHandler.delegate_register = self;
        [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_register:params];
        [self displayLoading];
        
    }
}
- (BOOL)checkStatus
{
    BOOL result = YES;
    NSString* string_alert = @"";
    
    if (self.tf_nickname.text == nil || [self.tf_nickname.text isEqualToString:@""])
    {
        result = NO;
        string_alert = @"请输入昵称";
    }
    else if (self.tf_password.text == nil || [self.tf_password.text isEqualToString:@""])
    {
        result = NO;
        string_alert = @"请输入密码";
    }
    else if (self.tf_email.text == nil || [self.tf_email.text isEqualToString:@""])
    {
        result = NO;
        string_alert = @"请输入邮箱地址";
    }
    
    //    if (![_textField_mailAddress.text isMatchedByRegex:@"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"])
    else if ([self.tf_email.text rangeOfString:@"@" options:NSCaseInsensitiveSearch].location
             == NSNotFound)
    {
        result = NO;
        string_alert = @"邮箱地址不符合规范";
    }
    else if ([self.tf_nickname.text calculateTextNumber] < 4 || [self.tf_nickname.text calculateTextNumber] > 30)
    {
        result = NO;
        string_alert = @"昵称不符合规范，应为4-30个字符，支持中英文、数字、下划线和减号";
    }
    else
    {
        NSSet* set = [NSSet setWithObjects:@"-", @"/", @":", @";", @"(", @")", @"$", @"&", @"@", @"\"", @",", @".", @"?", @"!", @"'",
                      @"[", @"]", @"{", @"}", @"#", @"%", @"^", @"*", @"+", @"=", @"_", @"~", @"<", @">", @"|", nil];
        
        for (int i = 0; i < [self.tf_password.text length]; i++)
        {
            char c = [self.tf_password.text characterAtIndex:i];
            NSString* str_char = [NSString stringWithFormat:@"%c", c];
            if (('a' <= c && 'z' >= c) || ('A' <= c && 'Z' >= c) || ('0' <= c && '9' >= c) ||
                [set containsObject:str_char])
            {
                
            }
            else
            {
                result = NO;
                //                string_alert = @"密码不符合规范";
                string_alert = @"密码不符合规范，应为6-16位字母、数字、符号组成，区分大小写。";
                break;
            }
        }
        
        if ([self.tf_password.text length] < 6 || [self.tf_password.text length] > 16)
        {
            result = NO;
            string_alert = @"密码不符合规范，应为6-16位字母、数字、符号组成，区分大小写。";
        }
    }
    
    /*
     检查字符串是否合法 tobedone
     */
    
    
    if (result == NO)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:string_alert delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    return result;
}
- (void)turnToUserInfoView{
    NSLog(@"转向个人信息页面");
    TEUserInfoViewController* userInfoVC = [[TEUserInfoViewController alloc]init];
    [self.navigationController pushViewController:userInfoVC animated:YES];
}
- (void)displayLoading{
    self.loadingImage.hidden = NO;
    [self.indicator startAnimating];
}
- (void)hideLoading{
    self.loadingImage.hidden = YES;
    [self.indicator stopAnimating];
}
#pragma mark -registerDelegate
- (void)registerDidSuccess:(NSDictionary*)rewardDic{
    [TEAppDelegate getApplicationDelegate].isLogin = 1;
    [self hideLoading];
    NSString* filePath = [TEPersistenceHandler getDocument:@"userLogin.plist"];
    NSMutableDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if(!dic){
        dic = [[NSMutableDictionary alloc]init];
    }
    [dic setObject:@"1" forKey:@"needLogin"];
    [dic setObject:self.tf_email.text forKey:@"email"];
    [dic setObject:self.tf_password.text forKey:@"passwd"];
    [dic writeToFile:filePath atomically:YES];
    if(rewardDic){
        //弹出奖励窗口后延迟1秒执行跳转页面
        [self performSelector:@selector(turnToUserInfoView) withObject:nil afterDelay:1];
        
    }else{
        //跳转到个人详细信息页面
        [self turnToUserInfoView];
    }

}
- (void)registerDidFailed:(NSString*)mes{
    NSLog(@"loginDidFailed:%@",mes);
    [TEAppDelegate getApplicationDelegate].isLogin = 0;
    UIAlertView* alert =[[UIAlertView alloc] initWithTitle:nil message:mes delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [self hideLoading];
}



- (IBAction)button_back_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
