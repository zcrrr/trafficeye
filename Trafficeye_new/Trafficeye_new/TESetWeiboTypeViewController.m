//
//  TESetWeiboTypeViewController.m
//  Trafficeye_new
//
//  Created by zc on 14-1-26.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "TESetWeiboTypeViewController.h"
#import "TEPersistenceHandler.h"

@interface TESetWeiboTypeViewController ()

@end

@implementation TESetWeiboTypeViewController
{
    int countOfSelected;
}
@synthesize listData;
@synthesize flagArray;

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
    NSArray *array = [[NSArray alloc] initWithObjects:@"交通",@"公安",@"媒体",@"气象",@"铁路",@"民航",@"地铁",@"旅游",nil];
    self.listData = array;
    NSString* filePath = [TEPersistenceHandler getDocument:@"weiboType.plist"];
    NSMutableArray* arrayFromPlist = [NSMutableArray arrayWithContentsOfFile:filePath];
    if(arrayFromPlist){
        self.flagArray = arrayFromPlist;
        countOfSelected = [self getArrayCount];
    }else{
        self.flagArray = [[NSMutableArray alloc]initWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",nil];
        countOfSelected = 8;
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@105104",LOG_VERSION],
                           [TEUtil getUserLocationLat],
                           [TEUtil getUserLocationLon]];
    [TEUtil appendStringToPlist:logString];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (int)getArrayCount{
    int num = 0;
    for(int i=0;i<[self.flagArray count];i++){
        if([[self.flagArray objectAtIndex:i] isEqualToString:@"1"]){
            num++;
        }
    }
    return num;
}

- (IBAction)button_back_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)button_ok_clicked:(id)sender {
    extern BOOL settingChange;
    settingChange = YES;
    //TODO：需要持久化
    NSString* filePath = [TEPersistenceHandler getDocument:@"weiboType.plist"];
    [self.flagArray writeToFile:filePath atomically:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark Table View Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"tableView");
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [self.listData objectAtIndex:row];
    if([[self.flagArray objectAtIndex:row] isEqualToString:@"1"]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}
#pragma mark -
#pragma mark Table Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([[self.flagArray objectAtIndex:row] isEqualToString:@"1"]){
        if(countOfSelected == 1){
            NSLog(@"就剩一个了");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"至少选择一个类别" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }else{
            cell.accessoryType = UITableViewCellStyleDefault;
            [self.flagArray replaceObjectAtIndex:row withObject:@"0"];
            countOfSelected--;
        }
    }else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.flagArray replaceObjectAtIndex:row withObject:@"1"];
        countOfSelected++;
    }
    NSLog(@"长度%i",countOfSelected);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
