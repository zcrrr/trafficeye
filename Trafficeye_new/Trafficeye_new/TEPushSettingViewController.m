//
//  TEPushSettingViewController.m
//  Trafficeye_new
//
//  Created by zc on 14-2-19.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "TEPushSettingViewController.h"
#import "TEPersistenceHandler.h"

@interface TEPushSettingViewController ()

@end

@implementation TEPushSettingViewController
@synthesize cities;
@synthesize cityIndex;

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
    NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:@"北京",@"上海",@"广州",@"深圳", nil];
    self.cities = array;
    NSString* filePath = [TEPersistenceHandler getDocument:@"pushSetting.plist"];
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if(dic){
        self.cityIndex = [[dic objectForKey:@"pushCity"] intValue];
        NSString *pushFlag = [dic objectForKey:@"pushFlag"];
        if(!pushFlag||[pushFlag isEqualToString:@"YES"]){
            self.pushSwitch.on = YES;
        }else if([pushFlag isEqualToString:@"NO"]){
            self.pushSwitch.on = NO;
            self.label_settingCity.hidden = YES;
            self.tableView.hidden = YES;
        }
    }else{
        self.cityIndex = 0;
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@902103",LOG_VERSION],
                           [TEUtil getUserLocationLat],
                           [TEUtil getUserLocationLon]];
    [TEUtil appendStringToPlist:logString];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.cities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"tableView");
    static NSString *cellIdentifier = @"setHomePageCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [self.cities objectAtIndex:row];
    cell.accessoryType = (row == cityIndex)?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    return cell;
}
#pragma mark -
#pragma mark Table Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int newRow = [indexPath row];
    if(newRow != self.cityIndex){
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        NSIndexPath *temp = [NSIndexPath indexPathForRow:self.cityIndex inSection:0];
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:temp];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        self.cityIndex = newRow;
        //        self.currentCity = (currentHomePageIndex == 0)?@"beijing":@"shenzhen";
        NSLog(@"改变%i",self.cityIndex);
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    self.button_ok.enabled = NO;
}
- (void)enableAllButton{
    self.button_back.enabled = YES;
    self.button_ok.enabled = YES;
}
- (IBAction)switchChanged:(id)sender {
    if(self.pushSwitch.isOn){
        self.tableView.hidden = NO;
        self.label_settingCity.hidden = NO;
    }else{
        self.tableView.hidden = YES;
        self.label_settingCity.hidden = YES;
    }
}
- (IBAction)button_back_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)button_ok_clicked:(id)sender {
    NSString *pushFlag;
    NSString *ispush;
    if(self.pushSwitch.isOn){
        NSLog(@"通知服务器，设置城市为%i",self.cityIndex);
        pushFlag = @"YES";
        ispush = @"0";
    }else{
        pushFlag = @"NO";
        ispush = @"1";
    }
    //上传服务器
    [TEAppDelegate getApplicationDelegate].networkHandler.delegate_pushSetting = self;
    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_pushSetting:ispush :[self getCityName]];
}
- (NSString*)getCityName{
    NSString *cityStr;
    switch(self.cityIndex){
        case 0:
        {
            cityStr = @"beijing";
            break;
        }
        case 1:
        {
            cityStr = @"shanghai";
            break;
        }
        case 2:
        {
            cityStr = @"guangzhou";
            break;
        }
        case 3:
        {
            cityStr = @"shenzhen";
            break;
        }
        default:cityStr = @"beijing";
    }
    return cityStr;
}
#pragma push setting delegate
- (void)pushSettingDidSuccess:(NSDictionary *)dic{
    NSString *code = [dic objectForKey:@"code"];
    if([code isEqualToString:@"1"]){
        NSString *pushFlag;
        NSString *ispush;
        if(self.pushSwitch.isOn){
            NSLog(@"通知服务器，设置城市为%i",self.cityIndex);
            pushFlag = @"YES";
            ispush = @"0";
        }else{
            pushFlag = @"NO";
            ispush = @"1";
        }
        NSMutableDictionary* dic = [[NSMutableDictionary alloc ]init];
        NSString* intStr = [NSString stringWithFormat:@"%d", self.cityIndex];
        [dic setValue:intStr forKey:@"pushCity"];
        [dic setValue:pushFlag forKey:@"pushFlag"];
        //TODO：需要持久化
        NSString* filePath = [TEPersistenceHandler getDocument:@"pushSetting.plist"];
        [dic writeToFile:filePath atomically:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSString *mes = @"设置失败请稍后重试";
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:mes delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alertView show];
    }

}
- (void)pushSettingDidFailed:(NSString *)mes{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:mes delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
    [alertView show];
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
