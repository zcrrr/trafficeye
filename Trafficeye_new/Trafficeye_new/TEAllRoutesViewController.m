//
//  TEAllRoutesViewController.m
//  Trafficeye_new
//
//  Created by zc on 14-1-22.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "TEAllRoutesViewController.h"
#import "TEPersistenceHandler.h"

@interface TEAllRoutesViewController ()

@end

@implementation TEAllRoutesViewController
@synthesize selectRouteList;
@synthesize btn1;
@synthesize btn2;
@synthesize btn3;
@synthesize cityIndex;
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
    self.cityIndex = 0;
    self.selectRouteList = [[NSMutableArray alloc]initWithObjects:@"北京-全路网",@"北京-二环内",@"北京-二环至三环",@"北京-三环至四环",@"北京-四环至五环",@"北京-东城区",@"北京-西城区",@"北京-海淀区",@"北京-朝阳区",@"北京-丰台区",@"北京-石景山区",nil];
    NSString* filePath = [TEPersistenceHandler getDocument:@"traIndexFav.plist"];
    NSMutableArray* arrayFromPlist = [NSMutableArray arrayWithContentsOfFile:filePath];
    if(arrayFromPlist){
        self.favRouteList = arrayFromPlist;
    }else{
        self.favRouteList = [[NSMutableArray alloc]initWithObjects:@"北京-全路网",@"深圳-全市",nil];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString *logString = [NSString stringWithFormat:@"%li,%@,%f %f;",
                           [TEUtil getNowTime],
                           [NSString stringWithFormat:@"I%@103103",LOG_VERSION],
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
    NSString* filePath = [TEPersistenceHandler getDocument:@"traIndexFav.plist"];
    [self.favRouteList writeToFile:filePath atomically:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)button_city_clicked:(id)sender {
    switch ([(UIButton*)sender tag]) {
        case 0:{
            if(self.cityIndex != 0){
                [self.btn1 setBackgroundImage:[UIImage imageNamed:@"biaoqian_selected.png"] forState:UIControlStateNormal];
                [self.btn2 setBackgroundImage:[UIImage imageNamed:@"biaoqian_normal.png"] forState:UIControlStateNormal];
                [self.btn3 setBackgroundImage:[UIImage imageNamed:@"biaoqian_normal.png"] forState:UIControlStateNormal];
                [self.btn4 setBackgroundImage:[UIImage imageNamed:@"biaoqian_normal.png"] forState:UIControlStateNormal];
                self.selectRouteList = [[NSMutableArray alloc]initWithObjects:@"北京-全路网",@"北京-二环内",@"北京-二环至三环",@"北京-三环至四环",@"北京-四环至五环",@"北京-东城区",@"北京-西城区",@"北京-海淀区",@"北京-朝阳区",@"北京-丰台区",@"北京-石景山区",nil];
                [self.tableView reloadData];
                self.cityIndex = 0;
            }
            break;
        }
        case 1:{
            if(self.cityIndex != 1){
                [self.btn2 setBackgroundImage:[UIImage imageNamed:@"biaoqian_selected.png"] forState:UIControlStateNormal];
                [self.btn1 setBackgroundImage:[UIImage imageNamed:@"biaoqian_normal.png"] forState:UIControlStateNormal];
                [self.btn3 setBackgroundImage:[UIImage imageNamed:@"biaoqian_normal.png"] forState:UIControlStateNormal];
                [self.btn4 setBackgroundImage:[UIImage imageNamed:@"biaoqian_normal.png"] forState:UIControlStateNormal];
                self.selectRouteList = [[NSMutableArray alloc]initWithObjects:@"深圳-全市",@"深圳-中心城区",@"深圳-原特区外",@"深圳-全市主骨干网",@"深圳-福田",@"深圳-罗湖",@"深圳-南山",@"深圳-盐田",@"深圳-宝安",@"深圳-龙岗",nil];
                
                [self.tableView reloadData];
                self.cityIndex = 1;
            }
            
            break;
        }
        case 2:{
            if(self.cityIndex != 2){
                [self.btn2 setBackgroundImage:[UIImage imageNamed:@"biaoqian_normal.png"] forState:UIControlStateNormal];
                [self.btn1 setBackgroundImage:[UIImage imageNamed:@"biaoqian_normal.png"] forState:UIControlStateNormal];
                [self.btn3 setBackgroundImage:[UIImage imageNamed:@"biaoqian_selected.png"] forState:UIControlStateNormal];
                [self.btn4 setBackgroundImage:[UIImage imageNamed:@"biaoqian_normal.png"] forState:UIControlStateNormal];
                self.selectRouteList = [[NSMutableArray alloc]initWithObjects:@"杭州-核心区",@"杭州-城西片区",@"杭州-城北片区",@"城东片区",@"城南片区",@"杭州-西湖风景区",nil];
                [self.tableView reloadData];
                self.cityIndex = 2;
            }
            
            break;
        }
        case 3:{
            if(self.cityIndex != 3){
                [self.btn1 setBackgroundImage:[UIImage imageNamed:@"biaoqian_normal.png"] forState:UIControlStateNormal];
                [self.btn2 setBackgroundImage:[UIImage imageNamed:@"biaoqian_normal.png"] forState:UIControlStateNormal];
                [self.btn3 setBackgroundImage:[UIImage imageNamed:@"biaoqian_normal.png"] forState:UIControlStateNormal];
                [self.btn4 setBackgroundImage:[UIImage imageNamed:@"biaoqian_selected.png"] forState:UIControlStateNormal];
                self.selectRouteList = [[NSMutableArray alloc]initWithObjects:
                                        @"上海-总路网(快速路)",@"上海-共和~蕴川(南北东侧)",@"上海-济阳~仙霞(中环内侧)",
                                        @"上海-仙霞~济阳(中环外侧)",@"上海-共和~延西(内环外侧)",
                                        @"上海-鲁班~共和(南北东侧)",@"上海-鲁班~济阳(南北西侧)",@"上海-蕴川~共和(南北西侧)",
                                        @"上海-共和~仙霞(中环外侧)",@"上海-杨浦~鲁班(内环内侧)",@"上海-申江~济阳(中环内侧)",
                                        @"上海-逸仙西侧",@"上海-沪闵东侧",@"上海-军工~共和(中环外侧)",
                                        @"上海-延西~鲁班(内环外侧)",@"上海-共和~军工(中环内侧)",@"上海-延安北侧",
                                        @"上海-济阳~申江(中环外侧)",@"上海-济阳~鲁班(南北东侧)",@"上海-逸仙东侧",
                                        @"上海-沪闵西侧",@"上海-共和~杨浦(内环内侧)",@"上海-仙霞~共和(中环内侧)",
                                        @"上海-杨浦~共和(内环外侧)",@"上海-延安南侧",@"上海-鲁班~杨浦(内环外侧)",
                                        @"上海-共和~鲁班(南北西侧)",@"上海-总路网(地面道路)",@"上海-城隍庙",
                                        @"上海-静安寺",@"上海-中山公园",@"上海-上海南站",
                                        @"上海-打浦桥",@"上海-大柏树",@"上海-五角场",
                                        @"上海-老北站",@"上海-徐家汇",@"上海-上海火车站",
                                        @"上海-金桥",@"上海-沪太",@"上海-瑞金医院",@"上海-南京路商圈",
                                        @"上海-新华医院",@"上海-陆家嘴",@"上海-人民广场",@"上海-虹口足球场",
                                        @"上海-上海西站",@"上海-新天地",
                                        nil];
                [self.tableView reloadData];
                self.cityIndex = 3;
            }
            
            break;
        }
            
        default:
            break;
    }
}
#pragma mark - TableviewDelegate

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.selectRouteList count];
}
- (int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    static NSString *ListCellIdentifier = @"ListCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListCellIdentifier];
    if (cell == nil)
    {
        //        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:ListCellIdentifier]autorelease];
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListCellIdentifier];
    }
    cell.textLabel.text = [self.selectRouteList objectAtIndex:row];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if([self isInFavList:[self.selectRouteList objectAtIndex:row]]!=-1){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row = [indexPath row];
    int indexInFav = [self isInFavList:[self.selectRouteList objectAtIndex:row]];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(indexInFav != -1){//打着对号
        if([self.favRouteList count] == 1){//就剩一个了
            NSLog(@"就剩一个了");
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
            [self.favRouteList addObject:cell.textLabel.text];
        }
        
    }
}
- (int)isInFavList:(NSString *)routeName{
    int i = 0;
    for(i = 0;i<[self.favRouteList count];i++){
        if([routeName isEqualToString:[self.favRouteList objectAtIndex:i]]){
            break;
        }
    }
    if(i<[self.favRouteList count]){
        return i;
    }else{
        return -1;
    }
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
