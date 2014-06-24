//
//  AISINInterface.m
//  CenNaviDemo
//
//  Created by Don Hao on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//#define BENDI
#define OVERDUETIME 60*2
#define TIMEINTERVAL 4
#define TIMEOUTSECOND 30

#import "MCAudioManager.h"
#import "CenNaviInterface.h"
#import "CenNaviIdentifiers.h"
#import "RHMIInit.h"
#import "RHMICommon.h"
#import "CenNaviCache.h"
#import "SBJson.h"


@implementation CenNaviFeatureController (AISINInterface)


#pragma mark - Init
-(void)CenNaviInterfaceInit {
    NSLog(@"刚进程序时这个也会执行，不过比buttonMainScreenCityOverviewDidPress晚");
    
    //设置等待的转圈显示与否
    self.mainStateView.lbl_waiting_annimation.waitingAnimation = YES;
    self.selectedAreaIndex = 0;
    UIImage *image_compassbg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CompassBG" ofType:@"png"]];
    self.mainStateView.img_main_screen_compassbg.imageData = [image_compassbg idPNGImageData];
    self.areaStateView.img_area_screen_compassbg.imageData = [image_compassbg idPNGImageData];
    UIImage *image_compass = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CompassCCP" ofType:@"png"]];
    self.mainStateView.img_main_screen_compass.imageData = [image_compass idPNGImageData];
    self.areaStateView.img_area_screen_compass.imageData = [image_compass idPNGImageData];
    UIImage *image_bg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TrafficEye_BG" ofType:@"png"]];
    self.mainStateView.img_main_screen_bg.imageData = [image_bg idPNGImageData];
    self.areaStateView.img_area_screen_bg.imageData = [image_bg idPNGImageData];
    
    UIImage *image_ccp = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CCPM2" ofType:@"png"]];
    self.mainStateView.img_main_screen_location.imageData = [image_ccp idPNGImageData];
    
    if (!((self.brand == IDVehicleBrandBMW) && (self.rhmiType == IDVehicleHmiTypeID4)))
    {
        // NOT CIC
        self.mainStateView.img_main_screen_location.visible = NO;
        self.mainStateView.lbl_waiting_annimation.waitingAnimation = NO;
        self.mainStateView.img_main_screen_compassbg.visible = false;
        self.mainStateView.img_main_screen_compass.visible = false;
        self.mainStateView.img_main_screen_bg.visible = false;
        
        self.mainStateView.btn_main_screen_city_overview.enabled = false;
        self.mainStateView.btn_main_screen_ahead_traffic.enabled = false;
        self.mainStateView.btn_main_screen_browse_areas.enabled = false;
        self.mainStateView.btn_main_screen_city_overview.selectable = false;
        self.mainStateView.btn_main_screen_ahead_traffic.selectable = false;
        self.mainStateView.btn_main_screen_browse_areas.selectable = false;
        
        self.mainStateView.title = @"";
        self.mainStateView.lbl_waiting_annimation.waitingAnimation = NO;
        return;
    }
}

-(void)CenNaviInterfaceDealloc {
    
}

#pragma mark - car gps
- (BOOL)isCarGpsAvailable {
    if (self.gpsLatitude != 0) {
        return YES;
    } else {
        return NO;
    }
}
- (void)displayAhead:(BOOL)isOn{
    if(isOn){
        self.mainStateView.img_main_screen_map.visible = NO;
        self.mainStateView.img_main_screen_ahead.visible = YES;
        //        self.mainStateView.img_main_screen_location.visible = YES;
        self.mainStateView.img_main_screen_bg.visible = NO;
    }else{
        self.mainStateView.img_main_screen_map.visible = YES;
        self.mainStateView.img_main_screen_ahead.visible = NO;
        self.mainStateView.img_main_screen_location.visible = NO;
        self.mainStateView.img_main_screen_bg.visible = YES;
    }
}
#pragma mark - button did press
- (void)buttonMainScreenCityOverviewDidPress:(IDButton *)button {
    NSLog(@"buttonMainScreenCityOverviewDidPress");
    if(self.currentMapType == 0)return;
    [self.timerAhead invalidate];
    [self stopRequestAnimationMainView];
    [self displayAhead:NO];
    NSLog(@"这里会执行？");
    
    self.currentMapType = 0;
    NSString* image0FileName = nil;
    NSString* image1FileName = nil;
    if (self.brand == IDVehicleBrandBMW){
        if (self.rhmiType == IDVehicleHmiTypeID4PlusPlus) {
            // NBT
            //            self.mainStateView.title = @"NBT";
            image0FileName = [[[NSString alloc] initWithString:@"nbt_city_overview_selected"] autorelease];
            image1FileName = [[[NSString alloc] initWithString:@"nbt_ahead_traffic_unselected"] autorelease];
            
        } else {
            // CIC
            //Set the bg
            //IDImageData
            //            self.mainStateView.title = @"CIC";
            image0FileName = [[[NSString alloc] initWithString:@"cic_city_overview_selected"] autorelease];
            image1FileName = [[[NSString alloc] initWithString:@"cic_ahead_traffic_unselected"] autorelease];
        }
    }
    else {
        //MINI
        //        self.mainStateView.title = @"MINI";
        image0FileName = [[[NSString alloc] initWithString:@"mini_city_overview_selected"] autorelease];
        image1FileName = [[[NSString alloc] initWithString:@"mini_ahead_traffic_unselected"] autorelease];
    }
    if (self.language == 11){//简体中文
        self.mainStateView.title = @"城市路況";
    }else if(self.language == 10){//繁体中文
        self.mainStateView.title = @"城市路況";
    }else{
        self.mainStateView.title = @"City Overview";
    }
    
    
    UIImage *image0 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:image0FileName ofType:@"png"]];
    self.mainStateView.btn_main_screen_city_overview.image = [image0 idPNGImageData];
    UIImage *image1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:image1FileName ofType:@"png"]];
    self.mainStateView.btn_main_screen_ahead_traffic.image = [image1 idPNGImageData];
    if (!((self.brand == IDVehicleBrandBMW) && (self.rhmiType == IDVehicleHmiTypeID4)))
    {
            // NOT CIC
            self.mainStateView.btn_main_screen_city_overview.enabled = false;
            self.mainStateView.btn_main_screen_ahead_traffic.enabled = false;
            self.mainStateView.btn_main_screen_browse_areas.enabled = false;
            self.mainStateView.btn_main_screen_city_overview.selectable = false;
            self.mainStateView.btn_main_screen_ahead_traffic.selectable = false;
            self.mainStateView.btn_main_screen_browse_areas.selectable = false;
            
            self.mainStateView.title = @"";
            self.mainStateView.lbl_waiting_annimation.waitingAnimation = NO;
            return;
    }
    //    if(self.cityOverviewImage){//使用最近一次下载的全图
    //        self.mainStateView.img_main_screen_map.imageData = [self.cityOverviewImage idPNGImageData];
    //    }else{
    //        self.mainStateView.img_main_screen_map.imageData = nil;
    //    }
    
    //    UIImage *imagezc = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"app_icon" ofType:@"png"]];
    //    NSData *dataObj = UIImageJPEGRepresentation(imagezc, 1.0);
    //    NSLog(@"-------------------zc%@",dataObj);
    
    //Update the map
    [self updateCurrentView];
    //play audio
    //    if (self.enableSound){
    //        //DEMO
    //        [self playAudio:nil];
    //    }
}


