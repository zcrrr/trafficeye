//
//  RHMICommon.h
//  MiniNavi
//
//  Created by Don Hao on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//  Created by Don Hao Hao
#import "CenNaviFeatureController.h"
@interface CenNaviFeatureController (RHMICommon)

-(void)RHMICommonSetComponentEnabledWithID:(NSInteger)ID isEnabled:(BOOL)isEnabled;
-(void)RHMICommonSetComponentVisiableWithID:(NSInteger)ID isVisiable:(BOOL)isVisiable;
-(void)RHMICommonSetComponentSelectableWithID:(NSInteger)ID isSelectable:(BOOL)isSelectable;
-(void)RHMICommonSetModelWithID:(NSInteger)ID valueWithString:(NSString*)value;
-(void)RHMICommonSetModelWithID:(NSInteger)ID valueWithBOOL:(BOOL)value;
-(void)RHMICommonSetModelWithID:(NSInteger)ID valueWithImage:(NSString*)imageName;
-(void)RHMICommonOpenPopup:(NSInteger)ID;
-(void)RHMICommonClosePopup:(NSInteger)ID;
-(void)RHMICommonSetListWithID:(NSInteger)ID withStringList:(NSArray*)list;
-(BOOL)RHMICommonDlgIsFocused:(IDVariantMap*)infoMap;
-(UIImage*)RHMICommonPSPNG:(NSString*)iconName;

-(void)playAudio:(NSString*)fileName;
@end
