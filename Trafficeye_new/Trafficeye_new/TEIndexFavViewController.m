//
//  TEIndexFavViewController.m
//  Trafficeye_new
//
//  Created by zc on 14-1-16.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "TEIndexFavViewController.h"
#import "TEPersistenceHandler.h"
#import "TEAllRoutesViewController.h"

@interface TEIndexFavViewController ()

@end

@implementation TEIndexFavViewController
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
    [self.tableView setEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString* filePath = [TEPersistenceHandler getDocument:@"traIndexFav.plist"];
    NSMutableArray* arrayFromPlist = [NSMutableArray arrayWithContentsOfFile:filePath];
    if(arrayFromPlist){
        self.favRouteList = arrayFromPlist;
    }else{
        self.favRouteList = [[NSMutableArray alloc]initWithObjects:@"北京-全路网",@"深圳-全市",nil];
    }
    [self.tableView reloadData];
    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@103102",LOG_VERSION],
                           [TEUtil getUserLocationLat],
                           [TEUtil getUserLocationLon]];
    [TEUtil appendStringToPlist:logString];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button_add_clicked:(id)sender {
    NSString* filePath = [TEPersistenceHandler getDocument:@"traIndexFav.plist"];
    [self.favRouteList writeToFile:filePath atomically:YES];
    TEAllRoutesViewController *traIndexRouteVC = [[TEAllRoutesViewController alloc]init];
    [self.navigationController pushViewController:traIndexRouteVC animated:YES];
}

- (IBAction)button_ok_clicked:(id)sender {
    NSString* filePath = [TEPersistenceHandler getDocument:@"traIndexFav.plist"];
    [self.favRouteList writeToFile:filePath atomically:YES];
    [self.navigationController popViewControllerAnimated:YES];
    NSString* NOTIFICATION_REFRESH_INDEX = @"refresh_index";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESH_INDEX object:nil];
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
    cell.textLabel.text = [self.favRouteList objectAtIndex:row];
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
        [self.tableView reloadData];
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
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}

@end
