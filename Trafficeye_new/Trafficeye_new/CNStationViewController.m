//
//  CNStationViewController.m
//  WhereIsTheBus
//
//  Created by zc on 14-4-27.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "CNStationViewController.h"
#import "TEBusMapViewController.h"
#import "TEOneStationHasBus.h"
#import "Toast+UIView.h"


@interface CNStationViewController ()

@end

@implementation CNStationViewController
@synthesize stationList;
@synthesize timer_one_minute;
@synthesize linename;
@synthesize stationName;
@synthesize busList;
@synthesize bubbleView;
@synthesize busInfoDic;
@synthesize nearestbus;
@synthesize y_interestStation;

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
    self.busInfoDic = [[NSMutableDictionary alloc]init];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self doRequestBus];
    self.timer_one_minute = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(doRequestBus) userInfo:nil repeats:YES];
    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [self.timer_one_minute invalidate];
}
- (void)doRequestBus{
    [self displayLoading];
    [TEAppDelegate getApplicationDelegate].networkHandler.delegate_oneLineDetail = self;
    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_oneLineDtail:self.linename :self.stationName];
}
- (void)removeLayout{
    NSArray *views = [self.scrollview_station subviews];
    for(UIView* view in views)
    {
        [view removeFromSuperview];
    }
    [busInfoDic removeAllObjects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button_back_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (int)getIndexAtStationList:(NSString*)name{
    int i=0;
    for(i=0;i<[self.stationList count];i++){
        if([name isEqualToString:[[self.stationList objectAtIndex:i] objectForKey:@"name"]]){
            break;
        }
    }
    return i;
}
- (void)initLayout{
    //重置上半部分的信息
    
    NSArray* array = [self.linename componentsSeparatedByString:@"("];
    self.label_line_no.text = [array objectAtIndex:0];
    NSString *line_direction = [[array objectAtIndex:1] stringByReplacingOccurrencesOfString:@")" withString:@""];
    self.label_start.text = line_direction;
    if([[self.nearestbus allKeys] count]>0){
        NSString* stationamount = [self.nearestbus objectForKey:@"stationamount"];
        float distance = [[self.nearestbus objectForKey:@"stationdist"] intValue]/1000.0;
        NSString* stationarrtime = [self.nearestbus objectForKey:@"stationarrtime"];
        self.label_nearest_bus.text = [NSString stringWithFormat:@"距%@站%@站%.1f公里%@分钟到达",self.stationName,stationamount,distance,stationarrtime];
    }else{
        self.label_nearest_bus.text = [NSString stringWithFormat:@"暂时没有查询到距%@站最近的公交车信息",self.stationName];
    }
    //清空当前subview
    [self removeLayout];
    int i = 0;
    //处理一下buslist，算一下位置
    for(i=0;i<[self.busList count];i++){
        NSDictionary* onebus = [self.busList objectAtIndex:i];
        int index = [self getIndexAtStationList:[onebus objectForKey:@"preStation"]];
        NSString* index_key = [NSString stringWithFormat:@"%i",index];
        TEOneStationHasBus* oneStationHasBus = [self.busInfoDic objectForKey:index_key];
        if(oneStationHasBus == nil){//已经有过对应index的dic了
            oneStationHasBus = [[TEOneStationHasBus alloc]init];
            oneStationHasBus.arrivalBuses = [[NSMutableArray alloc]init];
            oneStationHasBus.justLeaveBuses = [[NSMutableArray alloc]init];
            [self.busInfoDic setObject:oneStationHasBus forKey:index_key];
        }
        NSString* travelstatus = [onebus objectForKey:@"travelstatus"];
        if([travelstatus isEqualToString:@"1"]){
            [oneStationHasBus.arrivalBuses addObject:onebus];
        }else{
            [oneStationHasBus.justLeaveBuses addObject:onebus];
        }
    }
    
    //算一下需要几根线
    int lineCount = 45*[self.stationList count]/22+1;
    int line_inity = 39;
    for(i=0;i<lineCount;i++){
        UIImageView* imageView_line = [[UIImageView alloc]initWithFrame:CGRectMake(178+7-1, line_inity+i*22, 4.5,22)];
        imageView_line.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"bus_dot_line" ofType:@"png"]];
        [self.scrollview_station addSubview:imageView_line];
    }
    
    int y_used = 10;
    
    for(i = 0;i<[self.stationList count];i++){
        NSString* station_pic_name = @"station2";
        if([[[self.stationList objectAtIndex:i] objectForKey:@"name"] isEqualToString:self.stationName]){
            self.y_interestStation = y_used-45;
            station_pic_name = @"station1";
        }
        UILabel* label_station = [[UILabel alloc]initWithFrame:CGRectMake(20, y_used, 140, 40)];
        label_station.textAlignment = NSTextAlignmentRight;
        label_station.backgroundColor = [UIColor clearColor];
        label_station.textColor = [UIColor colorWithRed:173.0/255 green:173.0/255 blue:173.0/255 alpha:1];
        label_station.font = [UIFont systemFontOfSize:18];
        label_station.text = [[self.stationList objectAtIndex:i]objectForKey:@"name"];
        [self.scrollview_station addSubview:label_station];
        
        UIImageView* imageView_station = [[UIImageView alloc]initWithFrame:CGRectMake(178, y_used+11, 18,18)];
        imageView_station.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:station_pic_name ofType:@"png"]];
        [self.scrollview_station addSubview:imageView_station];
        
        UILabel* label_station_num = [[UILabel alloc]initWithFrame:CGRectMake(178, y_used+11, 18,18)];
        label_station_num.textAlignment = NSTextAlignmentCenter;
        label_station_num.backgroundColor = [UIColor clearColor];
        label_station_num.textColor = [UIColor whiteColor];
        label_station_num.font = [UIFont systemFontOfSize:14];
        label_station_num.text = [NSString stringWithFormat:@"%i",(i+1)];
        [self.scrollview_station addSubview:label_station_num];
        
        
        
        
        //加上bus的标记
        TEOneStationHasBus* oneStationHasBus = [self.busInfoDic objectForKey:[NSString stringWithFormat:@"%i",i]];
        if(oneStationHasBus!=nil){
            if([oneStationHasBus.arrivalBuses count]>0){//加上一个到站图标
                NSString* picname = @"";
                if([[[oneStationHasBus.arrivalBuses objectAtIndex:0]objectForKey:@"preStation"] isEqualToString:self.stationName]){
                    picname = @"arrival";
                }else{
                    picname = @"arrival2";
                }
                UIButton* button_status1 = [UIButton buttonWithType:UIButtonTypeCustom];
                [button_status1 setBackgroundImage:[UIImage imageNamed:picname] forState:UIControlStateNormal];
                [button_status1 setFrame:CGRectMake(211, y_used+2 , 76, 36)];
                [button_status1 setTag:1000+i];
                [button_status1 addTarget:self action:@selector(button_bus_clicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.scrollview_station addSubview:button_status1];
            }
            if([oneStationHasBus.justLeaveBuses count]>0){//加上一个途中图标
                UIButton* button_status2 = [UIButton buttonWithType:UIButtonTypeCustom];
                [button_status2 setBackgroundImage:[UIImage imageNamed:@"middle"] forState:UIControlStateNormal];
                [button_status2 setFrame:CGRectMake(211, y_used+32 , 34, 26)];
                [button_status2 setTag:i];
                [button_status2 addTarget:self action:@selector(button_bus_clicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.scrollview_station addSubview:button_status2];
            }
        }
        
        y_used += 45;
        
    }
    self.scrollview_station.contentSize = CGSizeMake(320, y_used+10);
}
- (void)button_bus_clicked:(id)sender{
    [self.bubbleView removeFromSuperview];
    int tag = [(UIButton*)sender tag];
    NSMutableArray* busArray = [[NSMutableArray alloc]init];
    int bubble_y = 0;
    if(tag>=1000){//到站的
        NSString* index_key = [NSString stringWithFormat:@"%i",tag-1000];
        TEOneStationHasBus* oneStationHasBus = [self.busInfoDic objectForKey:index_key];
        busArray = oneStationHasBus.arrivalBuses;
        bubble_y = 10+(tag-1000)*45+2+40;
    }else{
        NSString* index_key = [NSString stringWithFormat:@"%i",tag];
        TEOneStationHasBus* oneStationHasBus = [self.busInfoDic objectForKey:index_key];
        busArray = oneStationHasBus.justLeaveBuses;
        bubble_y = 10+tag*45+32+30;
    }
    if([busArray count] == 1){
        NSString* des = @"";
        if(tag>=1000){
            des = @"车辆1  即将到站";
        }else{
            NSDictionary* dic1 = [busArray objectAtIndex:0];
            des = [NSString stringWithFormat:@"车辆1,距下一站%@米 预计%@分钟到达",[dic1 objectForKey:@"nextStationDist"],[dic1 objectForKey:@"nextStationArrTime"]];
        }
        self.bubbleView = [[UIView alloc]initWithFrame:CGRectMake(35, bubble_y, 260, 42)];
        UIImageView* imageView_status1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 260, 42)];
        imageView_status1.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"line1" ofType:@"png"]];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleOnClick:)];
        imageView_status1.userInteractionEnabled=YES;
        [imageView_status1 addGestureRecognizer:singleTap];
        [self.bubbleView addSubview:imageView_status1];
        
        UILabel* label1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 250, 30)];
        label1.textAlignment = NSTextAlignmentLeft;
        label1.backgroundColor = [UIColor clearColor];
        label1.textColor = [UIColor whiteColor];
        label1.font = [UIFont systemFontOfSize:14];
        label1.text = des;
        [self.bubbleView addSubview:label1];
        
        [self.scrollview_station addSubview:self.bubbleView];
    }else if([busArray count] > 1){
        NSString* des1 = @"";
        NSString* des2 = @"";
        if(tag>=1000){
            des1 = @"车辆1  即将到站";
            des2 = @"车辆2  即将到站";
        }else{
            NSDictionary* dic1 = [busArray objectAtIndex:0];
            des1 = [NSString stringWithFormat:@"车辆1,距下一站%@米 预计%@分钟到达",[dic1 objectForKey:@"nextStationDist"],[dic1 objectForKey:@"nextStationArrTime"]];
            NSDictionary* dic2 = [busArray objectAtIndex:1];
            des2 = [NSString stringWithFormat:@"车辆2,距下一站%@米 预计%@分钟到达",[dic2 objectForKey:@"nextStationDist"],[dic2 objectForKey:@"nextStationArrTime"]];
        }
        self.bubbleView = [[UIView alloc]initWithFrame:CGRectMake(35, bubble_y, 260, 56)];
        UIImageView* imageView_status1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 260, 56)];
        imageView_status1.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"line2" ofType:@"png"]];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleOnClick:)];
        imageView_status1.userInteractionEnabled=YES;
        [imageView_status1 addGestureRecognizer:singleTap];
        [self.bubbleView addSubview:imageView_status1];
        
        UILabel* label1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 4, 250, 22)];
        label1.textAlignment = NSTextAlignmentLeft;
        label1.backgroundColor = [UIColor clearColor];
        label1.textColor = [UIColor whiteColor];
        label1.font = [UIFont systemFontOfSize:14];
        label1.text = des1;
        [self.bubbleView addSubview:label1];
        
        UILabel* label2 = [[UILabel alloc]initWithFrame:CGRectMake(5, 30, 250, 22)];
        label2.textAlignment = NSTextAlignmentLeft;
        label2.backgroundColor = [UIColor clearColor];
        label2.textColor = [UIColor whiteColor];
        label2.font = [UIFont systemFontOfSize:14];
        label2.text = des2;
        [self.bubbleView addSubview:label2];
        
        [self.scrollview_station addSubview:self.bubbleView];
    }
}
-(void)bubbleOnClick:(UITapGestureRecognizer *)view
{
    [self.bubbleView removeFromSuperview];
}
- (IBAction)displayInMap:(id)sender {
    TEBusMapViewController* busMapVC = [[TEBusMapViewController alloc]init];
    busMapVC.linename = self.linename;
    busMapVC.stationName = self.stationName;
    [self.navigationController pushViewController:busMapVC animated:YES];
}
#pragma mark- oneline detail delegate
- (void)oneLineDetailDidFailed{
    [self hideLoading];
}
- (void)oneLineDetailDidSuccess:(NSDictionary *)busInfo{
    //    NSLog(@"busInfo is %@",busInfo);
    [self hideLoading];
    NSString* status = [busInfo objectForKey:@"status"];
    if([@"200" isEqual:status]){
        self.stationList = [busInfo objectForKey:@"stationlist"];
        self.busList = [busInfo objectForKey:@"buslist"];
        if([self.busList count] == 0){
            [self.view makeToast:@"暂无该线路实时数据"];
        }
        self.nearestbus = [busInfo objectForKey:@"nearestbus"];
        [self initLayout];
        [self.scrollview_station setContentOffset:CGPointMake(0, y_interestStation) animated:YES];
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"没有查询到相关数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
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
    self.button_map.enabled = NO;
}
- (void)enableAllButton{
    self.button_back.enabled = YES;
    self.button_map.enabled = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}

@end
