//
//  SDHMIViewController.m
//  Connected
//
//  Created by Rónán Ó Braonáin on 29/07/2010.
//  Copyright 2010 BMW Group. All rights reserved.
//

#import "SDHMIViewController.h"
#import "MCApplicationDataSource.h"

@implementation SDHMIViewController

@synthesize featureController = _featureController;

#pragma mark - Object Lifecycle

- (id)initWithFeatureController:(id<MCFeatureController>)featureController
{
    if ((self = [super init]))
	{
        _featureController = [featureController retain];
    }
    return self;
}

- (void)dealloc
{
    [_featureController release];    
	[super dealloc];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqual:@"hmiLanguage"]) {
        [self onHMILanguageChanged];
    } else if ([keyPath isEqual:@"hmiDistanceFormat"]) {
        [self onHMIDistanceFormatChanged];
    } else if ([keyPath isEqual:@"hmiDateFormat"]) {
        [self onHMIDateFormatChanged];
    } else if ([keyPath isEqual:@"hmiTimeFormat"]) {
        [self onHMITimeFormatChanged];
    }
}

#pragma mark - Stubs for event handlers
- (void) onHMILanguageChanged {
    return;
}

- (void) onHMIDistanceFormatChanged {
    return;
}

- (void) onHMIDateFormatChanged {
    return;
}

- (void) onHMITimeFormatChanged {
    return;
}

#pragma mark - Managing RHMI components

- (void)setListItem:(NSInteger)listId limitedTo3Lines:(BOOL)enabled
{
	NSInteger linesToShow;
	if (enabled) {
		linesToShow = 3;
	} else {
		linesToShow = -1;
	}
	
	IDVariantData *data = [IDVariantData variantWithInteger:linesToShow];
	IDVariantMap *map = [IDVariantMap new];
	[map setVariant:data forId:IDParameterValue];
	
	[[self.featureController hmiService] setProperty:IDPropertyListRichtextMaxRowCount
				   forComponent:listId
					 variantMap:map
                    completionBlock:nil];
	
	[map release];
}

- (void)setWidget:(NSInteger)widgetId enabled:(BOOL)enabled {
	IDVariantData *data = [IDVariantData variantWithBoolean:enabled];
	IDVariantMap *map = [IDVariantMap new];
	[map setVariant:data forId:IDParameterValue];
	[[self.featureController hmiService] setProperty:IDPropertyEnabled forComponent:widgetId variantMap: map completionBlock:nil];
	[map release];
}

- (void)setWidget:(NSInteger)widgetId visible:(BOOL)visible {
	IDVariantMap *visibleMap = [IDVariantMap new];
	[visibleMap setVariant:[IDVariantData variantWithBoolean:visible] forId:IDParameterValue];
	[[self.featureController hmiService] setProperty:IDPropertyVisible  
				   forComponent:widgetId
					 variantMap:visibleMap
                    completionBlock:nil];
	[visibleMap release];
}

- (void)setWaitingAnimationForWidget:(NSInteger)widgetId enabled:(BOOL)enabled {
	IDVariantData *data = [IDVariantData variantWithBoolean:enabled];
	IDVariantMap *map = [IDVariantMap new];
	[map setVariant:data forId:IDParameterValue];

    [[self.featureController hmiService] setProperty:IDPropertyLabelWaitingAnimation
                    forComponent:widgetId
                      variantMap:map
                 completionBlock:nil];
	[map release];
}


- (void)setToolbarButtonSelectable:(NSInteger)buttonId enabled:(BOOL)enabled
{
	IDVariantData* variant = [IDVariantData variantWithBoolean:enabled];
	IDVariantMap* variantMap = [IDVariantMap new];
	[variantMap setVariant:variant forId:IDParameterValue];
	[[self.featureController hmiService] setProperty:IDPropertySelectable forComponent:buttonId variantMap:variantMap completionBlock:nil];
	[variantMap release];
}

- (void)setToolbarButtonEnabled:(NSInteger)buttonId enabled:(BOOL)enabled
{
    [self setWidget:buttonId enabled:enabled];
}

- (void)setToolbarButtonVisible:(NSInteger)buttonId visible:(BOOL)visible;
{
    [self setWidget:buttonId visible:visible];
}

- (void)setToolbarButtonHidden:(NSInteger)buttonId imageModelId:(NSInteger)modelId blankIconId:(NSInteger)blankIconId
{
	IDVariantMap* variantMap = [IDVariantMap new];
	[variantMap setVariant:[IDVariantData variantWithBoolean:NO] forId:IDParameterValue];
	
	[[self.featureController hmiService] setProperty:IDPropertySelectable 
				   forComponent:buttonId
					 variantMap:variantMap completionBlock:nil];
	[[self.featureController hmiService] setProperty:IDPropertyEnabled 
				   forComponent:buttonId
					 variantMap:variantMap completionBlock:nil];
	
	IDVariantData *blankIcon = [IDVariantData variantWithImageId:blankIconId];
	
	[[self.featureController hmiService] setDataModel:modelId 
					 variantData:blankIcon completionBlock:nil];
	
	[variantMap release];
}

