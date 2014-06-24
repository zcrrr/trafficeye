//
//  TEOrderCarViewController.m
//  Trafficeye_new
//
//  Created by zc on 14-5-7.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "TEOrderCarViewController.h"
#import "TEReportPoint.h"
#import "Toast+UIView.h"
#import "TEPersistenceHandler.h"
#import "PlaySound.h"

@interface TEOrderCarViewController ()

@end

@implementation TEOrderCarViewController
@synthesize carID;
@synthesize locationManager;
@synthesize recordPointList;
@synthesize startTime;
@synthesize lastTime;
@synthesize xulie_end;
@synthesize lastLocation;

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
    
    NSString* uid = [[TEAppDelegate getApplicationDelegate] getUid];
    NSString* str_url = [NSString stringWithFormat:@"%@/vehicleManage/v1/loadPage?uid=%@",ENDPOINTS,uid];
    NSLog(@"url is%@",str_url);
    NSURL* url = [NSURL URLWithString:str_url];
    [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
    self.webview.scalesPageToFit = YES;
    self.webview.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//接收js的调用，跟2个参数
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *requestURL = [request URL];
    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] || [ [ requestURL scheme ] isEqualToString: @"https" ] || [ [ requestURL scheme ] isEqualToString: @"mailto" ])
        && ( navigationType == UIWebViewNavigationTypeLinkClicked ) ) {
        return ![ [ UIApplication sharedApplication ] openURL: requestURL];
    }
    
    NSString *urlString = [[request URL] absoluteString];
    NSLog(@"js返回url是%@",urlString);
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    
    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"objc"])
    {
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps objectAtIndex:1] componentsSeparatedByString:@":/"];
        NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
        
        if (1 == [arrFucnameAndParameter count])
        {
            // 没有参数
            if([funcStr isEqualToString:@"goBack"])
            {
                /*调用本地函数1*/
                DDMenuController *menuController = [TEAppDelegate getApplicationDelegate].menuController;
                [menuController showLeftController:YES];
            }
        }
        else
        {
            if([funcStr isEqualToString:@"isUploadData:"])
            {
                int status = [[arrFucnameAndParameter objectAtIndex:1]intValue];
                self.carID = [arrFucnameAndParameter objectAtIndex:2];
                NSLog(@"status is %i,carID is %@",status,carID);
                if(status == 0){
                    NSLog(@"开始上报");
                    if([self.recordPointList count] == 0){
                        [self startUploadLocation];
                    }
                    
                }else{
                    [self stopUploadLocation];
                    NSLog(@"结束上报");
                }
            }
        }
    }
    return YES;
}
- (void)startUploadLocation{
//    [self appendStringToPlist:@"开始上报"];
    if([CLLocationManager locationServicesEnabled]){
        
        self.recordPointList = [[NSMutableArray alloc]init];
        self.startTime = 0;
        self.lastTime = 0;
        self.xulie_end = YES;
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
    }
}
- (void)stopUploadLocation{
//    [self appendStringToPlist:@"结束上报"];
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
    if([self.recordPointList count]<1){
        self.locationManager = nil;
        [self.locationManager stopUpdatingLocation];
        return;
    }
    
    int distance = 0;
    NSMutableString* xulie = [[NSMutableString alloc]initWithString:@""];
    for(int i = 0;i<[self.recordPointList count];i++){
        TEReportPoint* p = [self.recordPointList objectAtIndex:i];
        //                [self writeLog:[p printMe]];
        distance += p.disFromLastPoint;
        if(p.is_start) {
            [xulie appendString:[NSString stringWithFormat:@"S;%@,%i,%i,%i,%i,%i,%i,-1;",p.data,p.lon,p.lat,p.alt,p.bearing,p.speed,p.accuracy]];
        }else{
            TEReportPoint* lastPoint = [self.recordPointList objectAtIndex:i-1];
            [xulie appendString:[NSString stringWithFormat:@"0,%i,%i,%i,%i,%i,%i,-1;",(p.lon - lastPoint.lon),(p.lat - lastPoint.lat),(p.alt - lastPoint.alt),p.bearing,p.speed,p.accuracy]];
        }
    }
    [self.recordPointList removeAllObjects];
    //上报该次字符串
    //            NSString* uid = [[TEAppDelegate getApplicationDelegate] getUid];
    //            if(!uid)uid = @"-1";
    
    NSString* head = [NSString stringWithFormat:@"v1,iOS,-1,3,10,%i;",distance];
    NSString* reportString = [NSString stringWithFormat:@"%@%@",head,xulie];
    [self.view makeToast:@"约车上报！！！！！！"];
    [PlaySound play];
    [TEAppDelegate getApplicationDelegate].networkHandler.delegate_ordercar = self;
    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_ordercar:reportString :carID];
