//
//  TENewsSetCityViewController.m
//  Trafficeye_new
//
//  Created by zc on 14-1-24.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "TENewsSetCityViewController.h"
#import "TEPersistenceHandler.h"

@interface TENewsSetCityViewController ()

@end

@implementation TENewsSetCityViewController
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
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
//    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
//                           [TEUtil getNowTime],
//                           [NSString stringWithFormat:@"添加页面编号"],
//                           [TEUtil getUserLocationLat],
//                           [TEUtil getUserLocationLon]];
//    [TEUtil appendStringToPlist:logString];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:@"北京",@"深圳", nil];
    self.cities = array;
    NSString* filePath = [TEPersistenceHandler getDocument:@"newsCitySetting.plist"];
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if(dic){
        self.cityIndex = [[dic objectForKey:@"newsCity"] intValue];
    }else{
        self.cityIndex = 0;
    }
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
    static NSString *cellIdentifier = @"setNewsPageCellIdentifier";
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
        NSLog(@"改变%i",self.cityIndex);
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (NSString*)cityNameForIndex:(int)index{
    switch (index) {
        case 0:
            return @"beijing";
            break;
        case 1:
            return @"shenzhen";
            break;
        default:
            return @"beijing";
            break;
    }
}
- (IBAction)button_back_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)button_ok_clicked:(id)sender {
    NSString* NOTIFICATION_REFRESH_NEWS = @"refresh_news";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESH_NEWS object:nil];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc ]init];
    NSString* intStr = [NSString stringWithFormat:@"%d", self.cityIndex];
    NSLog(@"持久化%i",self.cityIndex);
    [dic setValue:intStr forKey:@"newsCity"];
    //TODO：需要持久化
    NSString* filePath = [TEPersistenceHandler getDocument:@"newsCitySetting.plist"];
    [dic writeToFile:filePath atomically:YES];
    if([TEAppDelegate getApplicationDelegate].isLogin == 1){
        [TEAppDelegate getApplicationDelegate].networkHandler.delegate_uploadUserSetting = self;
        [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_uploadUserSetting:@"infoCity" :[NSString stringWithFormat:@"%i",self.cityIndex]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - upload setting delegate
- (void)uploadUserSettingDidSuccess:(NSDictionary *)dic{
    
}
- (void)uploadUserSettingDidFailed:(NSString *)mes{
    
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