- (void)buttonMainScreenAheadTrafficDidPress:(IDButton *)button {
    if(self.currentMapType == 1)return;
    [self stopRequestAnimationMainView];
    if(self.currentMapType != 1){//从别的页面点击前方图
        [self stopSound];
    }
    self.currentMapType = 1;
    [self displayAhead:YES];
    self.mainStateView.img_main_screen_location.visible = NO;
    NSString* image0FileName = nil;
    NSString* image1FileName = nil;
    
    if (self.brand == IDVehicleBrandBMW){
        if (self.rhmiType == IDVehicleHmiTypeID4PlusPlus){
            // NBT
            //            self.mainStateView.title = @"NBT";
            image0FileName = [[[NSString alloc] initWithString:@"nbt_city_overview_unselected"] autorelease];
            image1FileName = [[[NSString alloc] initWithString:@"nbt_ahead_traffic_selected"] autorelease];
        } else {
            // CIC
            //Set the bg
            //IDImageData
            //            self.mainStateView.title = @"CIC";
            image0FileName = [[[NSString alloc] initWithString:@"cic_city_overview_unselected"] autorelease];
            image1FileName = [[[NSString alloc] initWithString:@"cic_ahead_traffic_selected"] autorelease];
        }
    }
    else {
        //MINI
        //        self.mainStateView.title = @"NIMI";
        image0FileName = [[[NSString alloc] initWithString:@"mini_city_overview_unselected"] autorelease];
        image1FileName = [[[NSString alloc] initWithString:@"mini_ahead_traffic_selected"] autorelease];
    }
    
    if (self.language == 11){//简体中文
        self.mainStateView.title = @"前方路况";
    }else if(self.language == 10){//繁体中文
        self.mainStateView.title = @"前方路况";
    }else{
        self.mainStateView.title = @"Traffic Ahead";
    }
    UIImage *image0 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:image0FileName ofType:@"png"]];
    self.mainStateView.btn_main_screen_city_overview.image = [image0 idPNGImageData];
    UIImage *image1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:image1FileName ofType:@"png"]];
    self.mainStateView.btn_main_screen_ahead_traffic.image = [image1 idPNGImageData];
    //    if(self.aheadMapImage){//使用最近一次下载的全图
    //        self.mainStateView.img_main_screen_ahead.imageData = [self.aheadMapImage idPNGImageData];
    //    }else{
    //        self.mainStateView.img_main_screen_ahead.imageData = nil;
    //    }
    
    
    //    UIImage *imagezc = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"map" ofType:@"png"]];
    //    self.mainStateView.img_main_screen_map.imageData = [imagezc idPNGImageData];
    [self updateCurrentView];
    self.timerAhead = [NSTimer scheduledTimerWithTimeInterval:TIMEINTERVAL target:self selector:@selector(updateCurrentView) userInfo:nil repeats:YES];
    
    //play audio
    //    if (self.enableSound){
    //        //DEMO
    //        [self playAudio:nil];
    //    }
}


- (void)buttonMainScreenBrowseAreasDidPress:(IDButton *)button {
    [self.timerAhead invalidate];
    self.indexBeforeArea = self.currentMapType;
    if(self.currentMapType != 2){//界面改变
        [self stopSound];
    }
    
    self.currentMapType = 2;
    self.isForward = YES;
    //TODO - Get the area list
    
    //Demo area list
    
    if (self.language == 11){//简体中文
        self.areaListStateView.title = @"区域列表";
    }else if(self.language == 10){//繁体中文
        self.areaListStateView.title = @"區域列表";
    }else{
        self.areaListStateView.title = @"Area List";
    }
    if(!self.routeList){
        [self.areaListStateView.table_area_list_state_area_name setRowCount:1 columnCount:1];
        if (self.language == 11){//简体中文
            self.areaListStateView.lbl_area_list_state_city_name.text = @"请稍后...";
        }else if(self.language == 10){//繁体中文
            self.areaListStateView.lbl_area_list_state_city_name.text = @"请稍后...";
        }else{
            self.areaListStateView.lbl_area_list_state_city_name.text = @"waiting...";
        }
        
        //        [self.areaListStateView.table_area_list_state_area_name setCell:[IDTableCell tableCellWithString:@"waiting..."] atRow:0 column:0];
        //        NSString *strURL = @"http://211.151.84.15:20880/GraphicService/getGraphCoreArea?op=gil&customID=customID&clat=39.90998&clon=116.379126&carDirection=45&driveSpeed=100";
        //下面路测用
        int thisSpeed = self.speed>0?self.speed:self.speedFromIphone;
        thisSpeed = thisSpeed<0?0:thisSpeed;
        self.direction = self.direction < 0 ? 0:self.direction;
        self.direction = self.direction > 360 ? 360:self.direction;
#ifdef BENDI
        self.gpsLatitude = 39.909736;
        self.gpsLongitude = 116.415253;
#endif
        NSString *strURL = [NSString stringWithFormat:@"http://211.151.84.15:20880/GraphicService/getGraphCoreArea.json?op=gil&customID=customID&clat=%f&clon=%f&carDirection=%i&driveSpeed=%i",[self getLatitude],[self getLongitude],self.direction,thisSpeed];
        NSURL *url = [NSURL URLWithString:strURL];
        ASIHTTPRequest *reuqest = [ASIHTTPRequest requestWithURL:url];
        reuqest.tag = 1003;
        [reuqest setDelegate:self];
        [reuqest startAsynchronous];
    }else{
        [self initRoutList];
    }
    
    //测试代码：
    //    [self.areaListStateView.table_area_list_state_area_name setRowCount:3 columnCount:1];
    //    [self.areaListStateView.table_area_list_state_area_name setCell:[IDTableCell tableCellWithString:[NSString stringWithFormat:@"lat:%f,lon:%f",self.gpsLatitude,self.gpsLongitude]] atRow:0 column:0];
    //    [self.areaListStateView.table_area_list_state_area_name setCell:[IDTableCell tableCellWithString:[NSString stringWithFormat:@"speed:%d,%d",self.speed,self.speedFromDir]] atRow:1 column:0];
    //    [self.areaListStateView.table_area_list_state_area_name setCell:[IDTableCell tableCellWithString:[NSString stringWithFormat:@"dir:%d",self.direction]] atRow:2 column:0];
}

- (void)buttonAreaStatePreviousDidPress:(IDButton *)button {
    //1. get the area map based on the selected index
    //2. to set the prevois/next button is enable or not
    NSLog(@"previous");
    [self stopSound];
    [self resetPreOrNextBtnState];
    [self stopRequestAnimationAreaView];
    if(self.selectedAreaIndex != 0){
        self.selectedAreaIndex--;
    }
    
    UIImage *lastImage = [self.areaImageDic objectForKey:[NSString stringWithFormat:@"%i",self.selectedAreaIndex]];
    if(lastImage){//使用最近一次下载的全图
        self.areaStateView.img_area_state_map.imageData = [lastImage idPNGImageData];
    }else{
        self.areaStateView.img_area_state_map.imageData = nil;
    }
    
    
    NSDictionary *routeDic = [self.routeList objectAtIndex:self.selectedAreaIndex];
    NSString* selectedArea = [routeDic valueForKey:@"name"];
    self.areaStateView.title = selectedArea;
    if(self.selectedAreaIndex == 0){
        self.areaStateView.btn_area_state_previous.enabled = NO;
    }
    [self updateCurrentView];
}

- (void)buttonAreaStateNextDidPress:(IDButton *)button {
    //1. get the area map based on the selected index
    //2. to set the prevois/next button is enable or not
    NSLog(@"next");
    [self stopSound];
    [self stopRequestAnimationAreaView];
    [self resetPreOrNextBtnState];
    if(self.selectedAreaIndex != [self.routeList count]-1 ){
        self.selectedAreaIndex++;
    }
    
    UIImage *lastImage = [self.areaImageDic objectForKey:[NSString stringWithFormat:@"%i",self.selectedAreaIndex]];
    if(lastImage){//使用最近一次下载的全图
        self.areaStateView.img_area_state_map.imageData = [lastImage idPNGImageData];
    }else{
        self.areaStateView.img_area_state_map.imageData = nil;
    }
    
    NSDictionary *routeDic = [self.routeList objectAtIndex:self.selectedAreaIndex];
    NSString* selectedArea = [routeDic valueForKey:@"name"];
    self.areaStateView.title = selectedArea;
    
    if(self.selectedAreaIndex == [self.routeList count]-1){
        self.areaStateView.btn_area_state_next.enabled = NO;
    }
    [self updateCurrentView];
}

