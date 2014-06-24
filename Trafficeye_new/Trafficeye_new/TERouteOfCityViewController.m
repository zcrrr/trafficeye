//
//  TERouteOfCityViewController.m
//  Trafficeye_new
//
//  Created by zc on 14-1-15.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "TERouteOfCityViewController.h"
#import "TEPersistenceHandler.h"
#import "Obj_Lib_CityInfo.h"
#import "Obj_Lib_StreetInfo.h"
#import "GetFirstLetter.h"
#import "SBJson.h"

@interface TERouteOfCityViewController ()

@end

@implementation TERouteOfCityViewController
@synthesize displayType;
@synthesize str_city_code;
@synthesize favRouteList;
@synthesize routeListAll;
@synthesize routeList_area;
@synthesize routeList_station;
@synthesize routeList_street;
@synthesize button_all;
@synthesize button_area;
@synthesize button_street;
@synthesize button_station;
@synthesize dataSourceList;
@synthesize keys;
@synthesize dataSourceDic;

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
    int line_length = 450;
    if(iPhone5){
        line_length = 450;
    }else{
        line_length = 360;
    }
    float width = 80;
    UIView* blueLine = [[UIView alloc]initWithFrame:CGRectMake(width - 3, 65, 2, line_length)];
    [blueLine setBackgroundColor:[UIColor colorWithRed:44 * 1.0 / 255 green:125 * 1.0 / 255 blue: 191 * 1.0 / 255 alpha:1]];
    [self.view addSubview:blueLine];
    
    UIView* whiteView = [[UIView alloc]initWithFrame:CGRectMake(width - 1 , 65, 2, line_length)];
    [whiteView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:whiteView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
    self.displayType = 0;
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
    NSMutableArray* cityList = [TEAppDelegate getApplicationDelegate].picPraser.citylist;
    for(int i = 0;i<[cityList count];i++){
        Obj_Lib_CityInfo* obj_cityInfo = [cityList objectAtIndex:i];
        if([self.str_city_code isEqualToString:obj_cityInfo.str_cityCode]){
            self.routeListAll = obj_cityInfo.arr_streets;
            break;
        }
    }
    self.dataSourceList = self.routeListAll;
    [self resetKeys];
    self.routeList_area = [[NSMutableArray alloc]init];
    self.routeList_street = [[NSMutableArray alloc]init];
    self.routeList_station = [[NSMutableArray alloc]init];
    for(int i = 0;i<[self.routeListAll count];i++){
        Obj_Lib_StreetInfo* obj_streetInfo = [self.routeListAll objectAtIndex:i];
        if([obj_streetInfo.str_imgtype isEqualToString:@"全市简图"]||[obj_streetInfo.str_imgtype isEqualToString:@"区域简图"]){
            [self.routeList_area addObject:obj_streetInfo];
        }else if([obj_streetInfo.str_imgtype isEqualToString:@"道路简图"]){
            [self.routeList_street addObject:obj_streetInfo];
        }else if([obj_streetInfo.str_imgtype isEqualToString:@"交通枢纽"]){
            [self.routeList_station addObject:obj_streetInfo];
        }
    }
    NSLog(@"全部简图个数是%i",[self.routeListAll count]);
    NSLog(@"区域简图个数是%i",[self.routeList_area count]);
    NSLog(@"街道简图个数是%i",[self.routeList_street count]);
    NSLog(@"火车站个数是%i",[self.routeList_station count]);
    [self initButtons];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@102104",LOG_VERSION],
                           [TEUtil getUserLocationLat],
                           [TEUtil getUserLocationLon]];
    [TEUtil appendStringToPlist:logString];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initButtons{
    float y_offset;
    if(IOS7){
        y_offset = 70;
    }else{
        y_offset = 50;
    }
    float width = 68;
    float height = 49;
    self.button_all = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button_all setTitle:@"全部" forState:UIControlStateNormal];
    self.button_all.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.button_all setTitleColor:[UIColor colorWithRed:44 * 1.0 / 255 green:125 * 1.0 / 255 blue: 191 * 1.0 / 255 alpha:1] forState:UIControlStateNormal];
    self.button_all.tag = 0;
    [self.button_all setBackgroundImage:[UIImage imageNamed:@"biaoqian_selected.png"] forState:UIControlStateNormal];
    [self.button_all setBackgroundImage:[UIImage imageNamed:@"biaoqian_selected.png"] forState:UIControlStateSelected];
    [self.button_all setBackgroundImage:[UIImage imageNamed:@"biaoqian_selected.png"] forState:UIControlStateHighlighted];
    [self.button_all setFrame:CGRectMake(80 + 1 - width, y_offset, width - 2, height)];
    [self.view addSubview:self.button_all];
    [self.button_all addTarget:self action:@selector(button_type_clicked:) forControlEvents:UIControlEventTouchUpInside];
    y_offset = y_offset+height+5;
    if([self.routeList_area count]>0){
        self.button_area = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button_area setTitle:@"区域" forState:UIControlStateNormal];
        self.button_area.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.button_area setTitleColor:[UIColor colorWithRed:44 * 1.0 / 255 green:125 * 1.0 / 255 blue: 191 * 1.0 / 255 alpha:1] forState:UIControlStateNormal];
        self.button_area.tag = 1;
        [self.button_area setBackgroundImage:[UIImage imageNamed:@"biaoqian_normal.png"] forState:UIControlStateNormal];
        [self.button_area setBackgroundImage:[UIImage imageNamed:@"biaoqian_selected.png"] forState:UIControlStateSelected];
        [self.button_area setBackgroundImage:[UIImage imageNamed:@"biaoqian_selected.png"] forState:UIControlStateHighlighted];
        [self.button_area setFrame:CGRectMake(80 + 1 - width, y_offset, width - 2, height)];
        [self.view addSubview:self.button_area];
        [self.button_area addTarget:self action:@selector(button_type_clicked:) forControlEvents:UIControlEventTouchUpInside];
        y_offset = y_offset+height+5;
    }
    if([self.routeList_street count]>0){
        self.button_street = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button_street setTitle:@"街道" forState:UIControlStateNormal];
        self.button_street.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.button_street setTitleColor:[UIColor colorWithRed:44 * 1.0 / 255 green:125 * 1.0 / 255 blue: 191 * 1.0 / 255 alpha:1] forState:UIControlStateNormal];
        self.button_street.tag = 2;
        [self.button_street setBackgroundImage:[UIImage imageNamed:@"biaoqian_normal.png"] forState:UIControlStateNormal];
        [self.button_street setBackgroundImage:[UIImage imageNamed:@"biaoqian_selected.png"] forState:UIControlStateSelected];
        [self.button_street setBackgroundImage:[UIImage imageNamed:@"biaoqian_selected.png"] forState:UIControlStateHighlighted];
        [self.button_street setFrame:CGRectMake(80 + 1 - width, y_offset, width - 2, height)];
        [self.view addSubview:self.button_street];
        [self.button_street addTarget:self action:@selector(button_type_clicked:) forControlEvents:UIControlEventTouchUpInside];
        y_offset = y_offset+height+5;
    }
    if([self.routeList_station count]>0){
        self.button_station = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button_station setTitle:@"火车站" forState:UIControlStateNormal];
        self.button_station.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.button_station setTitleColor:[UIColor colorWithRed:44 * 1.0 / 255 green:125 * 1.0 / 255 blue: 191 * 1.0 / 255 alpha:1] forState:UIControlStateNormal];
        self.button_station.tag = 3;
        [self.button_station setBackgroundImage:[UIImage imageNamed:@"biaoqian_normal.png"] forState:UIControlStateNormal];
        [self.button_station setBackgroundImage:[UIImage imageNamed:@"biaoqian_selected.png"] forState:UIControlStateSelected];
        [self.button_station setBackgroundImage:[UIImage imageNamed:@"biaoqian_selected.png"] forState:UIControlStateHighlighted];
        [self.button_station setFrame:CGRectMake(80 + 1 - width, y_offset, width - 2, height)];
        [self.view addSubview:self.button_station];
        [self.button_station addTarget:self action:@selector(button_type_clicked:) forControlEvents:UIControlEventTouchUpInside];
        y_offset = y_offset+height+5;
    }
}
-(IBAction)button_type_clicked:(id)sender{
    switch ([(UIButton*)sender tag]) {
        case 0:
            if(self.displayType == 0){
                return;
            }
            self.displayType = 0;
            [self resetButtonImage];
            [self.button_all setBackgroundImage:[UIImage imageNamed:@"biaoqian_selected.png"] forState:UIControlStateNormal];
            self.dataSourceList = self.routeListAll;
            break;
        case 1:
            if(self.displayType == 1){
                return;
            }
            self.displayType = 1;
            [self resetButtonImage];
            [self.button_area setBackgroundImage:[UIImage imageNamed:@"biaoqian_selected.png"] forState:UIControlStateNormal];
            self.dataSourceList = self.routeList_area;
            break;
        case 2:
            if(self.displayType == 2){
                return;
            }
            self.displayType = 2;
            [self resetButtonImage];
            [self.button_street setBackgroundImage:[UIImage imageNamed:@"biaoqian_selected.png"] forState:UIControlStateNormal];
            self.dataSourceList = self.routeList_street;
            break;
        case 3:
            if(self.displayType == 3){
                return;
            }
            self.displayType = 3;
            [self resetButtonImage];
            [self.button_station setBackgroundImage:[UIImage imageNamed:@"biaoqian_selected.png"] forState:UIControlStateNormal];
            self.dataSourceList = self.routeList_station;
            break;
        default:
            break;
    }
    [self resetKeys];
    [self.tableview reloadData];
    
}
- (void)resetButtonImage{
    [self.button_all setBackgroundImage:[UIImage imageNamed:@"biaoqian_normal.png"] forState:UIControlStateNormal];
    [self.button_area setBackgroundImage:[UIImage imageNamed:@"biaoqian_normal.png"] forState:UIControlStateNormal];
    [self.button_street setBackgroundImage:[UIImage imageNamed:@"biaoqian_normal.png"] forState:UIControlStateNormal];
    [self.button_station setBackgroundImage:[UIImage imageNamed:@"biaoqian_normal.png"] forState:UIControlStateNormal];
}
#pragma mark - TableviewDelegate
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([keys count] == 0)
    {
        return 0;
    }
    NSString* key = [self.keys objectAtIndex:section];
    NSArray* roadSection = [self.dataSourceDic objectForKey:key];
    //    NSLog(@"roadSection count = %d",[roadSection count]);
    return [roadSection count];

}
- (int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.keys count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //return [[keys objectAtIndex:section] uppercaseString];
    if ([self.keys count] ==0)
        return @"";
    return [self.keys objectAtIndex:section];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    NSString* key = [self.keys objectAtIndex:section];
    static NSString *ListCellIdentifier = @"ListCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListCellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListCellIdentifier];
    }
    Obj_Lib_StreetInfo* streetInfo = [[self.dataSourceDic objectForKey:key] objectAtIndex:row];
    NSString* str_streetName = streetInfo.str_imgname;
    cell.textLabel.text = str_streetName;
    cell.textLabel.textColor = [UIColor blackColor];
    if([self isInFavList:streetInfo.str_imgid]!=-1){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row = [indexPath row];
    NSInteger section = [indexPath section];
    NSString* key = [self.keys objectAtIndex:section];
    Obj_Lib_StreetInfo* oneStreetInfo = [[self.dataSourceDic objectForKey:key] objectAtIndex:row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int indexInFav = [self isInFavList:oneStreetInfo.str_imgid];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(indexInFav != -1){//打着对号
        if([self.favRouteList count] == 1){//就剩一个了
            NSLog(@"就剩一个了");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"至少关注一个" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            cell.accessoryType = UITableViewCellStyleDefault;
            [self.favRouteList removeObjectAtIndex:indexInFav];
        }
    }else{
        if([self.favRouteList count] == 8){
            NSLog(@"最多8个");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多关注8个" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            NSMutableDictionary *oneStreetDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.str_city_code,@"city",[TEUtil getCityName:self.str_city_code],@"city_name",oneStreetInfo.str_imgid,@"road",oneStreetInfo.str_imgname,@"road_name",nil];
            [self.favRouteList addObject:oneStreetDic];
        }
    }
}
- (NSArray*) sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.keys;
}

