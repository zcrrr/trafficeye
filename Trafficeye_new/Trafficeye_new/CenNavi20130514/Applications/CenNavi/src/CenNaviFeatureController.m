//
//  CenNaviFeatureController.m
//
//  Created by Don Hao on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "CenNaviIdentifiers.h"
#import "CenNaviFeatureController.h"
#import "CenNaviDemoAppDelegate.h"
#import "CenNaviInterface.h"
#import "RHMIInit.h"

@implementation CenNaviFeatureController

@synthesize hmiProvider;
@synthesize mainStateView;
@synthesize areaListStateView;
@synthesize areaStateView;
@synthesize application;
@synthesize brand;//BMW/MINI
@synthesize rhmiType; //CIC/NBT/MINI
@synthesize enableSound;
@synthesize gpsLatitude; //If the value is 0, then GPS is not availavle
@synthesize gpsLongitude;
@synthesize gpsLatitudeFromMobile;
@synthesize gpsLongitudeFromMobile;
@synthesize speed;
@synthesize speedFromIphone;
@synthesize speedFromDir;
@synthesize direction;
@synthesize avAudioPlayer;
@synthesize isForward; //When the RHMI operation is a forward or a backward operation
@synthesize carHeading; //North is 0，West is 90，South is 180，east is 270. If the valuse < 0, the function is not supported
@synthesize selectedAreaIndex; //To identify which areas is currently selected
@synthesize currentMapType; // 0: city map, 1: ahead map, 2: area map
@synthesize cennaviCache;
@synthesize requestAheadMap;
@synthesize requestAreaMap;
@synthesize requestMainCity;
@synthesize requestRouteList;
@synthesize requestSound;
@synthesize routeList;
@synthesize timerCityMap;
@synthesize timerAheadMap;
@synthesize timerAreaMap;
@synthesize oneCityMap;
@synthesize oneAheadMap;
@synthesize oneAreaMap;
@synthesize cityName;
@synthesize locationManager;
@synthesize userLocation;
@synthesize indexBeforeArea;
@synthesize cityOverviewImage;
@synthesize aheadMapImage;
@synthesize areaImageDic;
@synthesize lastOverViewTime;
@synthesize lastAheadTime;
@synthesize lastAreaTimeDic;
@synthesize language;
@synthesize timestampAhead;
@synthesize graphic_idAhead;
@synthesize latWhenRequest;
@synthesize lonWhenRequest;
@synthesize timerAhead;
@synthesize ahead_loc_x;
@synthesize ahead_loc_y;
@synthesize isRequestAhead;

#pragma mark - Setup, TearDown

- (id)initWithApplication:(IDApplication*)application featureConfiguration:(MCFeatureConfiguration *)configuration
{
    //执行一些初始化工作
    self.oneCityMap = [[TrafficMap alloc] init];
    self.oneAheadMap = [[TrafficMap alloc] init];
    self.oneAreaMap = [[TrafficMap alloc] init];
    self.areaImageDic = [[NSMutableDictionary alloc]init];
    self.lastAreaTimeDic = [[NSMutableDictionary alloc]init];
    self.timestampAhead = @"";
    self.graphic_idAhead = @"";
    self.currentMapType = -1;
    //判断gps
//    if([self isCarGpsAvailable]){
//        
//    }else{
        self.locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
//    }
    //byzc下面一句话是去掉log，方便调试
    [[IDLogger defaultLogger] setMaximumLogLevel:IDLogLevelNone];
    
    self.cennaviCache = [CenNaviCache getCacheInstance];
    self.hmiProvider = [[CenNaviHmiProvider alloc] init];
    self.application = [[IDApplication alloc] initWithHmiProvider:self.hmiProvider];
    self = [super initWithApplication:self.application featureConfiguration:configuration];
    
    if (self)
    {
        _playImmediately = YES;
    }
    
    MCLog(IDLogLevelInfo, @"%@ featureDidStart...", [self featureIdentifier]);

    return self;
}

#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
//    NSLog(@"获取一个新的坐标");
    
    self.userLocation = newLocation;
    self.gpsLatitudeFromMobile = self.userLocation.coordinate.latitude;
    self.gpsLongitudeFromMobile = self.userLocation.coordinate.longitude;
    self.speedFromIphone = self.userLocation.speed;
