//
//  TEEditPasswordViewController.m
//  Trafficeye_new
//
//  Created by zc on 13-9-10.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TEEditPasswordViewController.h"

@interface TEEditPasswordViewController ()

@end

@implementation TEEditPasswordViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@901112",LOG_VERSION],
                           [TEUtil getUserLocationLat],
                           [TEUtil getUserLocationLon]];
    [TEUtil appendStringToPlist:logString];
}

- (IBAction)save_new_pwd:(id)sender {
    if([self checkStatus]){
        NSString* oldpassword = self.textfield_oldpwd.text;
        NSString* newpassword = self.textfield_newpwd.text;
        NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
        [params setValue:oldpassword forKey:@"oldpasswd"];
        [params setValue:newpassword forKey:@"newpasswd"];
        [TEAppDelegate getApplicationDelegate].networkHandler.delegate_userEditPassword = self;
        [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_userEditPassword:params];
        [self displayLoading];
    }
}
- (bool)checkStatus
{
    bool flag_result = true;
    NSString* str_message = nil;
    if (self.textfield_oldpwd.text == nil || [self.textfield_oldpwd.text isEqualToString:@""])
    {
        str_message = @"请输入旧密码";
        flag_result = false;
    }
    else if (self.textfield_newpwd.text == nil || [self.textfield_newpwd.text isEqualToString:@""])
    {
        str_message = @"请输入 新密码";
        flag_result = false;
    }
    else if ([self.textfield_newpwd.text length] < 6 || [self.textfield_newpwd.text length] > 16)
    {
        flag_result = false;
        str_message = @"密码不符合规范，应为6-16位字母、数字、符号组成，区分大小写。";
    }
    NSSet* set = [NSSet setWithObjects:@"-", @"/", @":", @";", @"(", @")", @"$", @"&", @"@", @"\"", @",", @".", @"?", @"!", @"'",
                  @"[", @"]", @"{", @"}", @"#", @"%", @"^", @"*", @"+", @"=", @"_", @"~", @"<", @">", @"|", nil];
    
    for (int i = 0; i < [self.textfield_oldpwd.text length]; i++)
    {
        char c = [self.textfield_oldpwd.text characterAtIndex:i];
        NSString* str_char = [NSString stringWithFormat:@"%c", c];
        if (('a' <= c && 'z' >= c) || ('A' <= c && 'Z' >= c) || ('0' <= c && '9' >= c) ||
            [set containsObject:str_char])
        {
            
        }
        else
        {
            flag_result = false;
            //                string_alert = @"密码不符合规范";
            str_message = @"密码不符合规范，应为6-16位字母、数字、符号组成，区分大小写。";
            break;
        }
    }
    
    for (int i = 0; i < [self.textfield_newpwd.text length]; i++)
    {
        char c = [self.textfield_newpwd.text characterAtIndex:i];
        NSString* str_char = [NSString stringWithFormat:@"%c", c];
        if (('a' <= c && 'z' >= c) || ('A' <= c && 'Z' >= c) || ('0' <= c && '9' >= c) ||
            [set containsObject:str_char])
        {
            
        }
        else
        {
            flag_result = false;
            //                string_alert = @"密码不符合规范";
            str_message = @"密码不符合规范，应为6-16位字母、数字、符号组成，区分大小写。";
            break;
        }
    }
    
    if (str_message != nil)
    {
        //tobedone alertview
        flag_result = false;
#ifdef MYDEBUG
        NSLog(@"%@", str_message);
#endif
        
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:str_message delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alertView show];
    }
    return flag_result;
}
#pragma -mark user edit password delegate
- (void)userEditPasswordDidFailed:(NSString *)mes{
    UIAlertView* alert =[[UIAlertView alloc] initWithTitle:nil message:mes delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [self hideLoading];
}
- (void)userEditPasswordDidSuccess:(NSDictionary *)dic{
    UIAlertView* alert =[[UIAlertView alloc] initWithTitle:nil message:@"修改成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [self hideLoading];
    [self.navigationController popViewControllerAnimated:YES];
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
