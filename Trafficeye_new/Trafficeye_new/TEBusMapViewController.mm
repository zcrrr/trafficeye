//
//  TEBusMapViewController.m
//  Trafficeye_new
//
//  Created by zc on 14-5-12.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "TEBusMapViewController.h"
#import "CNMapKit.h"
#import "TEBusStationAnno.h"
#import "TEBusStationAnnoView.h"
#import "TEBusBubbleView.h"

@interface TEBusMapViewController ()

@end

@implementation TEBusMapViewController
@synthesize mapView;
@synthesize linename;
@synthesize stationName;
@synthesize stationList;
@synthesize pointsString;
@synthesize polyline;
@synthesize anno4remove;
@synthesize busList;
@synthesize busBubbleAnno;

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
    if(iPhone5){
        self.mapView = [[CNMKMapView alloc] initWithFrame:CGRectMake(0, 0+IOS7OFFSIZE+44, 320, 503)];
    }else{
        self.mapView = [[CNMKMapView alloc] initWithFrame:CGRectMake(0, 0+IOS7OFFSIZE+44, 320, 415)];
    }
    [self.mapView setMapType:CNMKMapTypeStandard];
//    [self.mapView setShowsUserLocation:YES];
    self.mapView.delegate = self;
    [self.mapView setZoomLevel:12];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.loadingImage];
    [self.view addSubview:self.indicator];
    
    anno4remove = [[NSMutableArray alloc]init];
    self.busBubbleAnno = [[TEBusBubbleAnno alloc]init];
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
    self.mapView.delegate = nil;
}
- (void)doRequestBus{
    [self displayLoading];
    [TEAppDelegate getApplicationDelegate].networkHandler.delegate_oneLineDetail = self;
    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_oneLineDtail:self.linename :self.stationName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)removeMapFeature{
    [self.mapView removeAnnotation:self.busBubbleAnno];
    [self.mapView removeOverlay:self.polyline];
    [self.mapView removeAnnotations:self.anno4remove];
    [self.anno4remove removeAllObjects];
}
- (void)displayBus{
    //先删除地图上的已有的元素
    [self removeMapFeature];
    //线路
    NSArray *lonlats = [self.pointsString componentsSeparatedByString:@";"];
    int i = 0;
    int pts_size = [lonlats count]-1;//最后多一个;所以最后一个是空的
    CNMKGeoPoint* geoPoints = new CNMKGeoPoint[pts_size];
    for(i=0;i<pts_size;i++){
        NSArray* lonlat =  [[lonlats objectAtIndex:i] componentsSeparatedByString:@","];
        double lon = [[lonlat objectAtIndex:0]doubleValue];
        double lat = [[lonlat objectAtIndex:1]doubleValue];
        CNMKGeoPoint point = CNMKGeoPointMake(lon, lat);
        geoPoints[i] = point;
    }
    self.polyline = [CNMKPolyline polylineWithGeoPoints:geoPoints count:pts_size];
    self.polyline.encrypted = YES;
    [self.mapView addOverlay:self.polyline];
    
    //车站
    for(i=0;i<[self.stationList count];i++){
        TEBusStationAnno* stationAnno = [[TEBusStationAnno alloc]init];
        stationAnno.encrypted = YES;
        double lon = [[[self.stationList objectAtIndex:i]objectForKey:@"lon"]doubleValue];
        double lat = [[[self.stationList objectAtIndex:i]objectForKey:@"lat"]doubleValue];
        CNMKGeoPoint point = CNMKGeoPointMake(lon, lat);
        stationAnno.coordinate = point;
        stationAnno.index = i;
        stationAnno.title = @"station";
        [self.mapView addAnnotation:stationAnno];
        [self.anno4remove addObject:stationAnno];
        if([self.stationName isEqualToString:[[self.stationList objectAtIndex:i]objectForKey:@"name"]]){
            [self.mapView setCenterCoordinate:point animated:YES];
        }
    }
    //车
    for(i=0;i<[self.busList count];i++){
        TEBusStationAnno* stationAnno = [[TEBusStationAnno alloc]init];
        stationAnno.encrypted = YES;
        double lon = [[[self.busList objectAtIndex:i]objectForKey:@"lon"]doubleValue];
        double lat = [[[self.busList objectAtIndex:i]objectForKey:@"lat"]doubleValue];
        CNMKGeoPoint point = CNMKGeoPointMake(lon, lat);
        stationAnno.coordinate = point;
        stationAnno.title = @"bus";
        stationAnno.index = i;
        [self.mapView addAnnotation:stationAnno];
        [self.anno4remove addObject:stationAnno];
    }
}
- (CNMKOverlayView *)mapView:(CNMKMapView *)mapView viewForOverlay:(id <CNMKOverlay>)overlay
{
	if ([overlay isKindOfClass:[CNMKPolyline class]])
    {
        CNMKPolylineView* polylineView = [[CNMKPolylineView alloc]initWithOverlay:overlay];
		polylineView.lineWidth = 5.0;
		return polylineView;
    }
    return nil;
}
- (CNMKAnnotationView *)mapView:(CNMKMapView *)mapView viewForAnnotation:(id <CNMKAnnotationOverlay>)annotation
{
    //    NSLog(@"view for annotation------");
   if ([annotation isKindOfClass:[TEBusStationAnno class]]){
       TEBusStationAnno* anno = annotation;
       if([anno.title isEqualToString:@"station"]){
           TEBusStationAnnoView* stationAnnoView = [[TEBusStationAnnoView alloc]initWithOverlay:anno];
           NSString* name = [[self.stationList objectAtIndex:anno.index] objectForKey:@"name"];
           if(anno.index == 0){//起点
               [stationAnnoView setFrame:CGRectMake(0, 0, 22,32 )];
               stationAnnoView.tag = 2345;
               UIImageView* imageView_bunbble = [[UIImageView alloc]init];
               imageView_bunbble.image = [UIImage imageNamed:@"bus_start.png"];
               stationAnnoView.imageView_annotation = imageView_bunbble;
               UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stationOnClick:)];
               imageView_bunbble.userInteractionEnabled=YES;
               [imageView_bunbble addGestureRecognizer:singleTap];
               singleTap.view.tag = anno.index;
           }else if(anno.index == [self.stationList count]-1){//终点
               [stationAnnoView setFrame:CGRectMake(0, 0, 22,32 )];
               stationAnnoView.tag = 2345;
               UIImageView* imageView_bunbble = [[UIImageView alloc]init];
               imageView_bunbble.image = [UIImage imageNamed:@"bus_end.png"];
               stationAnnoView.imageView_annotation = imageView_bunbble;
               UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stationOnClick:)];
               imageView_bunbble.userInteractionEnabled=YES;
               [imageView_bunbble addGestureRecognizer:singleTap];
               singleTap.view.tag = anno.index;
               
           }else{
               NSString* picname = @"";
               if([self.stationName isEqualToString:name]){//不是起点不是终点，是查询的站
                   picname = @"bus_me.png";
                   stationAnnoView.tag = 1234;
               }else{
                   picname = @"bus_station.png";
               }
               [stationAnnoView setFrame:CGRectMake(0, 0, 22,22 )];
               stationAnnoView.index = anno.index+1;
               UIImageView* imageView_bunbble = [[UIImageView alloc]init];
               UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stationOnClick:)];
               imageView_bunbble.userInteractionEnabled=YES;
               [imageView_bunbble addGestureRecognizer:singleTap];
               singleTap.view.tag = anno.index;
               imageView_bunbble.image = [UIImage imageNamed:picname];
               stationAnnoView.imageView_annotation = imageView_bunbble;
           }
           
           return stationAnnoView;
       }else if([anno.title isEqualToString:@"bus"]){
           TEBusStationAnnoView* stationAnnoView = [[TEBusStationAnnoView alloc]initWithOverlay:anno];
           [stationAnnoView setFrame:CGRectMake(0, 0, 22,22 )];
           stationAnnoView.tag = 1234;
           UIImageView* imageView_bunbble = [[UIImageView alloc]init];
           UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(busOnClick:)];
           imageView_bunbble.userInteractionEnabled=YES;
           [imageView_bunbble addGestureRecognizer:singleTap];
           singleTap.view.tag = anno.index;
           imageView_bunbble.image = [UIImage imageNamed:@"bus_bus.png"];
           stationAnnoView.imageView_annotation = imageView_bunbble;
           return stationAnnoView;
       }
   }else if ([annotation isKindOfClass:[TEBusBubbleAnno class]]){
       TEBusBubbleAnno* anno = annotation;
       if([anno.title isEqualToString:@"station_bubble"]){
           TEBusBubbleView* stationBubbleView = [[TEBusBubbleView alloc]initWithOverlay:anno];
           [stationBubbleView setFrame:CGRectMake(0, 0, 183,57 )];
           stationBubbleView.tag = 1;
           NSString* name = [[self.stationList objectAtIndex:anno.index]objectForKey:@"name"];
           stationBubbleView.text1 = name;
           UIImageView* imageView_bunbble = [[UIImageView alloc]init];
           UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleOnClick:)];
           imageView_bunbble.userInteractionEnabled=YES;
           [imageView_bunbble addGestureRecognizer:singleTap];
           imageView_bunbble.image = [UIImage imageNamed:@"bus_short_bubble.png"];
           stationBubbleView.imageView_annotation = imageView_bunbble;
           return stationBubbleView;
       }else{
           TEBusBubbleView* stationBubbleView = [[TEBusBubbleView alloc]initWithOverlay:anno];
           [stationBubbleView setFrame:CGRectMake(0, 0, 210,57 )];
           stationBubbleView.tag = 2;
           NSString* nextStation = [[self.busList objectAtIndex:anno.index]objectForKey:@"nextStation"];
           stationBubbleView.text1 = [NSString stringWithFormat:@"距‘%@’站",nextStation];
           NSString* travelstatus = [[self.busList objectAtIndex:anno.index]objectForKey:@"travelstatus"];
           if([travelstatus isEqualToString:@"1"]){
               stationBubbleView.text2 = @"即将到站";
           }else{
               NSString* munite = [[self.busList objectAtIndex:anno.index]objectForKey:@"nextStationArrTime"];
               NSString* distance = [[self.busList objectAtIndex:anno.index]objectForKey:@"nextStationDist"];
               stationBubbleView.text2 = [NSString stringWithFormat:@"约%@米 预计%@分钟后到站",distance,munite];
           }
           
           
           UIImageView* imageView_bunbble = [[UIImageView alloc]init];
           UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleOnClick:)];
           imageView_bunbble.userInteractionEnabled=YES;
           [imageView_bunbble addGestureRecognizer:singleTap];
           imageView_bunbble.image = [UIImage imageNamed:@"bus_long_bubble.png"];
           stationBubbleView.imageView_annotation = imageView_bunbble;
           return stationBubbleView;
       }
   }
    
    return nil;
}
-(void)stationOnClick:(UITapGestureRecognizer *)view
{
    [self.mapView removeAnnotation:self.busBubbleAnno];
    int tag = view.view.tag;
    NSLog(@"tag is %@",[[self.stationList objectAtIndex:tag]objectForKey:@"name"]);
    self.busBubbleAnno.encrypted = YES;
    double lon = [[[self.stationList objectAtIndex:tag]objectForKey:@"lon"]doubleValue];
    double lat = [[[self.stationList objectAtIndex:tag]objectForKey:@"lat"]doubleValue];
    CNMKGeoPoint point = CNMKGeoPointMake(lon, lat);
    [self.mapView setCenterCoordinate:point animated:YES];
    self.busBubbleAnno.coordinate = point;
    self.busBubbleAnno.title = @"station_bubble";
    self.busBubbleAnno.index = tag;
    [self.mapView addAnnotation:busBubbleAnno];
}
-(void)busOnClick:(UITapGestureRecognizer *)view
{
    [self.mapView removeAnnotation:self.busBubbleAnno];
    int tag = view.view.tag;
    NSLog(@"tag is %@",[[self.busList objectAtIndex:tag]objectForKey:@"preStation"]);
    self.busBubbleAnno.encrypted = YES;
    double lon = [[[self.busList objectAtIndex:tag]objectForKey:@"lon"]doubleValue];
    double lat = [[[self.busList objectAtIndex:tag]objectForKey:@"lat"]doubleValue];
    CNMKGeoPoint point = CNMKGeoPointMake(lon, lat);
    [self.mapView setCenterCoordinate:point animated:YES];
    self.busBubbleAnno.coordinate = point;
    self.busBubbleAnno.title = @"bus_bubble";
    self.busBubbleAnno.index = tag;
    [self.mapView addAnnotation:busBubbleAnno];
}
-(void)bubbleOnClick:(UITapGestureRecognizer *)view
{
    [self.mapView removeAnnotation:self.busBubbleAnno];
}
- (IBAction)button_back_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
        self.pointsString = [busInfo objectForKey:@"linepointlist"];
        self.busList = [busInfo objectForKey:@"buslist"];
        [self displayBus];
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
}
- (void)enableAllButton{
    self.button_back.enabled = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}

@end
