//
//  TEUserInfoEditViewController.m
//  Trafficeye_new
//
//  Created by zc on 13-9-5.
//  Copyright (c) 2013年 张 驰. All rights reserved.
//

#import "TEUserInfoEditViewController.h"
#import "NSString+Calculate.h"
#import "UIImage+Rescale.h"
#import "TERewardViewController.h"
#import "TEEditPasswordViewController.h"

@interface TEUserInfoEditViewController ()

@end

@implementation TEUserInfoEditViewController
@synthesize sexPickerData;
@synthesize isEdit;
@synthesize myRewardDic;

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
    self.textfield_nickname.delegate = self;
    self.textfield_realname.delegate = self;
    self.textfield_phonenumber.delegate = self;
    self.textfield_sex.delegate = self;
    self.textfield_birthday.delegate = self;
    
    NSArray* array = [[NSArray alloc]initWithObjects:@"男",@"女",@"保密",nil];
    self.sexPickerData = array;
    self.textfield_sex.inputView = self.sexPicker;
    self.textfield_sex.inputAccessoryView = self.sexAccessoryView;
    self.textfield_birthday.inputView = self.datePicker;
    self.textfield_birthday.inputAccessoryView = self.accessoryView;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@901110",LOG_VERSION],
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
    if([TEAppDelegate getApplicationDelegate].userInfoDictionary){
        NSDictionary* dic = [TEAppDelegate getApplicationDelegate].userInfoDictionary;
        self.label_username.text = [dic objectForKey:@"username"];
        if([TEAppDelegate getApplicationDelegate].imageData){
            self.imageview_avatar.image = [[UIImage alloc] initWithData:[TEAppDelegate getApplicationDelegate].imageData];
        }
        self.textfield_nickname.text = [dic objectForKey:@"username"];
        NSString *realname = [dic objectForKey:@"real_name"];
        if(![TEUtil isStringNULL:realname]){
            self.textfield_realname.text = realname;
        }
        NSString *phoneNumber = [dic objectForKey:@"mobile_num"];
        if(![TEUtil isStringNULL:phoneNumber]){
            self.textfield_phonenumber.text = phoneNumber;
        }
        NSString *gender = [dic objectForKey:@"gender"];
        if(![TEUtil isStringNULL:gender]){
            if([gender isEqualToString:@"M"]){
                gender = @"男";
            }else if([gender isEqualToString:@"F"]){
                gender = @"女";
            }else if([gender isEqualToString:@"S"]){
                gender = @"保密";
            }else{
                gender = @"";
            }
            self.textfield_sex.text = gender;
        }
        NSString *birth_date = [dic objectForKey:@"birth_date"];
        if(![TEUtil isStringNULL:birth_date]){
            self.textfield_birthday.text = birth_date;
        }
    }
}
- (IBAction)buttonClicked:(id)sender {
    [self resetViewFrame];
    switch ([(UIButton*)sender tag]) {
        case 5:
        {
            NSLog(@"save");
            if([self checkStatus]){
                NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
                [params setValue:self.textfield_nickname.text forKey:@"nickname"];
                [params setValue:self.textfield_realname.text forKey:@"real_name"];
                [params setValue:self.textfield_phonenumber.text forKey:@"mobile_num"];
                NSString* gender = @"";
                if([self.textfield_sex.text isEqualToString:@"男"]){
                    gender = @"M";
                }else if([self.textfield_sex.text isEqualToString:@"女"]){
                    gender = @"F";
                }
                else if([self.textfield_sex.text isEqualToString:@"保密"]){
                    gender = @"S";
                }
                [params setValue:gender forKey:@"gender"];
                [params setValue:self.textfield_birthday.text forKey:@"birthday"];
                [TEAppDelegate getApplicationDelegate].networkHandler.delegate_userUpdateUserInfo = self;
                [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_userUpdateUserInfo:params];
                [self displayLoading];
            }
            break;
        }
        case 6:
        //修改密码
        {
            TEEditPasswordViewController* editPwdVC = [[TEEditPasswordViewController alloc]init];
            [self.navigationController pushViewController:editPwdVC animated:YES];
            break;
        }
            
        case 7:
        {
            NSLog(@"take photo");
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选取来自" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"用户相册", nil];
            [actionSheet showInView:self.view];
            break;
        }
        default:
            break;
    }
}
- (IBAction)dateChanged:(id)sender{
    NSDate* date = self.datePicker.date;
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString* string_date = [df stringFromDate:date];
    self.textfield_birthday.text = string_date;
}
- (IBAction)doneEditing:(id)sender{
    [self resetViewFrame];
    switch ([(UIButton*)sender tag]) {
        case 3:
        {
            NSInteger row = [self.sexPicker selectedRowInComponent:0];
            self.textfield_sex.text = [self.sexPickerData objectAtIndex:row] ;
            [self.textfield_sex resignFirstResponder];
            break;
        }
        case 4:
        {
            NSDate* date = self.datePicker.date;
            NSDateFormatter* df = [[NSDateFormatter alloc]init];
            [df setDateFormat:@"yyyy-MM-dd"];
            NSString* string_date = [df stringFromDate:date];
            self.textfield_birthday.text = string_date;
            [self.textfield_birthday resignFirstResponder];
            break;
        }
        default:
            break;
    }
    
}

