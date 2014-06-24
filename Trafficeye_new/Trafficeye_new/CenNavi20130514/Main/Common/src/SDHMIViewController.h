//
//  SDHMIViewController.h
//  Connected
//
//  Created by Rónán Ó Braonáin on 29/07/2010.
//  Copyright 2010 BMW Group. All rights reserved.
//

#import "MCFeatureController.h"


@interface SDHMIViewController : NSObject

@property (readonly) id<MCFeatureController> featureController;

// Must pass in an MCFeatureController instance to initialize
- (id)initWithFeatureController:(id<MCFeatureController>)featureController;

// Sets/unsets 3-line restriction on list elements, e.g. when driving in the US this is a requirement
- (void)setListItem:(NSInteger)listId limitedTo3Lines:(BOOL)enabled;

/*!
 @abstract Sets the cursor focus to the specified list offset
 @param offset the line within the list the cursor should be set to
 @param componentId The list itsself
 @param eventId The Event which sould be used to trigger the cursor jump
 */
- (void)setListFocus:(NSUInteger) offset forListId:(NSUInteger)componentId withEvent:(NSUInteger) eventId;


// Enables/disables a HMI widget
- (void)setWidget:(NSInteger)widgetId enabled:(BOOL)enabled;

// Sets a HMI widget to visible/invisible
- (void)setWidget:(NSInteger)widgetId visible:(BOOL)visible;

/*!
 @abstract enable the dounut before the widget to indicate background progress
 @param widgetId The widget where the progress-item should be displayed
 @param enabled Whether the waiting animation should be displayed or not
 */
- (void)setWaitingAnimationForWidget:(NSInteger)widgetId enabled:(BOOL)enabled;

// Enables/Disables the possibility to select a toolbar button
- (void)setToolbarButtonSelectable:(NSInteger)buttonId enabled:(BOOL)enabled;

// Enables/disables a toolbar button
- (void)setToolbarButtonEnabled:(NSInteger)buttonId enabled:(BOOL)enabled;

// Shows/hides a toolbar button
- (void)setToolbarButtonVisible:(NSInteger)buttonId visible:(BOOL)visible;

// Hides a button in a toolbar view. The icon is replaced with a blank image
- (void)setToolbarButtonHidden:(NSInteger)buttonId imageModelId:(NSInteger)modelId blankIconId:(NSInteger)blankIconId;

// Re-displays a toolbar button. An icon must be shown on a visible button
- (void)setToolbarButtonUnhidden:(NSInteger)buttonId imageModelId:(NSInteger)modelId iconId:(NSInteger)iconId;

// Update a toolbar button to display the specified text and image icon
//- (void)setToolbarButtonIconId:(NSInteger)imageId textId:(NSInteger)textId;

// Set an image model to contain image data from the given GID
- (void)setImageModelId:(NSInteger)imageModelId withImageId:(NSInteger)imageId;

// Set an image model to contain image data from the given GID
- (void)setImageModelId:(NSInteger)imageModelId withPreInstImageId:(NSInteger)imageId;

/*!
 @abstract Set image for a remote application image model
 @discussion if the input parameter image is nil the setImage message will be ignored
    this method does not alter or scale the image
 @param image - UIImage object holding the image to be displayed
 @param modelId - ID of the remote application image model
 */
- (void)setImage:(UIImage *)image forImageModelWithId:(NSInteger)modelId;

// Set a text model to contain text data from the given SID
- (void)setTextModelId:(NSInteger)textModelId withTextId:(NSInteger)textId;

/*!
 @abstract Set text for a remote application data model
 @discussion if the input parameter text is nil the setText message will be ignored
 @param text - string holding the text
 @param modelId - ID of the remote application data model
 */
- (void)setText:(NSString *)text forDataModelWithId:(NSInteger)modelId;

/*!
 @method setTableData:forListId:forModelWithId:
 @abstract Sets table data to a table model, with a cautious empty data catch.
 @discussion If the data is at least one row long, the table is set and displayed. If not, it is made invisible.
 @param data Table data
 @param listId List widget ID
 @param modelId Table model ID
 */
- (void)setTableData:(IDTableData *)data forListId:(NSInteger)listId forModelWithId:(NSInteger)modelId;

// Sets the "valid" property of an element, e.g. a list can be flagged to be redrawn
- (void)setComponent:(NSUInteger)componentID toValid:(BOOL)valid;

// Show/hide widgets as passed in in array
- (void)showWidgets:(NSArray *)widgets visible:(BOOL)visible;

// Takes in the dictionary delivered in an onFocus event and returns whether the view went in (YES) or out (NO) of focus
- (BOOL)isViewFocussed:(IDVariantMap*)infoDict;

// Parses the received infoDict for the selected index in the list
- (NSUInteger)selectedListIndex:(IDVariantMap *)infoDict;

// Parses the received infoDict for the currently focussed list item; returns its index
- (BOOL)focussedListIndex:(IDVariantMap*)infoDict;

/*!
 @abstract Called every time the SDHMIDateTimeHelper's vehicleLanguage property changes
 @discussion Overwrite ths stub if you would like to respond to changes of the HMI's language setting
 */
- (void) onHMILanguageChanged;


/*!
 @abstract Called every time the SDHMIUnitHelper's hmiDistanceFormat property changes
 @discussion Overwrite ths stub if you would like to respond to changes of the HMI's distance format setting
 */
- (void) onHMIDistanceFormatChanged;

/*!
 @abstract Called every time the SDHMIUnitHelper's hmiDateFormat property changes
 @discussion Overwrite ths stub if you would like to respond to changes of the HMI's date format setting
 */
- (void) onHMIDateFormatChanged;

/*!
 @abstract Called every time the SDHMIUnitHelper's hmiTimeFormat property changes
 @discussion Overwrite ths stub if you would like to respond to changes of the HMI's time format setting
 */
- (void) onHMITimeFormatChanged;

- (void)deregister;

/*!
 @method setNavigationDataModelWithId:latitude:longitude:targetName
 @abstract Fills a navigation data model with the given data
 */
- (void) setNavigationDataModelWithId:(NSInteger)modelId latitude:(float) latitude longitude:(float) longitude targetName:(NSString*) targetName;

@end
