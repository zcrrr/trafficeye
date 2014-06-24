//
//  TEUploadLocation.m
//  Trafficeye_new
//
//  Created by zc on 14-2-12.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "TEUploadLocation.h"
#import "TEReportPoint.h"
#import "TEPersistenceHandler.h"

@implementation TEUploadLocation
@synthesize locationManager;
@synthesize recordPointList;
@synthesize startTime;
@synthesize lastTime;
@synthesize xulie_end;
@synthesize lastLocation;
@synthesize userLocation_lat;
@synthesize userLocation_lon;

- (void)startUploadLocation{
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

#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation* newLocation = [locations lastObject];
    self.userLocation_lat = newLocation.coordinate.latitude;
    self.userLocation_lon = newLocation.coordinate.longitude;
    //判断是否向交通眼的服务器注册了推送token，没有的话就注册
    if([TEAppDelegate getApplicationDelegate].needRegisterPush){
        //向服务器注册：
        NSLog(@"向服务器注册");
        NSString *cityname = [TEUtil cityNameByLocation:self.userLocation_lon :self.userLocation_lat];
        [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_registerPush:[TEAppDelegate getApplicationDelegate].pushToken :cityname];
        [TEAppDelegate getApplicationDelegate].needRegisterPush = NO;
    }
    
    
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
//        NSLog(@"这次的坐标的信息：%@,%li,%i,%i,%i,%i,%i,%i",dataString,time,lat,lon,alt,bearing,speed,acc);
//        [self writeLog:[NSString stringWithFormat:@"得到一个有效点:%@,%li,%i,%i,%i,%i,%i,%i",dataString,time,lat,lon,alt,bearing,speed,acc]];
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
                //这里调用接口上报
//                UIAlertView* alert =[[UIAlertView alloc] initWithTitle:nil message:@"上报了！！！！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
                [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_uploadLocation:reportString];
            }
//            [self writeLog:[NSString stringWithFormat:@"满3分钟，上报数据，上报的字符串：%@",reportString]];
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


//测试使用
- (void)writeLog:(NSString *) content{
    NSLog(@"写文件:%@",content);
    NSString* filePath = [self getDocument:@"userReportLocation.plist"];
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSString *record_now = [dic valueForKey:@"record"];
    //    NSLog(@"record now is %@",record_now);
    NSMutableDictionary* dic_new = [[NSMutableDictionary alloc ]init];
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    date = [formatter stringFromDate:[NSDate date]];
    NSString* intStr = [NSString stringWithFormat:@"%@\n%@  %@\n", record_now,date,content];
    [dic_new setValue:intStr forKey:@"record"];
    //TODO：需要持久化
    [dic_new writeToFile:filePath atomically:YES];
}
- (NSString*)getDocument:(NSString *)fileName
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
	NSString *document = [paths objectAtIndex:0];
	NSString *path = [document stringByAppendingPathComponent:fileName];
	return path;
}
@end