//    if(self.userLocation.course >= 0){
        self.direction = 360 - self.userLocation.course;
//        NSLog(@"self.drection is %i",self.direction);
        [self performSelectorOnMainThread:@selector(rotateAndDisplay) withObject:nil waitUntilDone:NO];
//    }
    
//    NSLog(@"from iphone latitude is %f",self.gpsLatitude);
//    NSLog(@"from iphone longitude is %f",self.gpsLongitude);
//    NSLog(@"from iphone speed is %i",self.speed);
//    NSLog(@"from iphone direction is %i",self.direction);
//    [self.mainStateView.lbl_notes setText:[NSString stringWithFormat:@"i%f,%f",self.gpsLatitude,self.gpsLongitude]];
}

- (void)dealloc
{	
    [super dealloc];
    [self CenNaviInterfaceDealloc];
    [self dealloc];
}

#pragma mark - MCFeatureController protocol implementation

- (UIImage *)featureImage
{
    return nil; //[UIImage mainAppIconMultimedia];
}

- (NSString*) featureName
{ 
    return @"CenNavi"; 
}

- (NSString*) featureDescription
{
    return @"Cen Navigator"; 
}

- (NSString*)featureVendor 
{ 
    return @"BMW Group"; 
}

- (IDVersionInfo*) featureVersion
{
    return [IDVersionInfo versionInfoWithMajor:1 minor:0 revision:0];
}

- (BOOL) featureRequiresActivation
{
    return NO;
}

#pragma mark - Feature lifecycle

- (void)featureDidConnectToVehicle:(IDVehicleInfo *)vehicleInfo
{
    MCLog(IDLogLevelInfo, @"%@ is starting...", [self featureIdentifier]);
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

- (void)featureWillStartHMI
{
    MCLog(IDLogLevelInfo, @"%@ is starting...", [self featureIdentifier]);    
}

- (void)featureDidStart
{
    [self RHMIInit];
}

-(void)featureDidStop
{

}


- (void)featureShouldRestoreHmiWithComponents:(NSArray *)components
{

}
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees :(UIImage*)oldImage
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,oldImage.size.width, oldImage.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degrees* M_PI / 180);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    [rotatedViewBox release];
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, 75, 75);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, degrees* M_PI / 180);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-75, -75, oldImage.size.width, oldImage.size.height), [oldImage CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}


- (CGImageRef)CGImageRotatedByAngle:(CGImageRef)imgRef angle:(CGFloat)angle
{
    
    CGFloat angleInRadians = angle * (M_PI / 180);
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGRect imgRect = CGRectMake(0, 0, width, height);
    CGAffineTransform transform = CGAffineTransformMakeRotation(angleInRadians);
    CGRect rotatedRect = CGRectApplyAffineTransform(imgRect, transform);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef bmContext = CGBitmapContextCreate(NULL,
                                                   rotatedRect.size.width,
                                                   rotatedRect.size.height,
                                                   8,
                                                   0,
                                                   colorSpace,
                                                   (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    CGContextSetAllowsAntialiasing(bmContext, YES);
    CGContextSetShouldAntialias(bmContext, YES);
    CGContextSetInterpolationQuality(bmContext, kCGInterpolationHigh);
    CGColorSpaceRelease(colorSpace);
    CGContextTranslateCTM(bmContext,
                          +(rotatedRect.size.width/2),
                          +(rotatedRect.size.height/2));
    CGContextRotateCTM(bmContext, angleInRadians);
    CGContextTranslateCTM(bmContext,
                          -(rotatedRect.size.width/2),
                          -(rotatedRect.size.height/2));
    CGContextDrawImage(bmContext, CGRectMake(0, 0,
                                             rotatedRect.size.width,
                                             rotatedRect.size.height),
                       imgRef);
    
    
    
    CGImageRef rotatedImage = CGBitmapContextCreateImage(bmContext);
    CFRelease(bmContext);
    [(id)rotatedImage autorelease];
    
    return rotatedImage;
}


@end
