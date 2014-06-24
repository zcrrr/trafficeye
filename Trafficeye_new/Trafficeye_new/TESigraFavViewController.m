//
//  TESigraFavViewController.m
//  Trafficeye_new
//
//  Created by zc on 14-1-14.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "TESigraFavViewController.h"
#import "TEPersistenceHandler.h"
#import "SBJson.h"
#import "TESigraAddCityViewController.h"

@interface TESigraFavViewController ()

@end

@implementation TESigraFavViewController
@synthesize favRouteList;

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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString* filePath = [TEPersistenceHandler getDocument:@"favPic.plist"];
    NSMutableArray* arrayFromPlist = [NSMutableArray arrayWithContentsOfFile:filePath];
    if(arrayFromPlist){
        self.favRouteList = arrayFromPlist;
    }else{
        self.favRouteList = [[NSMutableArray alloc]init];
        NSMutableDictionary* dic1 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"101010100",@"city", @"北京",@"city_name",@"0010_103_001",@"road",@"全市路况(新)",@"road_name",nil];
        NSMutableDictionary* dic2 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"101020100",@"city", @"上海",@"city_name",@"0021_103_001",@"road",@"全市路况(新)",@"road_name",nil];
        NSMutableDictionary* dic3 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"101280101",@"city", @"广州",@"city_name",@"S120054",@"road",@"全市路况",@"road_name",nil];
        NSMutableDictionary* dic4 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"101280601",@"city", @"深圳",@"city_name",@"0755_103_001",@"road",@"全市路况(新)",@"road_name",nil];
        [self.favRouteList addObject:dic1];
        [self.favRouteList addObject:dic2];
        [self.favRouteList addObject:dic3];
        [self.favRouteList addObject:dic4];
    }
    //设置tableview可编辑
    [self.tableview_roadList setEditing:YES];
    [self.tableview_roadList reloadData];
    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@102102",LOG_VERSION],
                           [TEUtil getUserLocationLat],
                           [TEUtil getUserLocationLon]];
    [TEUtil appendStringToPlist:logString];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - TableviewDelegate

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.favRouteList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    static NSString *ListCellIdentifier = @"ListCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListCellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListCellIdentifier];
    }
    NSDictionary* dic = [self.favRouteList objectAtIndex:row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"city_name"],[dic objectForKey:@"road_name"]];
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}
-(NSString*) tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
#pragma mark - tableView edit delegate

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSLog(@"拖动位置");
    id object=[self.favRouteList objectAtIndex:[fromIndexPath row]];
    [self.favRouteList removeObjectAtIndex:[fromIndexPath row]];
    [self.favRouteList insertObject:object atIndex:[toIndexPath row]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    if (1 == [self.favRouteList count])
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"至少保留一条道路。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [self.tableview_roadList reloadData];
    }
    else
    {
        [self.favRouteList removeObjectAtIndex:row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (BOOL)tableView:(UITableView *)tableView
shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (IBAction)button_add_clicked:(id)sender {
    NSString* filePath = [TEPersistenceHandler getDocument:@"favPic.plist"];
    [self.favRouteList writeToFile:filePath atomically:YES];
    TESigraAddCityViewController* sigraAddCityVC = [[TESigraAddCityViewController alloc]init];
    [self.navigationController pushViewController:sigraAddCityVC animated:YES];
}

- (IBAction)button_ok_clicked:(id)sender {
    NSString* filePath = [TEPersistenceHandler getDocument:@"favPic.plist"];
    [self.favRouteList writeToFile:filePath atomically:YES];
    //这里把道路同步到服务器
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString* jsonStr = [jsonWriter stringWithObject:self.favRouteList];
    NSLog(@"jsonStr = %@",jsonStr);
    
    if([TEAppDelegate getApplicationDelegate].isLogin == 1){
        [TEAppDelegate getApplicationDelegate].networkHandler.delegate_uploadUserSetting = self;
        [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_uploadUserSetting:@"transform" :jsonStr];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    NSString* NOTIFICATION_REFRESH_PIC = @"refresh_pic";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESH_PIC object:nil];
}
#pragma mark - upload setting delegate
- (void)uploadUserSettingDidSuccess:(NSDictionary *)dic{
    
}
- (void)uploadUserSettingDidFailed:(NSString *)mes{
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}

@end