#pragma mark - IDTableDelegate protocol method
- (void)table:(IDTable *)table didSelectItemAtIndex:(NSInteger)index {
    [self stopRequestAnimationAreaView];
    self.currentMapType = 3;
    if (table == self.areaListStateView.table_area_list_state_area_name){
        self.selectedAreaIndex = index;
        
        self.isForward = YES;
        
        //TODO
        //1. to get the name of the area based on the selected index
        //2. get the area map based on the selected index
        //3. to set the prevois/next button is enable or not
        //Demo
        NSDictionary *routeDic = [self.routeList objectAtIndex:index];
        
        NSString* selectedArea = [routeDic valueForKey:@"name"];
        self.areaStateView.title = selectedArea;
        //set the previous/next button state
        [self resetPreOrNextBtnState];
        if(self.selectedAreaIndex == 0){
            self.areaStateView.btn_area_state_previous.enabled = NO;
        }else if(self.selectedAreaIndex == ([self.routeList count]-1)){//1应改为列表条目数
            self.areaStateView.btn_area_state_next.enabled = NO;
        }
        //        UIImage *lastImage = [self.areaImageDic objectForKey:[NSString stringWithFormat:@"%i",self.selectedAreaIndex]];
        //        if(lastImage){//使用最近一次下载的全图
        //            self.areaStateView.img_area_state_map.imageData = [lastImage idPNGImageData];
        //        }else{
        //            self.areaStateView.img_area_state_map.imageData = nil;
        //        }
        //Update the map
        [self updateCurrentView];
        //play audio
        //        if (self.enableSound){
        //            //DEMO
        //            [self playAudio:nil];
        //        }
    }
}

#pragma mark - CDS
-(void)didReceiveSpeedActual:(NSDictionary*) response {
	NSInteger speed = [[response objectForKey:@"speedActual"] integerValue];
    NSLog(@"------speed is %i",speed);
    self.speed = speed;
    //    [self.mainStateView.lbl_notes setText:[NSString stringWithFormat:@"speed is %d",speed]];
    //To do
}

-(void)didRHMILanguageChanged:(NSDictionary*) response {
    //    [self performSelectorOnMainThread:@selector(rotateAndDisplay) withObject:nil waitUntilDone:NO];
	NSInteger languageIndex = [[response objectForKey:@"language"] integerValue];
    self.language = languageIndex;
    NSLog(@"语言变化%i",languageIndex);
    /*
     extern NSString* CDSVehicleLanguage;
     enum eCDSVehicleLanguage
     {
     CDSVehicleLanguage_NOLANGUAGE = 0,
     CDSVehicleLanguage_DEUTSCH = 1,
     CDSVehicleLanguage_ENGLISHUK = 2,
     CDSVehicleLanguage_ENGLISHUS = 3,
     CDSVehicleLanguage_SPANISH = 4,
     CDSVehicleLanguage_ITALIAN = 5,
     CDSVehicleLanguage_FRENCH = 6,
     CDSVehicleLanguage_FLEMISH = 7,
     CDSVehicleLanguage_DUTCH = 8,
     CDSVehicleLanguage_ARABIC = 9,
     CDSVehicleLanguage_CHINESETRADITIONAL = 10,
     CDSVehicleLanguage_CHINESESIMPLE = 11,
     CDSVehicleLanguage_KOREAN = 12,
     CDSVehicleLanguage_JAPANESE = 13,
     CDSVehicleLanguage_RUSSIAN = 14,
     CDSVehicleLanguage_FRENCHCANADIAN = 15,
     CDSVehicleLanguage_SPANISHMEXICO = 16,
     CDSVehicleLanguage_PORTUGESE = 17,
     CDSVehicleLanguage_POLISH = 18,
     CDSVehicleLanguage_GREEK = 19,
     CDSVehicleLanguage_TURKISH = 20,
     CDSVehicleLanguage_HUNGARIAN = 21,
     CDSVehicleLanguage_ROMANIAN = 22,
     CDSVehicleLanguage_SWEDISH = 23,
     CDSVehicleLanguage_INVALID = 255
     */
    
    //To do
    MCLog(IDLogLevelInfo, @"language: %d", languageIndex);
    
    if (13 == languageIndex) {
        
    }
    else {
        
    }
}

-(void)didSteeringWheel:(NSDictionary*) response {
    NSDictionary* steeringWheelDictionary = [response valueForKey:@"steeringWheel"];
    
    if (nil == steeringWheelDictionary) {
        MCLog(IDLogLevelError, @"no key steeringWheel in response");
        return;
    }
    
    NSNumber* angleNumber = [steeringWheelDictionary valueForKey:@"angle"];
    if (nil == angleNumber) {
        
        MCLog(IDLogLevelError, @"no key angle in dictionary");
        return;
    }
    NSNumber* speedNumber = [steeringWheelDictionary valueForKey:@"speed"];
    if (nil == speedNumber) {
        MCLog(IDLogLevelError, @"no key speed in dictionalry");
        return;
    }
}

-(void)didGear:(NSDictionary*) response {
    NSInteger gear = [[response objectForKey:@"gear"] integerValue];
    MCLog(IDLogLevelInfo, @"%d", gear);
    
    /*
     enum eCDSDrivingGear
     {
     CDSDrivingGear_NEUTRAL = 1,
     CDSDrivingGear_REVERSE = 2,
     CDSDrivingGear_PARK = 3,
     CDSDrivingGear_1 = 5,
     CDSDrivingGear_2 = 6,
     CDSDrivingGear_3 = 7,
     CDSDrivingGear_4 = 8,
     CDSDrivingGear_5 = 9,
     CDSDrivingGear_6 = 10,
     CDSDrivingGear_7 = 11,
     CDSDrivingGear_8 = 12,
     CDSDrivingGear_9 = 13,
     CDSDrivingGear_INVALID = 15
     };
     */
    
    //To do
}

-(void)didHeadLights:(NSDictionary*)response {
    NSInteger headlights = [[response objectForKey:@"headlights"] integerValue];
    MCLog(IDLogLevelInfo, @"%d", headlights);
}

-(void)didLights:(NSDictionary*)response {
    NSDictionary* lightsDic = [response objectForKey:@"lights"];
    NSInteger brights = [[lightsDic objectForKey:@"brights"] integerValue];
    NSInteger frontFog = [[lightsDic objectForKey:@"frontFog"] integerValue];
    NSInteger rearFog = [[lightsDic objectForKey:@"rearFog"] integerValue];
    NSInteger parking = [[lightsDic objectForKey:@"parking"] integerValue];
    MCLog(IDLogLevelInfo, @"%d %d %d %d", brights, frontFog, rearFog, parking);
}

-(void)didLocation:(NSDictionary*)response {
    long error = [[response valueForKey:@"error"] longValue];
    NSLog(@"gps from bmw");
    if(0 == error){
        self.gpsLatitude = [[[response valueForKey:@"GPSPosition"] valueForKey:@"latitude"] floatValue];
        self.gpsLongitude = [[[response valueForKey:@"GPSPosition"] valueForKey:@"longitude"] floatValue];
        //        NSLog(@"from bmw latitude is %f",self.gpsLatitude);
        //        NSLog(@"from bmw longitude is %f",self.gpsLongitude);
        //        [self.mainStateView.lbl_notes setText:[NSString stringWithFormat:@"b%f,%f",self.gpsLatitude,self.gpsLongitude]];
    }
}
- (void)rotateAndDisplay{
    //    NSLog(@"rotateanddisplay");
    
    UIImage *oldimage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CompassCCP" ofType:@"png"]];
    UIImage* img = [self imageRotatedByDegrees:(360-self.direction):oldimage];
    if(self.currentMapType == 0 || self.currentMapType == 1){
        self.mainStateView.img_main_screen_compass.imageData = [img idPNGImageData];
    }else if(self.currentMapType == 3){
        self.areaStateView.img_area_screen_compass.imageData = [img idPNGImageData];
    }
    
    
}
-(void)disHeadChanged:(NSDictionary*)response{
    int cdsHeadingValue = [[[response valueForKey:@"GPSExtendedInfo"] valueForKey:@"heading"] intValue];
    //transform cds value from (0-255) into degress(0-360)
    
    long error = [[response valueForKey:@"error"] longValue];
    if(0 == error){
        NSLog(@"车头转向");
        self.carHeading = ((float) cdsHeadingValue) * 360 / 256;
        //        self.direction = self.carHeading;
        //        [self performSelectorOnMainThread:@selector(rotateAndDisplay) withObject:nil waitUntilDone:NO];
    }
}

