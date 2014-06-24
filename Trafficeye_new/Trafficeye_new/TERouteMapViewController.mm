//
//  TERouteMapViewController.m
//  Trafficeye_new
//
//  Created by zc on 14-6-12.
//  Copyright (c) 2014年 张 驰. All rights reserved.
//

#import "TERouteMapViewController.h"
#import "TEBusStationAnnoView.h"
#import "TEBusStationAnno.h"
#import "SBJson.h"
#import "CNMapKit.h"
#import "Toast+UIView.h"
#import "TERoutePolyline.h"

@interface TERouteMapViewController ()

@end

@implementation TERouteMapViewController
@synthesize mapView;
@synthesize startLat;
@synthesize startLon;
@synthesize endLat;
@synthesize endLon;
@synthesize routeJSON;
@synthesize pageType;
@synthesize anno4remove;
@synthesize polylineList;

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
        self.mapView = [[CNMKMapView alloc] initWithFrame:CGRectMake(0, 0+IOS7OFFSIZE+45, 320, 503)];
    }else{
        self.mapView = [[CNMKMapView alloc] initWithFrame:CGRectMake(0, 0+IOS7OFFSIZE+45, 320, 415)];
    }
    [self.mapView setMapType:CNMKMapTypeStandard];
    [self.mapView setShowsUserLocation:YES];
    self.mapView.delegate = self;
    [self.mapView setZoomLevel:12];
    [self.view addSubview:self.mapView];
    [self.view sendSubviewToBack:mapView];
    
    self.polylineList = [[NSMutableArray alloc]init];
    self.anno4remove = [[NSMutableArray alloc]init];
    [self drawStartEnd];
    if(self.pageType == 3 || self.pageType == 0){
        [self.button_bus setBackgroundImage:[UIImage imageNamed:@"map_routing_bus_on.png"] forState:UIControlStateNormal];
        [self displayBusRouteInMap];
    }else if(self.pageType == 1){
        [self.button_car setBackgroundImage:[UIImage imageNamed:@"map_routing_car_on.png"] forState:UIControlStateNormal];
        [self displayDriveRouteInMap];
    }else if(self.pageType == 2){
        [self.button_walk setBackgroundImage:[UIImage imageNamed:@"map_routing_pedestrian_on.png"] forState:UIControlStateNormal];
        [self displayWalkRouteInMap];
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    self.mapView.delegate = nil;
}
- (void)drawStartEnd{
    double start_lon_double = [self.startLon doubleValue];
    double start_lat_double = [self.startLat doubleValue];
    CNMKGeoPoint point_start = CNMKGeoPointMake(start_lon_double, start_lat_double);
    [self.mapView setCenterCoordinate:point_start];
    TEBusStationAnno* start_stationAnno = [[TEBusStationAnno alloc]init];
    start_stationAnno.encrypted = YES;
    start_stationAnno.title = @"start";
    start_stationAnno.coordinate = point_start;
    [self.mapView addAnnotation:start_stationAnno];
    
    double end_lon_double = [self.endLon doubleValue];
    double end_lat_double = [self.endLat doubleValue];
    CNMKGeoPoint point_end = CNMKGeoPointMake(end_lon_double, end_lat_double);
    TEBusStationAnno* end_stationAnno = [[TEBusStationAnno alloc]init];
    end_stationAnno.encrypted = YES;
    end_stationAnno.title = @"end";
    end_stationAnno.coordinate = point_end;
    [self.mapView addAnnotation:end_stationAnno];
    
//    CNMKGeoRect region = CNMKGeoRectMake(start_lon_double, start_lat_double, 320, 503);
//    [self.mapView setRegion:region animated:YES];
}
- (void)displayBusRouteInMap{
    SBJsonParser *jsonParser = [[SBJsonParser alloc]init];
    NSLog(@"routeJSON is %@",routeJSON);
    routeJSON = [routeJSON stringByReplacingOccurrencesOfString:@"{" withString:@"{\""];
    routeJSON = [routeJSON stringByReplacingOccurrencesOfString:@"\"," withString:@"\",\""];
    routeJSON = [routeJSON stringByReplacingOccurrencesOfString:@"]," withString:@"],\""];
    routeJSON = [routeJSON stringByReplacingOccurrencesOfString:@":\"" withString:@"\":\""];
    routeJSON = [routeJSON stringByReplacingOccurrencesOfString:@":[" withString:@"\":["];
    routeJSON = [routeJSON stringByReplacingOccurrencesOfString:@":null" withString:@"\":null"];
    routeJSON = [routeJSON stringByReplacingOccurrencesOfString:@"null," withString:@"null,\""];
    NSLog(@"routeJson after is %@",routeJSON);
    id result = [jsonParser objectWithString:routeJSON];
    if(result == nil)return;
    NSArray* lineInfo = [result objectForKey:@"lineInfo"];
    int i=0;
    for(i = 0;i<[lineInfo count];i++){
        int j=0;
        NSDictionary* oneLineObject = [lineInfo objectAtIndex:i];
        NSString* walkLine = [oneLineObject objectForKey:@"walkLine"];
        if(walkLine != nil && ([NSNull null] != (NSNull *)walkLine)){//步行
            NSArray* lonlat = [walkLine componentsSeparatedByString:@","];
            int pts_size = [lonlat count]/2;
            CNMKGeoPoint* geoPoints = new CNMKGeoPoint[pts_size];
            for(j=0;j<pts_size;j++){
                double lon = [[lonlat objectAtIndex:2*j]doubleValue]/460800;
                double lat = [[lonlat objectAtIndex:2*j+1]doubleValue]/460800;
                CNMKGeoPoint point = CNMKGeoPointMake(lon, lat);
                geoPoints[j] = point;
            }
            TERoutePolyline* polyline = [TERoutePolyline polylineWithGeoPoints:geoPoints count:pts_size];
            polyline.encrypted = YES;
            polyline.type = @"walk";
            [self.mapView addOverlay:polyline];
            [self.polylineList addObject:polyline];
        }
        //公交
        //起始点和终点
        double bus_start_lon_double = [[oneLineObject objectForKey:@"spx"]doubleValue]/460800;
        double bus_start_lat_double = [[oneLineObject objectForKey:@"spy"]doubleValue]/460800;
        CNMKGeoPoint bus_point_start = CNMKGeoPointMake(bus_start_lon_double, bus_start_lat_double);
        TEBusStationAnno* start_stationAnno = [[TEBusStationAnno alloc]init];
        start_stationAnno.encrypted = YES;
        start_stationAnno.title = @"bus";
        start_stationAnno.coordinate = bus_point_start;
        [self.mapView addAnnotation:start_stationAnno];
        [self.anno4remove addObject:start_stationAnno];
        
        double bus_end_lon_double = [[oneLineObject objectForKey:@"epx"]doubleValue]/460800;
        double bus_end_lat_double = [[oneLineObject objectForKey:@"epy"]doubleValue]/460800;
        CNMKGeoPoint bus_point_end = CNMKGeoPointMake(bus_end_lon_double, bus_end_lat_double);
        TEBusStationAnno* end_stationAnno = [[TEBusStationAnno alloc]init];
        end_stationAnno.encrypted = YES;
        end_stationAnno.title = @"bus";
        end_stationAnno.coordinate = bus_point_end;
        [self.mapView addAnnotation:end_stationAnno];
        [self.anno4remove addObject:end_stationAnno];
        
        NSString* clist = [oneLineObject objectForKey:@"clist"];
        if(clist != nil){
            NSArray* lonlat = [clist componentsSeparatedByString:@","];
            int pts_size = [lonlat count]/2;
            CNMKGeoPoint* geoPoints = new CNMKGeoPoint[pts_size];
            for(j=0;j<pts_size;j++){
                double lon = [[lonlat objectAtIndex:2*j]doubleValue]/460800;
                double lat = [[lonlat objectAtIndex:2*j+1]doubleValue]/460800;
                CNMKGeoPoint point = CNMKGeoPointMake(lon, lat);
                geoPoints[j] = point;
            }
            TERoutePolyline* polyline = [TERoutePolyline polylineWithGeoPoints:geoPoints count:pts_size];
            polyline.encrypted = YES;
            [self.mapView addOverlay:polyline];
            [self.polylineList addObject:polyline];
        }
    }
    NSString* toDistLine = [result objectForKey:@"toDistLine"];
    if(toDistLine != nil && ([NSNull null] != (NSNull *)toDistLine)){
        NSArray* lonlat = [toDistLine componentsSeparatedByString:@","];
        int pts_size = [lonlat count]/2;
        CNMKGeoPoint* geoPoints = new CNMKGeoPoint[pts_size];
        for(i=0;i<pts_size;i++){
            double lon = [[lonlat objectAtIndex:2*i]doubleValue]/460800;
            double lat = [[lonlat objectAtIndex:2*i+1]doubleValue]/460800;
            CNMKGeoPoint point = CNMKGeoPointMake(lon, lat);
            geoPoints[i] = point;
        }
        TERoutePolyline* polyline = [TERoutePolyline polylineWithGeoPoints:geoPoints count:pts_size];
        polyline.encrypted = YES;
        polyline.type = @"walk";
        [self.mapView addOverlay:polyline];
        [self.polylineList addObject:polyline];
    }
    
}
- (void)displayDriveRouteInMap{
    [TEAppDelegate getApplicationDelegate].networkHandler.delegate_routeDrive = self;
    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_routeDrive:self.startLon :self.startLat :self.endLon :self.endLat];
    [self displayLoading];
}
- (void)displayWalkRouteInMap{
    [TEAppDelegate getApplicationDelegate].networkHandler.delegate_routeWalk = self;
    [[TEAppDelegate getApplicationDelegate].networkHandler doRequest_routeWalk:self.startLon :self.startLat :self.endLon :self.endLat];
    [self displayLoading];
}
- (void)removeMapFeature{
    [self.mapView removeOverlays:self.polylineList];
    [self.mapView removeAnnotations:self.anno4remove];
    [self.polylineList removeAllObjects];
    [self.anno4remove removeAllObjects];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button_back_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)button_clicked:(id)sender {
    switch ([(UIButton*)sender tag]) {
        case 1:
        {
            [self removeMapFeature];
            [self resetButtons];
            [self.button_car setBackgroundImage:[UIImage imageNamed:@"map_routing_car_on.png"] forState:UIControlStateNormal];
            [self displayDriveRouteInMap];
            break;
        }
        case 2:
        {
            [self removeMapFeature];
            [self resetButtons];
            [self.button_walk setBackgroundImage:[UIImage imageNamed:@"map_routing_pedestrian_on.png"] forState:UIControlStateNormal];
            [self displayWalkRouteInMap];
            break;
        }
        case 3:
        {
            if(self.pageType != 3){
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            [self removeMapFeature];
            [self resetButtons];
            [self.button_bus setBackgroundImage:[UIImage imageNamed:@"map_routing_bus_on.png"] forState:UIControlStateNormal];
            [self displayBusRouteInMap];
            break;
        }
        case 4:
        {
            [self gotoUserLoc];
            break;
        }
        case 5:
        {
            [self.mapView zoomIn];
            break;
        }
        case 6:
        {
            [self.mapView zoomOut];
            break;
        }
        default:
            break;
    }
}
- (void)resetButtons{
    [self.button_bus setBackgroundImage:[UIImage imageNamed:@"map_routing_bus.png"] forState:UIControlStateNormal];
    [self.button_car setBackgroundImage:[UIImage imageNamed:@"map_routing_car.png"] forState:UIControlStateNormal];
    [self.button_walk setBackgroundImage:[UIImage imageNamed:@"map_routing_pedestrian.png"] forState:UIControlStateNormal];
}
- (void)gotoUserLoc{
    CLLocationCoordinate2D coordinate = [[self.mapView userLocation] coordinate];
    //如果当前的用户的位置为空时，中心的坐标为0，0，这时不进行跟踪
    if (0.001 > fabs(coordinate.latitude) || 0.001 > fabs(coordinate.longitude))
    {
        return;
    }
    [self.mapView setCenterCoordinate:CNMKGeoPointFromCLLocationCoordinate2D(coordinate)];
}
- (CNMKOverlayView *)mapView:(CNMKMapView *)mapView viewForOverlay:(id <CNMKOverlay>)overlay
{
	if ([overlay isKindOfClass:[TERoutePolyline class]])
    {
        CNMKPolylineView* polylineView = [[CNMKPolylineView alloc]initWithOverlay:overlay];
		polylineView.lineWidth = 5.0;
        if([((TERoutePolyline*)overlay).type isEqualToString:@"walk"]){
            polylineView.strokeColor = [UIColor orangeColor];
        }
        
		return polylineView;
    }
    return nil;
}
- (CNMKAnnotationView *)mapView:(CNMKMapView *)mapView viewForAnnotation:(id <CNMKAnnotationOverlay>)annotation
{
    TEBusStationAnno* anno = annotation;
    if([anno.title isEqualToString:@"start"]){//起点
        TEBusStationAnnoView* stationAnnoView = [[TEBusStationAnnoView alloc]initWithOverlay:anno];
        stationAnnoView.tag = 2345;
        [stationAnnoView setFrame:CGRectMake(0, 0, 22,32 )];
        UIImageView* imageView_bunbble = [[UIImageView alloc]init];
        imageView_bunbble.image = [UIImage imageNamed:@"bus_start.png"];
        stationAnnoView.imageView_annotation = imageView_bunbble;
        return stationAnnoView;
    }else if([anno.title isEqualToString:@"end"]){//终点
        TEBusStationAnnoView* stationAnnoView = [[TEBusStationAnnoView alloc]initWithOverlay:anno];
        stationAnnoView.tag = 2345;
        [stationAnnoView setFrame:CGRectMake(0, 0, 22,32 )];
        UIImageView* imageView_bunbble = [[UIImageView alloc]init];
        imageView_bunbble.image = [UIImage imageNamed:@"bus_end.png"];
        stationAnnoView.imageView_annotation = imageView_bunbble;
        return stationAnnoView;
    }else if([anno.title isEqualToString:@"bus"]){//公交
        TEBusStationAnnoView* stationAnnoView = [[TEBusStationAnnoView alloc]initWithOverlay:anno];
        stationAnnoView.tag = 1999;
        [stationAnnoView setFrame:CGRectMake(0, 0, 22,22 )];
        UIImageView* imageView_bunbble = [[UIImageView alloc]init];
        imageView_bunbble.image = [UIImage imageNamed:@"bus_bus.png"];
        stationAnnoView.imageView_annotation = imageView_bunbble;
        return stationAnnoView;
    }else{
        return nil;
    }
}
- (void)mapView:(CNMKMapView *)mapView didUpdateUserLocation:(CNMKLocation *)newLocation {
    if (newLocation && self.mapView.showsUserLocation) {
    }
}
#pragma -mark route drive delegate
- (void)routeDriveDidSuccess:(NSDictionary *)dic{
    [self hideLoading];
    if(dic == nil)return;
    if([[[dic objectForKey:@"response"]objectForKey:@"statusCode"]intValue] == 120000){
        NSArray* routeInfo = [[[dic objectForKey:@"response"] objectForKey:@"result"]objectForKey:@"routeInfo"];
        if (routeInfo == nil || ([NSNull null] == (NSNull *)routeInfo)) {
            [self.view makeToast:@"没有数据，请更换起始点或终点"];
            return;
        }
        NSArray* segmt = [[routeInfo objectAtIndex:0]objectForKey:@"segmt"];
        int i = 0;
        for(i = 0;i < [segmt count]; i++){
            NSDictionary* oneSegmt = [segmt objectAtIndex:i];
            NSArray* coordinates = [[[oneSegmt objectForKey:@"clist"]objectForKey:@"geometry"]objectForKey:@"coordinates"];
            int pts_size = [coordinates count];
            CNMKGeoPoint* geoPoints = new CNMKGeoPoint[pts_size];
            int j=0;
            for(j=0;j<pts_size;j++){
                NSArray* lonlat = [coordinates objectAtIndex:j];
                double lon = [[lonlat objectAtIndex:0]doubleValue];
                double lat = [[lonlat objectAtIndex:1]doubleValue];
                CNMKGeoPoint point = CNMKGeoPointMake(lon, lat);
                geoPoints[j] = point;
            }
            TERoutePolyline* polyline = [TERoutePolyline polylineWithGeoPoints:geoPoints count:pts_size];
            polyline.encrypted = YES;
            [self.mapView addOverlay:polyline];
            [self.polylineList addObject:polyline];
        }
    }
}
- (void)routeDriveDidFailed:(NSString *)mes{
    [self hideLoading];
}
- (void)routeWalkDidSuccess:(NSDictionary *)dic{
    [self hideLoading];
    if(dic == nil)return;
    if([[[dic objectForKey:@"response"]objectForKey:@"statusCode"]intValue] == 120000){
        NSArray* routeInfo = [[[dic objectForKey:@"response"] objectForKey:@"result"]objectForKey:@"routeInfo"];
        if (routeInfo == nil || ([NSNull null] == (NSNull *)routeInfo)) {
            [self.view makeToast:@"没有数据，请更换起始点或终点"];
            return;
        }
        NSArray* segmt = [[routeInfo objectAtIndex:0]objectForKey:@"segmt"];
        int i = 0;
        for(i = 0;i < [segmt count]; i++){
            NSDictionary* oneSegmt = [segmt objectAtIndex:i];
            NSString* clist = [oneSegmt objectForKey:@"clist"];
            if(clist != nil){
                NSArray* lonlat = [clist componentsSeparatedByString:@","];
                int pts_size = [lonlat count]/2;
                CNMKGeoPoint* geoPoints = new CNMKGeoPoint[pts_size];
                int j=0;
                for(j=0;j<pts_size;j++){
                    double lon = [[lonlat objectAtIndex:2*j]doubleValue]/460800;
                    double lat = [[lonlat objectAtIndex:2*j+1]doubleValue]/460800;
                    CNMKGeoPoint point = CNMKGeoPointMake(lon, lat);
                    geoPoints[j] = point;
                }
                TERoutePolyline* polyline = [TERoutePolyline polylineWithGeoPoints:geoPoints count:pts_size];
                polyline.encrypted = YES;
                polyline.type = @"walk";
                [self.mapView addOverlay:polyline];
                [self.polylineList addObject:polyline];
            }
        }
    }
}
- (void)routeWalkDidFailed:(NSString *)mes{
    [self hideLoading];
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
    self.button_bus.enabled = NO;
    self.button_car.enabled = NO;
    self.button_walk.enabled = NO;
}
- (void)enableAllButton{
    self.button_back.enabled = YES;
    self.button_bus.enabled = YES;
    self.button_car.enabled = YES;
    self.button_walk.enabled = YES;
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
