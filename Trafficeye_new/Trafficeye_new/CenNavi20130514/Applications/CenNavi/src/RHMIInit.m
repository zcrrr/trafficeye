//
//  RHMIInit.m
//  CenNaviDemo
//
//  Created by Don Hao on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RHMIInit.h"
#import "CenNaviInterface.h"
#import "CenNaviIdentifiers.h"

@implementation CenNaviFeatureController (RHMIInit)

-(void)bindStates{
    self.mainStateView = (MainStateView*)[self.hmiProvider viewForId:IDMainStateViewId];
    self.areaListStateView = (AreaListStateView*)[self.hmiProvider viewForId:IDAreaListStateViewId];
    self.areaStateView = (AreaStateView*)[self.hmiProvider viewForId:IDAreaStateViewId];
}

-(void)setBgImages{
    UIImage* image = [self getCurrentCityMap];
    self.mainStateView.img_main_screen_map.imageData = [image idPNGImageData];
}

-(void)setDefaultIcons{
    //Main screen
    [self buttonMainScreenCityOverviewDidPress:nil];
    
    //Sound
    self.enableSound = YES;
    NSString* image1FileName = nil;
    
    if (!((self.brand == IDVehicleBrandBMW) && (self.rhmiType == IDVehicleHmiTypeID4)))
    {
        self.mainStateView.title = @"";
    }
    else
    {
        // CIC
        //Set the bg
        //IDImageData
        if (self.language == 11){//简体中文
            self.mainStateView.title = @"城市路況";
        }else if(self.language == 10){//繁体中文
            self.mainStateView.title = @"城市路況";
        }else{
            self.mainStateView.title = @"City Overview";
        }
        image1FileName = [[[NSString alloc] initWithString:@"cic_sound_on"] autorelease];
    }
}

-(void)bindCDS{
    //Car Speed
    [self.cdsService bindProperty:CDSDrivingSpeedActual target:self selector:@selector(didReceiveSpeedActual:) completionBlock:nil];
    
    //RHMI Language
    [self.cdsService bindProperty:CDSVehicleLanguage target:self selector:@selector(didRHMILanguageChanged:) completionBlock:nil];
    
    //Steer Direction
//    [self.cdsService bindProperty:CDSDrivingSteeringwheel target:self selector:@selector(didSteeringWheel:) completionBlock:nil];
    
    //Gear
    //[self.cdsService bindProperty:CDSDrivingGear target:self selector:@selector(didGear:) completionBlock:nil];
    
    //Head Lights
//    [self.cdsService bindProperty:CDSControlsHeadlights target:self selector:@selector(didHeadLights:) completionBlock:nil];
    
    //Other Lights
    //[self.cdsService bindProperty:CDSControlsLights target:self selector:@selector(didLights:) completionBlock:nil];
    
    //GPS
    [self.cdsService bindProperty:CDSNavigationGPSPosition interval:1 target:self selector:@selector(didLocation:) completionBlock:nil];
    
//    [self.cdsService bindProperty:CDSNavigationGPSExtendedInfo interval:2 target:self selector:@selector(disHeadChanged:) completionBlock:nil];
}


-(void)bindActions{
    //Main Screen
    [self.mainStateView.btn_main_screen_city_overview setTarget:self selector:@selector(buttonMainScreenCityOverviewDidPress:) forActionEvent:IDActionEventSelect];
    [self.mainStateView.btn_main_screen_ahead_traffic setTarget:self selector:@selector(buttonMainScreenAheadTrafficDidPress:) forActionEvent:IDActionEventSelect];
//    [self.mainStateView.btn_main_screen_sound setTarget:self selector:@selector(buttonMainScreenSoundDidPress:) forActionEvent:IDActionEventSelect];
    [self.mainStateView.btn_main_screen_browse_areas setTarget:self selector:@selector(buttonMainScreenBrowseAreasDidPress:) forActionEvent:IDActionEventSelect];
    
    //Area List State
    [self.areaListStateView.table_area_list_state_area_name setDelegate:self];
    //Area State
    [self.areaStateView.btn_area_state_previous setTarget:self selector:@selector(buttonAreaStatePreviousDidPress:) forActionEvent:IDActionEventSelect];
    [self.areaStateView.btn_area_state_next setTarget:self selector:@selector(buttonAreaStateNextDidPress:) forActionEvent:IDActionEventSelect];
}

-(void)bindStateFocusEvent{
    [self.hmiService addHandlerForHmiEvent:IDEventFocus component:IDMainStateViewId target:self selector:@selector(didMainScreenFocused:)];
    [self.hmiService addHandlerForHmiEvent:IDEventFocus component:IDAreaListStateViewId target:self selector:@selector(didAreaListStateFocused:)];
    [self.hmiService addHandlerForHmiEvent:IDEventFocus component:IDAreaStateViewId target:self selector:@selector(didAreaStateFocused:)];
}

-(void)RHMIInit
{
    self.brand = self.hmiService.application.vehicleInfo.brand;
    self.rhmiType = self.hmiService.application.vehicleInfo.hmiType;
    self.isForward = YES;
    self.carHeading = -1;
    self.gpsLatitude = 0;
    self.gpsLongitude = 0;
    
    [self bindStates];
    [self bindStateFocusEvent];
    [self setBgImages];
    [self setDefaultIcons];
    [self bindCDS];
    [self bindActions];
    [self CenNaviInterfaceInit];
}

@end