#pragma mark - get map
-(UIImage*)getCurrentCityMap{
    //TODO
    NSLog(@"这个会自动执行。。。。。");
    //    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"map_transparent" ofType:@"png"]];
    return nil;
    
}
-(UIImage*)getAheadTrafficMap{
    //TODO
    //    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"map" ofType:@"png"]];
    return nil;
}
-(UIImage*)getAreaMap{
    //TODO
    //    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"map_transparent" ofType:@"png"]];
    return nil;
}

#pragma mark - state did focus
-(void)didMainScreenFocused:(IDVariantMap*)infoMap {
    NSLog(@"didMainScreenFocused");
    if (self.brand == IDVehicleBrandBMW){
        if (self.rhmiType == IDVehicleHmiTypeID4PlusPlus) {
            IDVariantMap* map1 = [[IDVariantMap alloc] init];
            [map1 setVariant:[IDVariantData variantWithInteger:20] forId:IDParameterValue];
            
            IDVariantMap* map2 = [[IDVariantMap alloc] init];
            [map2 setVariant:[IDVariantData variantWithInteger:100] forId:IDParameterValue];
            
            [self.hmiService setProperty:IDPropertyPositionX forComponent:15 variantMap:map1];
            [self.hmiService setProperty:IDPropertyPositionY forComponent:15 variantMap:map2];
        }
    }
    
    if (!((self.brand == IDVehicleBrandBMW) && (self.rhmiType == IDVehicleHmiTypeID4)))
    {
        NSString* des = @"";
        if (self.language == 11){//简体中文
            des = @"此应用不支持本车系统，与客服联系可获得更多信息。";
        }else if(self.language == 10){//繁体中文
            des = @"此應用不支持本車系統，與客服聯系可獲得更多信息。";
        }else{
            des = @"This App is not supported by this vehicle system, please contact with our customer service for more information.";
        }
        [self.mainStateView.lbl_notes setText:des];
        
        return;
    }
    
    if (NO == [self RHMICommonDlgIsFocused:infoMap]){
        return;
    }
    if (self.language == 11){//简体中文
        self.mainStateView.title = @"城市路況";
    }else if(self.language == 10){//繁体中文
        self.mainStateView.title = @"城市路況";
    }else{
        self.mainStateView.title = @"City Overview";
    }
    
    NSLog(@"返回主页面");
    [self stopRequestAnimationMainView];
    NSLog(@"currentMapType is %i",self.currentMapType);
    if(self.currentMapType == 0){//第一次进入cennavi页面，刷新一次，因为之前第一次请求可能由于gps还没获取到信息，而请求失败
        [self updateCurrentView];
    }
    if(self.currentMapType == 2 || self.currentMapType == 3){//说明是从商圈页面点击左键返回的主页面，需要重新刷新一下
        [self stopSound];
        self.currentMapType = self.indexBeforeArea;
        [self updateCurrentView];
        if(self.currentMapType == 2){
            self.timerAhead = [NSTimer scheduledTimerWithTimeInterval:TIMEINTERVAL target:self selector:@selector(updateCurrentView) userInfo:nil repeats:YES];
        }
    }
    
    static BOOL threadInited = NO;
    
    if(!threadInited){
        threadInited = YES;
        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updateCurrentMap) userInfo:nil repeats:YES];
    }
    [self.audioService activateInterrupt];
    
    //    self.currentMapType = 0;
    //To do
    
    if (YES == self.isForward){
        MCLog(IDLogLevelInfo, @"Forward");
    }else{
        MCLog(IDLogLevelInfo, @"Back");
    }
    
    self.isForward = NO;
}

-(void)didAreaListStateFocused:(IDVariantMap*)infoMap {
    if (NO == [self RHMICommonDlgIsFocused:infoMap]){
        return;
    }
    self.areaStateView.img_area_state_map.imageData = nil;
    //    self.currentMapType = 1;
    //To do
    
    if (YES == self.isForward){
        MCLog(IDLogLevelInfo, @"Forward");
    }else{
        MCLog(IDLogLevelInfo, @"Back");
    }
    
    self.isForward = NO;
}

-(void)didAreaStateFocused:(IDVariantMap*)infoMap {
    if (NO == [self RHMICommonDlgIsFocused:infoMap]){
        return;
    }
    
    //    self.currentMapType = 2;
    
    //To do
    
    if (YES == self.isForward){
        MCLog(IDLogLevelInfo, @"Forward");
        NSLog(@"forward");
    }else{
        MCLog(IDLogLevelInfo, @"Back");
        NSLog(@"back");
    }
    self.isForward = NO;
}

#pragma mark - update map periodically
-(void)updateCurrentMap{
    //    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    //    NSLog(@"%@",datenow);
    //    NSTimeInterval timeinterval = [datenow timeIntervalSince1970];
    //    NSLog(@"%lf",timeinterval);
    
    //    if(0 == self.currentMapType){
    //        //City map
    //        self.mainStateView.img_main_screen_map.imageData = [[self getCurrentCityMap] idPNGImageData];
    //    } else if (1 == self.currentMapType){
    //        //Ahead map
    //    } else if (2 == self.currentMapType){
    //        //Area map
    //    } else {
    //    }
}

#pragma mark - defined by zc
//重置向前向后按钮状态
- (void)resetPreOrNextBtnState{
    self.areaStateView.btn_area_state_previous.enabled = YES;
    self.areaStateView.btn_area_state_next.enabled = YES;
}
//显示mainview请求动画
- (void)startRequestAnimationMainView{
    if(self.currentMapType == 0){
        if(!self.cityOverviewImage){
            
            if (self.language == 11){//简体中文
                [self.mainStateView.lbl_notes setText:@"请稍后..."];
            }else if(self.language == 10){//繁体中文
                [self.mainStateView.lbl_notes setText:@"请稍后..."];
            }else{
                [self.mainStateView.lbl_notes setText:@"Waiting..."];
            }
            self.mainStateView.lbl_waiting_annimation.waitingAnimation = YES;
        }
    }else if(self.currentMapType == 1){
        if(!self.aheadMapImage){
            if (self.language == 11){//简体中文
                [self.mainStateView.lbl_notes setText:@"请稍后..."];
            }else if(self.language == 10){//繁体中文
                [self.mainStateView.lbl_notes setText:@"请稍后..."];
            }else{
                [self.mainStateView.lbl_notes setText:@"Waiting..."];
            }
            self.mainStateView.lbl_waiting_annimation.waitingAnimation = YES;
        }
    }
    
}
//停止mainview请求动画——成功
- (void)stopRequestAnimationMainView{
    [self.mainStateView.lbl_notes setText:@""];
    self.mainStateView.lbl_waiting_annimation.waitingAnimation = NO;
}
//停止mainview动画——失败
- (void)stopRequestAnimationMainViewAfterFaild{
    //没有图显示，或者有图但是时间>10分钟显示
    if(self.currentMapType == 0){
        if(!self.cityOverviewImage||((self.cityOverviewImage != nil)&&([self getNowTime]-self.lastOverViewTime)>OVERDUETIME)){
            [self.mainStateView.lbl_notes setText:@"请求失败，请检查网络"];
            self.mainStateView.lbl_waiting_annimation.waitingAnimation = NO;
            self.cityOverviewImage = nil;
        }
    }else if(self.currentMapType == 1){
        if(!self.aheadMapImage||((self.aheadMapImage != nil)&&([self getNowTime]-self.lastAheadTime)>OVERDUETIME)){
            [self.mainStateView.lbl_notes setText:@"请求失败，请检查网络"];
            self.mainStateView.lbl_waiting_annimation.waitingAnimation = NO;
            self.aheadMapImage = nil;
        }
    }
}