- (IBAction)button_back_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)resetViewFrame{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
}
#pragma -mark textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
//    switch ([textField tag]) {
//        case 0:
//            [self.textfield_realname becomeFirstResponder];
//            break;
//        case 1:
//            [self.textfield_phonenumber becomeFirstResponder];
//            break;
//        case 2:
//            [self.textfield_sex becomeFirstResponder];
//            break;
//        default:
//            break;
//    }
    return YES;
}

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
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self enabelSaveButton];
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
#pragma -mark sexpicker delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.sexPickerData count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.sexPickerData objectAtIndex:row];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    UIImage* image_compressed = [image rescaleImageToSize:CGSizeMake(150, 150)];
    self.imageview_avatar.image = image_compressed;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //新头像同步到服务器
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    NSData* data_image = UIImageJPEGRepresentation(image_compressed, 1);
    
    
    //保存到硬盘看一下大小
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"test.png"]];   // 保存文件的名称
//    BOOL result = [UIImagePNGRepresentation(image_compressed)writeToFile: filePath atomically:YES];
//    NSLog(@"result is %i",result);
    
    
    
    //本地保存一下
    [TEAppDelegate getApplicationDelegate].imageData = data_image;
    
    [params setValue:data_image forKey:@"avatar"];
    [TEAppDelegate getApplicationDelegate].networkHandler.delegate_userAvatarUpload = self;
    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_userAvatarUpload:params];
    [self displayLoading];
    
}
- (bool)checkStatus
{
    bool result = true;
    NSString* string_alert = nil;
    if (!(self.textfield_nickname.text == nil || [self.textfield_nickname.text isEqualToString:@""]) &&([self.textfield_nickname.text calculateTextNumber] < 4 || [self.textfield_nickname.text calculateTextNumber]>30))
        //    if (_textField_name.text.length < 4 || _textField_name.text.length > 30)
    {
        result = false;
        string_alert = @"昵称不符合规范，应为4-30个字符，支持中英文、数字、下划线和减号";
    }
    else if (!(self.textfield_realname.text == nil || [self.textfield_realname.text isEqualToString:@""]) &&
             ([self.textfield_realname.text calculateTextNumber] < 4 ||
              [self.textfield_realname.text calculateTextNumber]>30))
    {
        result = false;
        string_alert = @"真实姓名不符合规范，应为4-30个字符，支持中英文、数字、下划线和减号";
    }
    else if (!(self.textfield_phonenumber.text == nil || [self.textfield_phonenumber.text isEqualToString:@""]))
    {
        if ([self.textfield_phonenumber.text length] != 11)
        {
            string_alert = @"手机号码不符合规范，应为11位的数字";
        }
        else
        {
            for (int i = 0; i < [self.textfield_phonenumber.text length]; i++)
            {
                char c = [self.textfield_phonenumber.text characterAtIndex:i];
                if (c <'0' || c >'9')
                {
                    string_alert = @"手机号码不符合规范，应为11位的数字";
                    break;
                }
            }
        }
    }
    else {
        NSDate* date_now = [NSDate date];
        if (nil == self.textfield_birthday.text || [self.textfield_birthday.text isEqualToString:@""])
        {
            
        }
        else if (4 * 365 * 24 * 60 * 60 > [date_now timeIntervalSinceDate:[self dateFromString:self.textfield_birthday.text]])
        {
            string_alert = @"生日请选择至少4年前的日期";
        }
    }
    
    if (string_alert != nil)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:string_alert delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alert show];
        result = false;
    }
    return  result;
}
- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}
#pragma -mark actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController* pickC = [[UIImagePickerController alloc]init];
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"拍照");
            pickC.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickC.allowsEditing = YES;
            pickC.delegate = self;
            [self presentViewController:pickC animated:YES completion:^{
                
            }];
            break;
        }
        case 1:
        {
            NSLog(@"相册");
            pickC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickC.allowsEditing = YES;
            pickC.delegate = self;
            [self presentViewController:pickC animated:YES completion:^{
                
            }];
            break;
        }
        default:
            break;
    }
    

}
#pragma -mark uploadAvatar delegate
- (void)userAvatarUploadDidSuccess:(NSDictionary *)rewardDic{
    NSLog(@"loginDidSuccess");
    [self hideLoading];
}
- (void)userAvatarUploadDidFailed:(NSString*)mes{
    NSLog(@"loginDidFailed:%@",mes);
    [TEAppDelegate getApplicationDelegate].isLogin = 0;
    UIAlertView* alert =[[UIAlertView alloc] initWithTitle:nil message:mes delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [self hideLoading];
}
#pragma -mark update user info delegate
- (void)userUpdateUserInfoDidSuccess:(NSDictionary *)rewardDic{
    [self updateLocalUserInfoDic];
    [self hideLoading];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)userUpdateUserInfoDidFailed:(NSString *)mes{
    NSLog(@"loginDidFailed:%@",mes);
    [TEAppDelegate getApplicationDelegate].isLogin = 0;
    UIAlertView* alert =[[UIAlertView alloc] initWithTitle:nil message:mes delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [self hideLoading];
}
- (void)displayLoading{
    self.loadingImage.hidden = NO;
    [self.indicator startAnimating];
}
- (void)hideLoading{
    self.loadingImage.hidden = YES;
    [self.indicator stopAnimating];
}
- (void)enabelSaveButton{
    [self.button_save setUserInteractionEnabled:YES];
    [self.button_save setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
- (void)updateLocalUserInfoDic{
    [[TEAppDelegate getApplicationDelegate].userInfoDictionary setObject:self.textfield_nickname.text forKey:@"username"];
    [[TEAppDelegate getApplicationDelegate].userInfoDictionary setObject:self.textfield_realname.text forKey:@"real_name"];
    [[TEAppDelegate getApplicationDelegate].userInfoDictionary setObject:self.textfield_phonenumber.text forKey:@"mobile_num"];
    NSString* gender = @"";
    if([self.textfield_sex.text isEqualToString:@"男"]){
        gender = @"M";
    }else if([self.textfield_sex.text isEqualToString:@"女"]){
        gender = @"F";
    }
    else if([self.textfield_sex.text isEqualToString:@"保密"]){
        gender = @"S";
    }
    [[TEAppDelegate getApplicationDelegate].userInfoDictionary setObject:gender forKey:@"gender"];
    [[TEAppDelegate getApplicationDelegate].userInfoDictionary setObject:self.textfield_birthday.text forKey:@"birth_date"];
}


@end
