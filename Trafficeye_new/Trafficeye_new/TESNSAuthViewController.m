//
//  TESNSAuthViewController.m
//  Trafficeye_new
//
//  Created by zc on 14-3-20.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "TESNSAuthViewController.h"
#import "AGShareCell.h"
#import <ShareSDK/ShareSDK.h>
#import <AGCommon/UIImage+Common.h>
#import "TEPersistenceHandler.h"


#define TARGET_CELL_ID @"targetCell"
#define BUNDLE_NAME @"Resource"
#define BASE_TAG 100


@interface TESNSAuthViewController ()

@end

@implementation TESNSAuthViewController
@synthesize snsDataList;

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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
    NSString* filePath = [TEPersistenceHandler getDocument:@"snsAuth.plist"];
    NSMutableArray* arrayFromPlist = [NSMutableArray arrayWithContentsOfFile:filePath];
    if(arrayFromPlist){
        self.snsDataList = arrayFromPlist;
    }else{
        NSDictionary* dic1 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%i",ShareTypeSinaWeibo],@"type",@"",@"username",nil];
        NSDictionary* dic2 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%i",ShareTypeTencentWeibo],@"type",@"",@"username",nil];
        NSDictionary* dic3 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%i",ShareTypeQQSpace],@"type",@"",@"username",nil];
        self.snsDataList = [[NSMutableArray alloc]initWithObjects:dic1,dic2,dic3,nil];
    }
    //可能会有已经授权但是没有保存用户名的情况
    for(int i = 0;i<[self.snsDataList count];i++){
        int snsType = [[[self.snsDataList objectAtIndex:i] objectForKey:@"type"] intValue];
        if([ShareSDK hasAuthorizedWithType:snsType]){//已经授权了这个平台
            NSString* username = [[self.snsDataList objectAtIndex:i]objectForKey:@"username"];
            if([username isEqualToString:@""]){//已经授权却没有用户名
                [ShareSDK getUserInfoWithType:snsType              //平台类型
                                  authOptions:nil                                          //授权选项
                                       result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                           if (result)
                                           {
                                               NSLog(@"获取用户信息成功");
                                               [[self.snsDataList objectAtIndex:i] setObject:[userInfo nickname] forKey:@"username"];
                                               //写入plist
                                               NSString* filePath = [TEPersistenceHandler getDocument:@"snsAuth.plist"];
                                               [self.snsDataList writeToFile:filePath atomically:YES];
                                               [self.tableview reloadData];
                                           }
                                           else
                                           {
                                               NSLog(@"获取用户信息失败");
                                           }
                                       }];
            }
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [snsDataList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TARGET_CELL_ID];
    if (cell == nil)
    {
        cell = [[AGShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TARGET_CELL_ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UISwitch *switchCtrl = [[UISwitch alloc] initWithFrame:CGRectZero];
        [switchCtrl sizeToFit];
        [switchCtrl addTarget:self action:@selector(authSwitchChangeHandler:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchCtrl;
    }
    int snsType = [[[self.snsDataList objectAtIndex:row] objectForKey:@"type"] intValue];
    UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"Icon/sns_icon_%d.png",snsType]
                            bundleName:BUNDLE_NAME];
    cell.imageView.image = img;
    
    ((UISwitch *)cell.accessoryView).on = [ShareSDK hasAuthorizedWithType:snsType];
    ((UISwitch *)cell.accessoryView).tag = BASE_TAG + indexPath.row;
    
    if (((UISwitch *)cell.accessoryView).on)
    {
        NSString* username = [[self.snsDataList objectAtIndex:row]objectForKey:@"username"];
        NSString* platformName = @"";
        switch (row) {
            case 0:
                platformName=@"新浪微博";
                break;
            case 1:
                platformName=@"腾讯微博";
                break;
            case 2:
                platformName=@"qq空间";
                break;
                
            default:
                break;
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",platformName,username];
    }
    else
    {
        NSString* platformName = @"";
        switch (row) {
            case 0:
                platformName=@"新浪微博";
                break;
            case 1:
                platformName=@"腾讯微博";
                break;
            case 2:
                platformName=@"qq空间";
                break;
                
            default:
                break;
        }
        cell.textLabel.text = platformName;
    }
    return cell;
}
- (IBAction)button_back_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)authSwitchChangeHandler:(UISwitch *)sender
{
    NSInteger index = sender.tag - BASE_TAG;
    
    if (index < [self.snsDataList count])
    {
        int snsType = [[[self.snsDataList objectAtIndex:index] objectForKey:@"type"] intValue];
        if (sender.on)
        {
            //用户用户信息
            [ShareSDK getUserInfoWithType:snsType              //平台类型
                              authOptions:nil                                          //授权选项
                                   result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                       if (result)
                                       {
                                           NSLog(@"获取用户信息成功");
                                           [[self.snsDataList objectAtIndex:index] setObject:[userInfo nickname] forKey:@"username"];
                                           [self.tableview reloadData];
                                       }
                                       else
                                       {
                                           NSLog(@"获取用户信息失败");
                                           [self.tableview reloadData];
                                       }
                                   }];
        }
        else
        {
            //取消授权
            [ShareSDK cancelAuthWithType:snsType];
            [[self.snsDataList objectAtIndex:index] setObject:@"" forKey:@"username"];
            [self.tableview reloadData];
        }
        
        //写入plist
        NSString* filePath = [TEPersistenceHandler getDocument:@"snsAuth.plist"];
        [self.snsDataList writeToFile:filePath atomically:YES];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}

@end