//显示areaview请求动画
- (void)startRequestAnimationAreaView{
    //    UIImage *lastImage = [self.areaImageDic objectForKey:[NSString stringWithFormat:@"%i",self.selectedAreaIndex]];
    //    if(!lastImage){
    
    if (self.language == 11){//简体中文
        [self.areaStateView.lbl_notes setText:@"请稍后..."];
    }else if(self.language == 10){//繁体中文
        [self.areaStateView.lbl_notes setText:@"请稍后..."];
    }else{
        [self.areaStateView.lbl_notes setText:@"Waiting..."];
    }
    self.areaStateView.lbl_waiting_annimation.waitingAnimation = YES;
    //    }
}

//停止areaview请求动画——成功
- (void)stopRequestAnimationAreaView{
    [self.areaStateView.lbl_notes setText:@""];
    self.areaStateView.lbl_waiting_annimation.waitingAnimation = NO;
}
//停止areaview请求动画——失败
- (void)stopRequestAnimationAreaViewAfterFaild{
    long lastTime = [[self.lastAreaTimeDic objectForKey:[NSString stringWithFormat:@"%i",self.selectedAreaIndex]] longLongValue];
    if(![self.areaImageDic objectForKey:[NSString stringWithFormat:@"%i",self.selectedAreaIndex]]||
       (([self.areaImageDic objectForKey:[NSString stringWithFormat:@"%i",self.selectedAreaIndex]] != nil)&&([self getNowTime]-lastTime)>OVERDUETIME)){
        [self.areaStateView.lbl_notes setText:@"请求失败，请检查网络"];
        self.areaStateView.lbl_waiting_annimation.waitingAnimation = NO;
        [self.areaImageDic removeObjectForKey:[NSString stringWithFormat:@"%i",self.selectedAreaIndex]];
    }
}
//停止mainview动画——404
- (void)stopRequestAnimationMainView404{
    if(self.currentMapType == 0){
        if(!self.cityOverviewImage||((self.cityOverviewImage != nil)&&([self getNowTime]-self.lastOverViewTime)>OVERDUETIME)){
            [self.mainStateView.lbl_notes setText:@"参数错误"];
            self.mainStateView.lbl_waiting_annimation.waitingAnimation = NO;
            self.cityOverviewImage = nil;
        }
    }else if(self.currentMapType == 1){
        if(!self.aheadMapImage||((self.aheadMapImage != nil)&&([self getNowTime]-self.lastAheadTime)>OVERDUETIME)){
            [self.mainStateView.lbl_notes setText:@"参数错误"];
            self.mainStateView.lbl_waiting_annimation.waitingAnimation = NO;
            self.aheadMapImage = nil;
            
        }
    }
}
//停止areaview请求动画——404
- (void)stopRequestAnimationAreaView404{
    long lastTime = [[self.lastAreaTimeDic objectForKey:[NSString stringWithFormat:@"%i",self.selectedAreaIndex]] longLongValue];
    if(![self.areaImageDic objectForKey:[NSString stringWithFormat:@"%i",self.selectedAreaIndex]]||
       (([self.areaImageDic objectForKey:[NSString stringWithFormat:@"%i",self.selectedAreaIndex]] != nil)&&([self getNowTime]-lastTime)>OVERDUETIME)){
        [self.areaStateView.lbl_notes setText:@"参数错误"];
        self.areaStateView.lbl_waiting_annimation.waitingAnimation = NO;
        [self.areaImageDic removeObjectForKey:[NSString stringWithFormat:@"%i",self.selectedAreaIndex]];
    }
}
//停止mainview动画——405
- (void)stopRequestAnimationMainView405{
    if(self.currentMapType == 0){
        if(!self.cityOverviewImage||((self.cityOverviewImage != nil)&&([self getNowTime]-self.lastOverViewTime)>OVERDUETIME)){
            [self.mainStateView.lbl_notes setText:@"该位置无信息"];
            self.mainStateView.lbl_waiting_annimation.waitingAnimation = NO;
            self.cityOverviewImage = nil;
        }
    }else if(self.currentMapType == 1){
        if(!self.aheadMapImage||((self.aheadMapImage != nil)&&([self getNowTime]-self.lastAheadTime)>OVERDUETIME)){
            [self.mainStateView.lbl_notes setText:@"该位置无信息"];
            self.mainStateView.lbl_waiting_annimation.waitingAnimation = NO;
            self.aheadMapImage = nil;
        }
    }
}
//停止areaview请求动画——405
- (void)stopRequestAnimationAreaView405{
    long lastTime = [[self.lastAreaTimeDic objectForKey:[NSString stringWithFormat:@"%i",self.selectedAreaIndex]] longLongValue];
    if(![self.areaImageDic objectForKey:[NSString stringWithFormat:@"%i",self.selectedAreaIndex]]||
       (([self.areaImageDic objectForKey:[NSString stringWithFormat:@"%i",self.selectedAreaIndex]] != nil)&&([self getNowTime]-lastTime)>OVERDUETIME)){
        [self.areaStateView.lbl_notes setText:@"该位置无信息"];
        self.areaStateView.lbl_waiting_annimation.waitingAnimation = NO;
        [self.areaImageDic removeObjectForKey:[NSString stringWithFormat:@"%i",self.selectedAreaIndex]];
    }
}

//停止mainview动画——406
- (void)stopRequestAnimationMainView406{
    if(self.currentMapType == 0){
        //        if(!self.cityOverviewImage||((self.cityOverviewImage != nil)&&([self getNowTime]-self.lastOverViewTime)>OVERDUETIME)){
        [self.mainStateView.lbl_notes setText:@"不在服务区"];
        self.mainStateView.lbl_waiting_annimation.waitingAnimation = NO;
        self.cityOverviewImage = nil;
        self.mainStateView.img_main_screen_map.imageData = nil;
        //        }
    }else if(self.currentMapType == 1){
        //        if(!self.aheadMapImage||((self.aheadMapImage != nil)&&([self getNowTime]-self.lastAheadTime)>OVERDUETIME)){
        [self.mainStateView.lbl_notes setText:@"不在服务区"];
        self.mainStateView.lbl_waiting_annimation.waitingAnimation = NO;
        self.aheadMapImage = nil;
        self.mainStateView.img_main_screen_ahead.imageData = nil;
        self.mainStateView.img_main_screen_location.visible = NO;
        //        }
    }
    
}
//停止areaview请求动画——406
- (void)stopRequestAnimationAreaView406{
    //    long lastTime = [[self.lastAreaTimeDic objectForKey:[NSString stringWithFormat:@"%i",self.selectedAreaIndex]] longLongValue];
    //    if(![self.areaImageDic objectForKey:[NSString stringWithFormat:@"%i",self.selectedAreaIndex]]||
    //       (([self.areaImageDic objectForKey:[NSString stringWithFormat:@"%i",self.selectedAreaIndex]] != nil)&&([self getNowTime]-lastTime)>OVERDUETIME)){
    [self.areaStateView.lbl_notes setText:@"不在服务区"];
    self.areaStateView.lbl_waiting_annimation.waitingAnimation = NO;
    [self.areaImageDic removeObjectForKey:[NSString stringWithFormat:@"%i",self.selectedAreaIndex]];
    //    }
}