- (void)setToolbarButtonUnhidden:(NSInteger)buttonId imageModelId:(NSInteger)modelId iconId:(NSInteger)iconId
{
	IDVariantMap* variantMap = [IDVariantMap new];
	[variantMap setVariant:[IDVariantData variantWithBoolean:YES] forId:IDParameterValue];
	
	[[self.featureController hmiService] setProperty:IDPropertySelectable 
				   forComponent:buttonId
					 variantMap:variantMap
                    completionBlock:nil];
	[[self.featureController hmiService] setProperty:IDPropertyEnabled 
				   forComponent:buttonId
					 variantMap:variantMap
                    completionBlock:nil];
	
	IDVariantData *blankIcon = [IDVariantData variantWithImageId:iconId];
	
	[[self.featureController hmiService] setDataModel:modelId 
					 variantData:blankIcon completionBlock:nil];
	
	[variantMap release];
}

- (void)setImageModelId:(NSInteger)imageModelId withImageId:(NSInteger)imageId;
{
	IDVariantData *imageData = [IDVariantData variantWithImageId:imageId];
	
	[[self.featureController hmiService] setDataModel:imageModelId 
					 variantData:imageData completionBlock:nil];
}

- (void)setImageModelId:(NSInteger)imageModelId withPreInstImageId:(NSInteger)imageId {
    IDVariantData *imageData = [IDVariantData variantWithPreInstImageId:imageId];
	
	[[self.featureController hmiService] setDataModel:imageModelId 
					 variantData:imageData completionBlock:nil];
}

- (void)setImage:(UIImage *)image forImageModelWithId:(NSInteger)modelId {
    if (image == nil)
        return;
    IDVariantData *imageData = [IDVariantData variantWithImageData: UIImagePNGRepresentation(image)];
    [[self.featureController hmiService] setDataModel:modelId variantData:imageData completionBlock:nil];
}

- (void)setTextModelId:(NSInteger)textModelId withTextId:(NSInteger)textId;
{
	IDVariantData *textData = [IDVariantData variantWithTextId:textId];
	
	[[self.featureController hmiService] setDataModel:textModelId 
					 variantData:textData completionBlock:nil];
}

- (void)setText:(NSString *)text forDataModelWithId:(NSInteger)modelId {
    if (!text)
        return;
    
    IDVariantData *textData = [IDVariantData variantWithString:text];
    
    [[self.featureController hmiService] setDataModel:modelId
                     variantData:textData completionBlock:nil];
}

- (void)setTableData:(IDTableData *)data forListId:(NSInteger)listId forModelWithId:(NSInteger)modelId {
    if (data.rows > 0) {
        [self.featureController.hmiService setListModel:modelId tableData:data];
        if (listId != -1) {
            [self setWidget:listId visible:YES];
        }
    } else {
        if (listId != -1) {
            [self setWidget:listId visible:NO];
        }
        // TODO: possibly empty the table model?
    }
}

- (void)setComponent:(NSUInteger)componentID toValid:(BOOL)valid
{
	IDVariantMap *variantMap = [[IDVariantMap alloc] init];
	[variantMap setVariant:[IDVariantData variantWithBoolean:valid] forId:IDParameterValue];
	
	[[self.featureController hmiService] setProperty:IDPropertyValid
					 forComponent:componentID
					   variantMap:variantMap completionBlock:nil];
	
	[variantMap release];
}

- (void)showWidgets:(NSArray *)widgets visible:(BOOL)visible {
	if ( widgets ) {
		for ( NSNumber *widgetID in widgets ) {
			[self setWidget:[widgetID integerValue] visible:visible];
		}
	}
}

- (BOOL)isViewFocussed:(IDVariantMap*)infoDict
{
	IDVariantData *param = [infoDict variantForId:IDParameterHmiEventFocus];
	return [param booleanValue];
}

- (NSUInteger)selectedListIndex:(IDVariantMap *)infoDict;
{
	IDVariantData *param = [infoDict variantForId:IDParameterActionEventListIndex];
	NSUInteger index = [param integerValue];
	return index;
}

- (BOOL)focussedListIndex:(IDVariantMap*)infoDict {
	return [[infoDict variantForId:IDParameterHmiEventFocus] booleanValue];
}

- (void)setListFocus:(NSUInteger) offset forListId:(NSUInteger)componentId withEvent:(NSUInteger) eventId {
    IDVariantMap *param_map = [IDVariantMap variantMapWithVariant:[IDVariantData variantWithInteger:componentId] forId:IDParameterValue];
    [param_map setVariant:[IDVariantData variantWithInteger:offset] forId:IDParameterHmiEventListIndex];
    [[self.featureController hmiService] triggerHmiEvent:eventId parameterMap:param_map completionBlock:nil];
}

- (void)deregister;
{
	
}

- (void) setNavigationDataModelWithId:(NSInteger)modelId latitude:(float) latitude longitude:(float) longitude targetName:(NSString*) targetName {
	NSInteger hmiLatitude = latitude * 4294967296.0 / 360.0;
	NSInteger hmiLongitude = longitude * 4294967296.0 / 360.0;
	NSString* guidanceString = [NSString stringWithFormat:@";;;;;;;%d;%d;%@", hmiLatitude, hmiLongitude, targetName];
	[[self.featureController hmiService] setDataModel:modelId variantData:[IDVariantData variantWithString:guidanceString] completionBlock:nil];
}

@end
