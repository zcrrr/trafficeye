//
//  TESetHomePageViewController.m
//  Trafficeye_new
//
//  Created by zc on 14-1-26.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "TESetHomePageViewController.h"
#import "TEPersistenceHandler.h"

@interface TESetHomePageViewController ()

@end

@implementation TESetHomePageViewController
@synthesize pageArray;
@synthesize FromSetting;
@synthesize currentHomePageIndex;

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
    NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:@"交通地图",@"路况简图",@"交通指数",@"交通微博", nil];
    self.pageArray = array;
    if(self.FromSetting == YES){
        self.button_back.hidden = NO;
    }else{
        self.button_back.hidden = YES;
    }
    NSString* filePath = [TEPersistenceHandler getDocument:@"homePage.plist"];
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSString *homePageIndexStr = [dic valueForKey:@"homePageIndex"];
    if(homePageIndexStr == nil || [@"" isEqualToString:homePageIndexStr]){
        homePageIndexStr = @"1";
    }
    currentHomePageIndex = [homePageIndexStr intValue];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@902102[%i]",LOG_VERSION,currentHomePageIndex],
                           [TEUtil getUserLocationLat],
                           [TEUtil getUserLocationLon]];
    [TEUtil appendStringToPlist:logString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button_back_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)button_ok_clicked:(id)sender {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc ]init];
    NSString* intStr = [NSString stringWithFormat:@"%d", currentHomePageIndex];
    [dic setValue:intStr forKey:@"homePageIndex"];
    //TODO：需要持久化
    NSString* filePath1 = [TEPersistenceHandler getDocument:@"homePage.plist"];
    [dic writeToFile:filePath1 atomically:YES];
    int serverIndex = 0;
    if(currentHomePageIndex == 2)
        serverIndex = 7;
    else if(currentHomePageIndex == 3)
        serverIndex = 5;
    else serverIndex = currentHomePageIndex;
    if([TEAppDelegate getApplicationDelegate].isLogin == 1){
        [TEAppDelegate getApplicationDelegate].networkHandler.delegate_uploadUserSetting = self;
        [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_uploadUserSetting:@"firstPage" :[NSString stringWithFormat:@"%i",serverIndex]];
    }
    if(self.FromSetting == NO){
        [[TEAppDelegate getApplicationDelegate] setStartPage:[intStr intValue]];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
#pragma mark -
#pragma mark Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.pageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"setHomePageCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [pageArray objectAtIndex:row];
    cell.accessoryType = (row == currentHomePageIndex)?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    return cell;
}
#pragma mark -
#pragma mark Table Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int newRow = [indexPath row];
    if(newRow != currentHomePageIndex){
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        NSIndexPath *temp = [NSIndexPath indexPathForRow:currentHomePageIndex inSection:0];
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:temp];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        currentHomePageIndex = newRow;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