- (int)isInFavList:(NSString *)routeName{
    int i = 0;
    for(i = 0;i<[self.favRouteList count];i++){
        if([routeName isEqualToString:[[self.favRouteList objectAtIndex:i]objectForKey:@"road"]]){
            break;
        }
    }
    if(i<[self.favRouteList count]){
        return i;
    }else{
        return -1;
    }
}
- (void)resetKeys{
    NSMutableArray* array_keys = [[NSMutableArray alloc]init];
    self.dataSourceDic = [[NSMutableDictionary alloc]init];
    for (Obj_Lib_StreetInfo* oneObjStreetInfo in self.dataSourceList)
    {
        char c = [GetFirstLetter  pinyinFirstLetter:([oneObjStreetInfo.str_imgname characterAtIndex:0])];
        NSString* oneKey = [[NSString stringWithFormat:@"%c",c] uppercaseString];
        
        /*
         对 ”长“ 进行特殊处理
         直接归属为C
         */
        if (nil != oneObjStreetInfo.str_imgname && ![oneObjStreetInfo.str_imgname isEqualToString:@""])
        {
            NSString* str_firstChar = [oneObjStreetInfo.str_imgname substringToIndex:1];
            
            if ([str_firstChar isEqualToString:@"长"])
            {
                oneKey = @"C";
            }
            if ([str_firstChar isEqualToString:@"重"])
            {
                oneKey = @"C";
            }
        }
        NSMutableArray* array_streetGroud = [self.dataSourceDic valueForKey:oneKey];
        if (array_streetGroud == nil)
        {
            [array_keys addObject:oneKey];
            array_streetGroud = [[NSMutableArray alloc]init];
        }
        [array_streetGroud addObject:oneObjStreetInfo];
        [self.dataSourceDic setValue:array_streetGroud forKey:oneKey];
    }
    self.keys = [[NSMutableArray alloc]init];
    [self.keys addObjectsFromArray:[array_keys sortedArrayUsingSelector:@selector(compare:)]];
}
- (IBAction)button_back_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