#pragma mark - ASIHTTPRequest
- (void)playSound:(NSData*)soundData{
    if (self.avAudioPlayer != nil) {
        [self.avAudioPlayer stop];
        [self.avAudioPlayer release];
        self.avAudioPlayer = nil;
    }
    NSError *error;
    self.avAudioPlayer = [[AVAudioPlayer alloc] initWithData:soundData error:&error];
    [self.avAudioPlayer setNumberOfLoops:1];
    [self.avAudioPlayer prepareToPlay];
    [self.avAudioPlayer setVolume:10];
    [self.avAudioPlayer play];
}

- (void)stopSound{
    if (self.avAudioPlayer != nil) {
        [self.avAudioPlayer stop];
        [self.avAudioPlayer release];
        self.avAudioPlayer = nil;
    }
}

- (void)useNextPreButton{
    [self stopRequestAnimationAreaView];
    self.areaStateView.btn_area_state_previous.enabled = YES;
    self.areaStateView.btn_area_state_next.enabled = YES;
    if(self.selectedAreaIndex == 0){
        self.areaStateView.btn_area_state_previous.enabled = NO;
    }
    if(self.selectedAreaIndex == [self.routeList count]-1){
        self.areaStateView.btn_area_state_next.enabled = NO;
    }
}
- (void)requestFinished:(ASIHTTPRequest *)request{
    NSString *responseString = [request responseString];
    switch (request.tag) {
        case 5001:{
            UIImage *image = [[UIImage alloc] initWithData:[request responseData]];
            self.cityOverviewImage = image;
            long publishedtime = [self getNowTime];
            self.lastOverViewTime = publishedtime;
            [self.cennaviCache updateCityMapInfo:self.oneCityMap.mapId :image :publishedtime :self.oneCityMap.refreshTime*60 :self.oneCityMap.text];
            if(self.currentMapType == 0){
                [self displayAhead:NO];
                self.mainStateView.img_main_screen_map.imageData = [image idPNGImageData];
            }
            [self stopRequestAnimationMainView];
            break;
        }
        case 5002:{
            UIImage *image = [[UIImage alloc] initWithData:[request responseData]];
            self.aheadMapImage = image;
            long publishedtime = [self getNowTime];
            self.lastAheadTime = publishedtime;
            if(self.currentMapType == 1){
                [self displayAhead:YES];
                self.mainStateView.img_main_screen_ahead.imageData = [image idPNGImageData];
                [self performSelector:@selector(moveLoc) withObject:nil afterDelay:1.5];
            }
            [self stopRequestAnimationMainView];
            break;
        }
        case 5003:{
            UIImage *image = [[UIImage alloc] initWithData:[request responseData]];
            NSString *index = [NSString stringWithFormat:@"%i",self.selectedAreaIndex];
            [self.areaImageDic setObject:image forKey:index];
            
            long publishedtime = [self getNowTime];
            [self.lastAreaTimeDic setObject:[NSString stringWithFormat:@"%li",publishedtime] forKey:index];
            NSDictionary *route = [self.routeList objectAtIndex:self.selectedAreaIndex];
            [self.cennaviCache updateAreaMapInfo:self.oneAreaMap.mapId :image :publishedtime :self.oneAreaMap.refreshTime*60 :self.oneAreaMap.text];
            
            if([[route objectForKey:@"graphic_id"] isEqualToString:self.oneAreaMap.mapId]){//如果要显示的图片名称和数据相同
                self.areaStateView.img_area_state_map.imageData = [image idPNGImageData];
            }
            [self performSelector:@selector(useNextPreButton) withObject:nil afterDelay:1];
            break;
        }
        case 1001:{
            //解析全域图返回结果
            SBJsonParser *jsonParser = [[SBJsonParser alloc]init];
            NSDictionary *result = [jsonParser objectWithString:responseString];
            [jsonParser release];
            if(result){
                int status = [[result objectForKey:@"status"] intValue];
                if(status != 1){
                    [self displayLastImageAfterFailed:0];
                    switch (status) {
                        case 404:
                        {
                            [self stopRequestAnimationMainView404];
                            break;
                        }
                        case 405:
                        {
                            [self stopRequestAnimationMainView405];
                            break;
                        }
                        case 406:
                        {
                            [self stopRequestAnimationMainView406];
                            break;
                        }
                        default:
                            break;
                            
                    }
                    [self performSelector:@selector(timerCityMapTimeUp) withObject:nil afterDelay:30];
                    return;
                }
                NSString *imageURL = [result objectForKey:@"graphUrl"];
                NSString *Updateinterval = [result objectForKey:@"updateinterval"];
                self.oneCityMap.refreshTime = [Updateinterval intValue];
                NSString *Graphic_id = [result objectForKey:@"graphic_id"];
                self.oneCityMap.mapId = Graphic_id;
                //                NSString *SpeechText = [result objectForKey:@"speechText"];
                //                self.oneCityMap.text = SpeechText;
                //                NSString *voiceURL = [result objectForKey:@"voiceUrl"];
                
                NSURL *url = [NSURL URLWithString:imageURL];
                ASIHTTPRequest *Imagerequest = [ASIHTTPRequest requestWithURL:url];
                Imagerequest.tag = 5001;
                Imagerequest.timeOutSeconds = TIMEOUTSECOND;
                [Imagerequest setDelegate:self];
                [Imagerequest startAsynchronous];
                //                UIImage *image0 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"aaa" ofType:@"png"]];
                //                self.mainStateView.img_main_screen_map.imageData = [image0 idPNGImageData];
                [self performSelector:@selector(timerCityMapTimeUp) withObject:nil afterDelay:[Updateinterval intValue]*60];
                
            }
            break;
        }
        case 1002:{
            self.isRequestAhead = NO;
            SBJsonParser *jsonParser = [[SBJsonParser alloc]init];
            NSDictionary *result = [jsonParser objectWithString:responseString];
            [jsonParser release];
            if(result){
                int status = [[result objectForKey:@"status"] intValue];
                if(status != 1){
                    [self displayLastImageAfterFailed:1];
                    switch (status) {
                        case 404:
                        {
                            [self stopRequestAnimationMainView404];
                            break;
                        }
                        case 405:
                        {
                            [self stopRequestAnimationMainView405];
                            break;
                        }
                        case 406:
                        {
                            [self stopRequestAnimationMainView406];
                            break;
                        }
                        default:
                            break;
                    }
                    return;
                }
                NSString *imageURL = [result objectForKey:@"graphUrl"];
                NSString *timestamp = [result objectForKey:@"timestamp"];
                NSString *Updateinterval = [result objectForKey:@"updateinterval"];
                self.oneAheadMap.refreshTime = [Updateinterval intValue];
                NSString *Graphic_id = [result objectForKey:@"graphic_id"];
                self.oneAheadMap.mapId = Graphic_id;
                NSString* pixelXY = [result objectForKey:@"pixelXY"];
                if(pixelXY){
                    NSArray* arr_parts = [pixelXY componentsSeparatedByString:@","];
                    float x = [[arr_parts objectAtIndex:0]floatValue];
                    float y = [[arr_parts objectAtIndex:1]floatValue];
                    self.ahead_loc_x = x-4;
                    self.ahead_loc_y = y-11;
                }
                
                
                NSURL *url = [NSURL URLWithString:imageURL];
                //如果和保存的时间戳或者图片id不同，则请求图片
                if([self.graphic_idAhead isEqualToString:@""]||[self.timestampAhead isEqualToString:@""]||![self.timestampAhead isEqualToString:timestamp]||![self.graphic_idAhead isEqualToString:Graphic_id]){
                    ASIHTTPRequest *Imagerequest = [ASIHTTPRequest requestWithURL:url];
                    Imagerequest.tag = 5002;
                    Imagerequest.timeOutSeconds = TIMEOUTSECOND;
                    [Imagerequest setDelegate:self];
                    [Imagerequest startAsynchronous];
                    //记录下要显示前方图片的时间戳以及图片id
                    self.timestampAhead = timestamp;
                    self.graphic_idAhead = Graphic_id;
                }else{
                    if(self.mainStateView.img_main_screen_ahead.imageData){//如果前方图背景有图
                        [self moveLoc];
                    }
                }
                
            }
            break;
        }
        case 1003:{
            SBJsonParser *jsonParser = [[SBJsonParser alloc]init];
            NSDictionary *result = [jsonParser objectWithString:responseString];
            [jsonParser release];
            if(result){
                self.routeList = [result objectForKey:@"list"];
                self.cityName = [result objectForKey:@"city_name"];
                [self initRoutList];
            }
            break;
        }
        default:
            break;
    }
    if(request.tag == self.selectedAreaIndex){
        SBJsonParser *jsonParser = [[SBJsonParser alloc]init];
        NSDictionary *result = [jsonParser objectWithString:responseString];
        [jsonParser release];
        if(result){
            int status = [[result objectForKey:@"status"] intValue];
            if(status != 1){
                [self displayLastImageAfterFailed:3];
                switch (status) {
                    case 404:
                    {
                        [self stopRequestAnimationAreaView404];
                        break;
                    }
                    case 405:
                    {
                        [self stopRequestAnimationAreaView405];
                        break;
                    }
                    case 406:
                    {
                        [self stopRequestAnimationAreaView406];
                        break;
                    }
                    default:
                        break;
                }
                [self performSelector:@selector(timerAreaMapTimeUp:) withObject:[NSString stringWithFormat:@"%i",self.selectedAreaIndex] afterDelay:30];
                return;
            }
            NSArray *routeArray = [result objectForKey:@"list"];
            NSDictionary *routedic = [routeArray objectAtIndex:0];
            NSString *imageURL = [routedic objectForKey:@"graphUrl"];
            NSString *Updateinterval = [result objectForKey:@"updateinterval"];
            self.oneAreaMap.refreshTime = [Updateinterval intValue];
            NSString *Graphic_id = [routedic objectForKey:@"graphic_id"];
            self.oneAreaMap.mapId = Graphic_id;
            
            
            NSURL *url = [NSURL URLWithString:imageURL];
            ASIHTTPRequest *Imagerequest = [ASIHTTPRequest requestWithURL:url];
            Imagerequest.tag = 5003;
            Imagerequest.timeOutSeconds = TIMEOUTSECOND;
            [Imagerequest setDelegate:self];
            [Imagerequest startAsynchronous];
            [self performSelector:@selector(timerAreaMapTimeUp:) withObject:[NSString stringWithFormat:@"%i",self.selectedAreaIndex] afterDelay:[Updateinterval intValue]*60];
            
        }
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    switch (request.tag) {
        case 1001://citymap请求失败
        {
            if(self.currentMapType == 0){//失败的时候还在citymap页面，过20秒执行
                [self performSelector:@selector(timerCityMapTimeUp) withObject:nil afterDelay:20];
                [self displayLastImageAfterFailed:0];
            }
            [self stopRequestAnimationMainViewAfterFaild];
            break;
        }
        case 1002://ahead请求失败
        {
            self.isRequestAhead = NO;
            if(self.currentMapType == 1){
                [self displayLastImageAfterFailed:1];
            }
            [self stopRequestAnimationMainViewAfterFaild];
            break;
        }
        case 5002:
        {
            self.graphic_idAhead = @"";
            self.timestampAhead = @"";
            break;
        }
        case 5003:
        {
            self.areaStateView.btn_area_state_previous.enabled = YES;
            self.areaStateView.btn_area_state_next.enabled = YES;
            if(self.selectedAreaIndex == 0){
                self.areaStateView.btn_area_state_previous.enabled = NO;
            }
            if(self.selectedAreaIndex == [self.routeList count]-1){
                self.areaStateView.btn_area_state_next.enabled = NO;
            }
        }
        default:
            break;
    }
    if(request.tag == self.selectedAreaIndex && self.currentMapType == 3){//表示还在请求开始时的area页面
        [self performSelector:@selector(timerAreaMapTimeUp:) withObject:[NSString stringWithFormat:@"%i",self.selectedAreaIndex] afterDelay:20];
        self.areaStateView.btn_area_state_previous.enabled = YES;
        self.areaStateView.btn_area_state_next.enabled = YES;
        if(self.selectedAreaIndex == 0){
            self.areaStateView.btn_area_state_previous.enabled = NO;
        }
        if(self.selectedAreaIndex == [self.routeList count]-1){
            self.areaStateView.btn_area_state_next.enabled = NO;
        }
        [self displayLastImageAfterFailed:3];
        [self stopRequestAnimationAreaViewAfterFaild];
    }
    
    
}
- (void)moveLoc{
    if(self.currentMapType == 1){
        //图片坐标转屏幕坐标
        self.ahead_loc_x = self.ahead_loc_x - 4;
        self.ahead_loc_y = self.ahead_loc_y - 11;
        //将坐标控制范围
        if(self.ahead_loc_x < 125)self.ahead_loc_x = 125;
        if(self.ahead_loc_x > 385)self.ahead_loc_x = 385;
        if(self.ahead_loc_y < 125)self.ahead_loc_y = 125;
        if(self.ahead_loc_y > 284)self.ahead_loc_y = 284;
        [self.mainStateView.img_main_screen_location setPosition:CGPointMake(self.ahead_loc_x-125, self.ahead_loc_y-125)];
        self.mainStateView.img_main_screen_location.visible = YES;
    }
    
}
- (void)displayLastImageAfterFailed:(int)mapType{
    switch (self.currentMapType) {
        case 0:
        {
            [self displayAhead:NO];
            if(self.cityOverviewImage){//使用最近一次下载的全图
                if([self getNowTime] - self.lastOverViewTime < OVERDUETIME){//且时间不超过指定时间
                    self.mainStateView.img_main_screen_map.imageData = [self.cityOverviewImage idPNGImageData];
                }else{
                    self.mainStateView.img_main_screen_map.imageData = nil;
                }
            }
            break;
        }
        case 1:
        {
            [self displayAhead:YES];
            if(self.aheadMapImage){//使用最近一次下载的全图
                if([self getNowTime] - self.lastAheadTime < OVERDUETIME){//且时间不超过指定时间
                    self.mainStateView.img_main_screen_ahead.imageData = [self.aheadMapImage idPNGImageData];
                    self.mainStateView.img_main_screen_location.visible = YES;
                }else{
                    self.mainStateView.img_main_screen_ahead.imageData = nil;
                    self.mainStateView.img_main_screen_location.visible = NO;
                }
            }
            break;
        }
        case 3:
        {
            if([self.areaImageDic objectForKey:[NSString stringWithFormat:@"%i",self.selectedAreaIndex]]){
                long lastTime = [[self.lastAreaTimeDic objectForKey:[NSString stringWithFormat:@"%i",self.selectedAreaIndex]] longLongValue];
                if([self getNowTime] - lastTime < OVERDUETIME){
                    self.areaStateView.img_area_state_map.imageData = [[self.areaImageDic objectForKey:[NSString stringWithFormat:@"%i",self.selectedAreaIndex]] idPNGImageData];
                }else{
                    self.areaStateView.img_area_state_map.imageData = nil;
                }
            }
            break;
        }
        default:
            break;
    }
}
- (void)initRoutList{
    self.areaListStateView.lbl_area_list_state_city_name.text = self.cityName;
    //测试代码，在列表的标题行显示经纬度、speed和direction
    //    self.areaListStateView.lbl_area_list_state_city_name.text = [NSString stringWithFormat:@"%f,%f,%i,%i",self.gpsLatitude,self.gpsLongitude,self.speed,self.direction];
    
    [self.areaListStateView.table_area_list_state_area_name setRowCount:[self.routeList count] columnCount:1];
    //[self.areaListStateView.table_area_list_state_area_name setColumnWidths:[NSArray arrayWithObjects: [NSNumber numberWithInt:400],nil]];
    for (int i = 0; i < [self.routeList count]; ++i) {
        NSDictionary *routeDic = [self.routeList objectAtIndex:i];
        [self.areaListStateView.table_area_list_state_area_name setCell:[IDTableCell tableCellWithString:[routeDic valueForKey:@"name"]] atRow:i column:0];
    }
}
- (void)updateCurrentView{
    if (!((self.brand == IDVehicleBrandBMW) && (self.rhmiType == IDVehicleHmiTypeID4)))
    {
        //Not CIC
         return;
    }
    //    self.direction = arc4random() % 360;
    //
    //    [self performSelectorOnMainThread:@selector(rotateAndDisplay) withObject:nil waitUntilDone:NO];
    switch (self.currentMapType) {
        case 0:
        {//全图
            TrafficMap* trafficmap = [[CenNaviCache getCacheInstance] getCityMap];
            if(trafficmap != nil){
                //                [self displayAhead:NO];
                //                if(!self.cityOverviewImage){
                //                    self.mainStateView.img_main_screen_map.imageData = [trafficmap.image idPNGImageData];
                //                }
                
            }else{//
                NSLog(@"网络请求");
                //                NSURL *url = [NSURL URLWithString:@"http://211.151.84.15:20880/GraphicService/getGraphOverview?op=gct&CustomID=customID&Clat=39.909736&Clon=116.415253&format=png&mod=103&CarDirection=222&DriveSpeed=333&CarType=444"];
                //下面路测用
                int thisSpeed = self.speed>0?self.speed:self.speedFromIphone;
                thisSpeed = thisSpeed<0?0:thisSpeed;
                self.direction = self.direction < 0 ? 0:self.direction;
                self.direction = self.direction > 360 ? 360:self.direction;
                //                NSLog(@"speed is %i",thisSpeed);
                //                NSLog(@"direction is %i",self.direction);
                //                NSLog(@"lat is %f",self.gpsLatitude);
                //                NSLog(@"lon is %f",self.gpsLongitude);
#ifdef BENDI
                self.gpsLatitude = 39.909736;
                self.gpsLongitude = 116.415253;
                //                self.direction = 1;
                //                self.gpsLatitude = 30.909736;
                //                self.gpsLongitude = 121.415253;
#endif
                NSString *urlstr = [NSString stringWithFormat:@"http://211.151.84.15:20880/GraphicService/getGraphOverview.json?op=gct&CustomID=customID&Clat=%f&Clon=%f&format=png&mod=103&CarDirection=%i&DriveSpeed=%i&CarType=444",[self getLatitude],[self getLongitude],self.direction,thisSpeed];
                NSLog(@"url is %@",urlstr);
                NSURL *url = [NSURL URLWithString:urlstr];
                self.requestMainCity = [ASIHTTPRequest requestWithURL:url];
                self.requestMainCity.tag = 1001;
                self.requestMainCity.timeOutSeconds = TIMEOUTSECOND;
                [self.requestMainCity setDelegate:self];
                [self.requestMainCity startAsynchronous];
                [self startRequestAnimationMainView];
            }
            break;
        }
        case 1:
        {
            if(self.isRequestAhead)return;
            NSLog(@"网络请求");
            //                NSURL *url = [NSURL URLWithString:@"http://211.151.84.15:20880/GraphicService/getGraphicbylatlon?op=gxy&clon=116.379126&clat=39.90998&carDirection=270&customID=ustomID&sort=1&driveSpeed=1"];
            
            //下面路测用
            int thisSpeed = self.speed>0?self.speed:self.speedFromIphone;
            thisSpeed = thisSpeed<0?0:thisSpeed;
            self.direction = self.direction < 0 ? 0:self.direction;
            self.direction = self.direction > 360 ? 360:self.direction;
#ifdef BENDI
            self.gpsLatitude = 39.909736;
            self.gpsLongitude = 116.415253;
            //                self.direction = 50;
#endif
            NSString *urlstr = [NSString stringWithFormat:@"http://211.151.84.15:20880/GraphicService/getGraphicbylatlon.json?op=gxy&clon=%f&clat=%f&carDirection=%i&customID=ustomID&sort=1&driveSpeed=%i",[self getLongitude],[self getLatitude],self.direction,thisSpeed];
            NSLog(@"url is %@",urlstr);
            NSURL *url = [NSURL URLWithString:urlstr];
            [self.requestAheadMap clearDelegatesAndCancel];
            [self.requestAheadMap cancel];
            self.requestAheadMap = [ASIHTTPRequest requestWithURL:url];
            self.requestAheadMap.tag = 1002;
            self.requestAheadMap.timeOutSeconds = TIMEOUTSECOND;
            [self.requestAheadMap setDelegate:self];
            [self.requestAheadMap startAsynchronous];
            self.isRequestAhead = YES;
            [self startRequestAnimationMainView];
            //            }
            break;
        }
        case 3:
        {
            NSString *selectMapId = [[self.routeList objectAtIndex:self.selectedAreaIndex] objectForKey:@"graphic_id"];
            TrafficMap* trafficmap = [[CenNaviCache getCacheInstance] getAreaMapById:selectMapId];
            if(trafficmap != nil){
                self.areaStateView.img_area_state_map.imageData = [trafficmap.image idPNGImageData];
                [self stopRequestAnimationAreaView];
            }else{//
                NSLog(@"网络请求");
                //                NSString* str_url = @"http://211.151.84.15:20880/GraphicService/getGraphicbyID?op=gid&bzcode=A4A&graphic_id=0010_103_001,0010_104_001&customID=customID";
                NSString *str_url = [NSString stringWithFormat:@"http://211.151.84.15:20880/GraphicService/getGraphicbyID.json?op=gid&bzcode=A4A&graphic_id=%@&customID=customID",selectMapId];
                NSURL *url= [ NSURL URLWithString : str_url];
                [self.requestAreaMap cancel];//新请求一个request一定先把之前的cancel
                self.requestAreaMap = [ASIHTTPRequest requestWithURL:url];
                self.requestAreaMap.timeOutSeconds = TIMEOUTSECOND;
                self.requestAreaMap.tag = self.selectedAreaIndex;
                [self.requestAreaMap setDelegate:self];
                [self.requestAreaMap startAsynchronous];
                [self startRequestAnimationAreaView];
                self.areaStateView.btn_area_state_previous.enabled = NO;
                self.areaStateView.btn_area_state_next.enabled = NO;
            }
            break;
        }
        default:
            break;
    }
}
- (long)getNowTime{
    NSDate *datenow = [NSDate date];
    NSTimeInterval timeinterval = [datenow timeIntervalSince1970];
    return timeinterval;
}
- (void)timerCityMapTimeUp{
    //时间走到，首先要将响应缓存清空,确保下次取图时一定会网络请求
    [self.cennaviCache clearCityMapInfo];
    if(0 == self.currentMapType){//如果在全图页面
        [self updateCurrentView];
    }
}

- (void)timerAreaMapTimeUp:(NSString *) areaIndexStr{
    int areaIndex = [areaIndexStr intValue];
    //时间走到，首先要将响应缓存清空,确保下次取图时一定会网络请求
    NSLog(@"area时间到,timer启动时index是%i",areaIndex);
    [self.cennaviCache clearOneAreaMapInfo:[[self.routeList objectAtIndex:areaIndex] objectForKey:@"graphic_id"]];
    if(3 == self.currentMapType && self.selectedAreaIndex == areaIndex){//如果在商圈图页面,并且没变页面
        NSLog(@"在商圈图页面并且index是%i，当前选择的是%i",areaIndex,self.selectedAreaIndex);
        [self updateCurrentView];
    }
}
- (float)getLatitude{
    if([self isCarGpsAvailable]){
        return self.gpsLatitude;
    }else{
        return self.gpsLatitudeFromMobile;
    }
}
- (float)getLongitude{
    if([self isCarGpsAvailable]){
        return self.gpsLongitude;
    }else{
        return self.gpsLongitudeFromMobile;
    }
}



@end