//    [self appendStringToPlist:[NSString stringWithFormat:@"上报一段数据：%@",reportString]];
    startTime = 0;
    xulie_end = YES;
}
#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation* newLocation = [locations lastObject];
    NSLog(@"new location is %@",newLocation);
    int rank;
    if (newLocation.horizontalAccuracy > 200)
    rank = 0;
    else if (newLocation.horizontalAccuracy > 160)
    rank = 1;
    else if (newLocation.horizontalAccuracy > 120)
    rank = 2;
    else if (newLocation.horizontalAccuracy > 80)
    rank = 3;
    else if (newLocation.horizontalAccuracy > 50)
    rank = 4;
    else rank = 5;
    if(rank > 0){
        //得到日期字符串
        NSString *dataString = [self stringFromDate:newLocation.timestamp];
        long time = [TEUtil getNowTime]*1000;
        int lat = newLocation.coordinate.latitude*1000000;
        int lon = newLocation.coordinate.longitude*1000000;
        int alt = newLocation.altitude;
        int bearing = newLocation.course;
        int speed = newLocation.speed;
        int acc = rank;
        if(startTime != 0 && (time - startTime) >= 180000){
            if((time - lastTime) > 60000){
                //如果要上报的时候，得到的点，与队列里最新的点的时间间隔太大了，一样抛弃整个队列
                //                [self writeLog:@"超过3分钟的队列，但是得到的点与上一个点间隔太大了，抛弃~"];
                [self.recordPointList removeAllObjects];
                xulie_end = YES;
                startTime = 0;
                return;
            }
            //大于三分钟
            int distance = 0;
            NSMutableString* xulie = [[NSMutableString alloc]initWithString:@""];
            for(int i = 0;i<[self.recordPointList count];i++){
                TEReportPoint* p = [self.recordPointList objectAtIndex:i];
                //                [self writeLog:[p printMe]];
                distance += p.disFromLastPoint;
                if(p.is_start) {
                    [xulie appendString:[NSString stringWithFormat:@"S;%@,%i,%i,%i,%i,%i,%i,-1;",p.data,p.lon,p.lat,p.alt,p.bearing,p.speed,p.accuracy]];
                }else{
                    TEReportPoint* lastPoint = [self.recordPointList objectAtIndex:i-1];
                    [xulie appendString:[NSString stringWithFormat:@"0,%i,%i,%i,%i,%i,%i,-1;",(p.lon - lastPoint.lon),(p.lat - lastPoint.lat),(p.alt - lastPoint.alt),p.bearing,p.speed,p.accuracy]];
                }
            }
            [self.recordPointList removeAllObjects];
            //上报该次字符串
            //            NSString* uid = [[TEAppDelegate getApplicationDelegate] getUid];
            //            if(!uid)uid = @"-1";
            
            NSString* head = [NSString stringWithFormat:@"v1,iOS,-1,3,10,%i;",distance];
            NSString* reportString = [NSString stringWithFormat:@"%@%@",head,xulie];
            if(distance > 50){//大于50米才上报
                [self.view makeToast:@"约车上报！！！！！！"];
                [PlaySound play];
                [TEAppDelegate getApplicationDelegate].networkHandler.delegate_ordercar = self;
                [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_ordercar:reportString :carID];
//                [self appendStringToPlist:[NSString stringWithFormat:@"上报一段数据：%@",reportString]];
            }
            startTime = 0;
            xulie_end = YES;
        }else{
            if(xulie_end){//刚开始或者一个s结束
                //直接进队列
                //                [self writeLog:@"刚开始或者一个s结束，进队列"];
                TEReportPoint* rp = [[TEReportPoint alloc]init];
                [rp initValue:dataString :time :lon :lat :alt :bearing :speed :acc :YES];
                if([self.recordPointList count] == 0){
                    rp.disFromLastPoint = 0;
                    startTime = time;
                }else{
                    rp.disFromLastPoint = [newLocation distanceFromLocation:lastLocation];
                }
                [self.recordPointList addObject:rp];
                lastLocation = newLocation;
                lastTime = time;
                xulie_end = NO;
            }else{
                long duringTime = time - lastTime;
                if(duringTime >= 9000 && duringTime <= 11000){//间隔在10秒左右
                    //                    [self writeLog:@"不是开始，进队列"];
                    TEReportPoint* rp = [[TEReportPoint alloc]init];
                    [rp initValue:dataString :time :lon :lat :alt :bearing :speed :acc :NO];
                    rp.disFromLastPoint = [newLocation distanceFromLocation:lastLocation];
                    [self.recordPointList addObject:rp];
                    lastLocation = newLocation;
                    lastTime = time;
                }else if(duringTime > 10000 && duringTime < 60000){
                    xulie_end = YES;//该序列结束，下一秒如果是有效点可以进入队列
                    //                    [self writeLog:@"下一个有效点时间间隔比较长，结束一个序列"];
                }else if(duringTime >= 60000){//放弃整个队列
                    //                    [self writeLog:@"放弃整个队列"];
                    [self.recordPointList removeAllObjects];
                    xulie_end = YES;
                    startTime = 0;
                }
            }
        }
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"--------------error:%@",[error localizedFailureReason]);
}
- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd-HH-mm-ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}
- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}
- (void)OrdercarDidSuccess:(NSString *)result{
//    [self appendStringToPlist:[NSString stringWithFormat:@"服务器返回：%@",result]];
}
//- (void)appendStringToPlist:(NSString *)str{
//    NSDate * senddate=[NSDate date];
//    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"HH:mm"];
//    NSString * locationString=[dateformatter stringFromDate:senddate];
//    NSString *stringToWrite;
//    NSString* filePath = [TEPersistenceHandler getDocument:@"ordercar.plist"];
//    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
//    stringToWrite = [dic valueForKey:@"userLog"];
//    if(!stringToWrite){
//        stringToWrite = @"";
//    }
//    stringToWrite = [NSString stringWithFormat:@"%@\n%@:%@",stringToWrite,locationString,str];
//    NSLog(@"stringtowrite is %@",stringToWrite);
//    NSMutableDictionary* dic2 = [[NSMutableDictionary alloc ]init];
//    [dic2 setValue:stringToWrite forKey:@"userLog"];
//    [dic2 writeToFile:filePath atomically:YES];
//}
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
