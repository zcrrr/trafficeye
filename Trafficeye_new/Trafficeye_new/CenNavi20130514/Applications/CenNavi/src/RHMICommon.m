//
//  RHMICommon.m
//  MiniNavi
//
//  Created by Don Hao on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RHMICommon.h"
#import "CenNaviIdentifiers.h"

@implementation CenNaviFeatureController (RHMICommon)

-(void)RHMICommonSetComponentEnabledWithID:(NSInteger)ID isEnabled:(BOOL)isEnabled
{
    IDVariantMap* map = [[[IDVariantMap alloc] init] autorelease];
    
    [map setVariant:[IDVariantData variantWithBoolean:isEnabled] forId:IDParameterValue];
    
    [self.hmiService setProperty:IDPropertyEnabled forComponent:ID variantMap:map];
}

-(void)RHMICommonSetComponentVisiableWithID:(NSInteger)ID isVisiable:(BOOL)isVisiable
{
    IDVariantMap* map = [[[IDVariantMap alloc] init] autorelease];
    
    [map setVariant:[IDVariantData variantWithBoolean:isVisiable] forId:IDParameterValue];
    
    [self.hmiService setProperty:IDPropertyVisible forComponent:ID variantMap:map];
}

-(void)RHMICommonSetComponentSelectableWithID:(NSInteger)ID isSelectable:(BOOL)isSelectable
{
    IDVariantMap* map = [[[IDVariantMap alloc] init] autorelease];
    
    [map setVariant:[IDVariantData variantWithBoolean:isSelectable] forId:IDParameterValue];
    
    [self.hmiService setProperty:IDPropertySelectable forComponent:ID variantMap:map];
}

-(void)RHMICommonSetModelWithID:(NSInteger)ID valueWithString:(NSString*)value
{
    [self.hmiService setDataModel:ID variantData:[IDVariantData variantWithString:value]];
}

-(void)RHMICommonSetModelWithID:(NSInteger)ID valueWithBOOL:(BOOL)value
{
    [self.hmiService setDataModel:ID variantData:[IDVariantData variantWithBoolean:value]];
}

-(void)RHMICommonSetModelWithID:(NSInteger)ID valueWithImage:(NSString*)imageName
{
    UIImage* icon = [UIImage imageNamed:imageName];
    
    [self.hmiService setDataModel:ID variantData:[IDVariantData variantWithImageData:UIImagePNGRepresentation(icon)]];
}

-(void)RHMICommonOpenPopup:(NSInteger)ID
{
	[self.hmiService triggerHmiEvent:ID];
}

-(void)RHMICommonClosePopup:(NSInteger)ID
{
    IDVariantMap* map = [IDVariantMap variantMapWithVariant:[IDVariantData variantWithBoolean:NO] forId:IDParameterValue];
	[self.hmiService triggerHmiEvent:ID parameterMap:map];
}

-(void)RHMICommonSetListWithID:(NSInteger)ID withStringList:(NSArray*)list
{
    IDTableData *tableData = [[[IDTableData alloc] initWithCapacity:list.count columns:1] autorelease];
    
    for(int i = 0; i < list.count; ++i)
    {
        IDTableRow *tableRow = [IDTableRow rowWithColumns:1];
        
        [tableRow setItem:[IDVariantData variantWithString:[list objectAtIndex:i]] atColumn:0];
        
        [tableData addRow:tableRow];
    }
    
    [self.hmiService setListModel:ID tableData:tableData];
}

-(BOOL)RHMICommonDlgIsFocused:(IDVariantMap*)infoMap
{
    IDVariantData* param = [infoMap variantForId:IDParameterHmiEventFocus];
    
    BOOL value = [param booleanValue];
    
    return value;
}

-(UIImage*)RHMICommonPSPNG:(NSString*)iconName
{
    UIImage* tmpImg = [UIImage imageNamed:iconName];
    
    // prepare an area of 50*50
    CGSize size = {50, 50};
    UIGraphicsBeginImageContext(size);
    
    // wirte a 32*32 image to the center of the area of 50*50
    [tmpImg drawInRect:CGRectMake(9, 9, tmpImg.size.width, tmpImg.size.height)];
    
    
    UIImage* icon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return icon;
}

-(void)playAudio:(NSString *)fileName{

    if (self.avAudioPlayer != nil) {
        [self.avAudioPlayer stop];
        [self.avAudioPlayer release];
        self.avAudioPlayer = nil;
    }
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"start_guidance" ofType:@"mp3"];
    NSURL *URL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    
    NSError *error;
    self.avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:&error];
    [self.avAudioPlayer setNumberOfLoops:1];
    [self.avAudioPlayer prepareToPlay];
    [self.avAudioPlayer setVolume:10];
    [self.avAudioPlayer play];
    [URL release];
}
@end
