/*  
 *  IDButton.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "IDWidget.h"

// TODO: header documentation

@class IDImageData;
@class IDView;

/*!
 @class IDButton
 @discussion
	This class implements the behavior of the different kinds of HMI buttons in the Widget API. On the one hand this class
    can represent a default HMI button which is part of a scrollable layout an can be focussed. But on the other hand
    instances of this class can also be used to interact with toolbar buttons (i.e. the buttons that make up the toolbar
    of a toolbar hmi state).
 @updated 2012-07-24
 */
@interface IDButton : IDWidget

/*!
 @enum IDActionEvent
    Enumeration of possible action events
 @constant IDActionEventSelect
    The button was selected in the HMI
 @constant IDActionEventFocus
    The button was focused in the HMI
 */
typedef enum IDActionEvent {
    IDActionEventSelect,
    IDActionEventFocus
} IDActionEvent;

/*!
 @method initWithWidgetId:model:imageModel:targetModel:actionId:focusId:
 @abstract This is the designated initializer.
 @param widgetId ID of the button as specified in the HMI description.
 @param model Model for the text displayed by the button.
 @param imageModel Model for the image displayed by the button.
 @param targetModel Model for the target view this button should open.
 @param actionId ID of the action used for 'onSelect' events.
 @param focusId ID of the action used for 'onFocus' events.
 @return Returns a fully initialized IDButton instance.
 */
- (id)initWithWidgetId:(NSInteger)widgetId
                 model:(IDModel *)model
            imageModel:(IDModel *)imageModel
           targetModel:(IDModel *)targetModel
              actionId:(NSInteger)actionId
               focusId:(NSInteger)focusId;

/*!
 @method initWithWidgetId:modelId:imageModelId:actionId:targetModelId:focusId:
 @abstract This initializer is deprecated. It is only provided for compatibility reasons. Don't use it in new projects.
 @param widgetId ID of the button as specified in the HMI description.
 @param modelId ID of the Model for the text displayed by the button.
 @param imageModelId ID of the Model for the image displayed by the button.
 @param actionId ID of the action used for 'onSelect' events.
 @param targetModelId ID of the Model for the target view this button should open.
 @param focusId Returns a fully initialized IDButton instance.
 */
- (id)initWithWidgetId:(NSInteger)widgetId
               modelId:(NSInteger)modelId
          imageModelId:(NSInteger)imageModelId
              actionId:(NSInteger)actionId
         targetModelId:(NSInteger)targetModelId
               focusId:(NSInteger)focusId __attribute__((deprecated));

/*!
 @method setTarget:selector:forActionEvent
    Set the callback target and selector for a button click.
 @discussion
    The selector must have the following signature '-(void)yourMethod:(IDButton*)button'. The selector will not be retained by the button. There will be only one selector for each IDActionEvent at the same time.
 @param target
    The object the selector will be called upon
 @param selector
    The selector that should be called
 @param event
    The action event for which the target will be called @see IDActionEvent
 */
- (void)setTarget:(id)target selector:(SEL)selector forActionEvent:(IDActionEvent)event;

/*!
 @property text
 @abstract Set the Text of a button to a string value.
 @discussion Assigning nil to this property clears the string from the button.
 Please note that the behavior for setting texts in the HMI depends on the definition of the model which is
 associated to this button. This property is meant to write a text string to the model and will only work if the
 corresponding model was declared as a data model (i.e. 'model string').
 (not KVO compliant)
 */
@property (nonatomic, retain) NSString *text;

/*!
 @property textId
 @abstract Set the Text of a button to a text resource.
 @discussion  Please note that the behavior for setting texts in the HMI depends on the definition of the model which is
 associated to this button. This property is meant to write the ID of a text resource to the model and will only work if
 the corresponding model was declared as a text id model (i.e. 'id model string').
 (not KVO compliant)
 */
@property (nonatomic, assign) NSInteger textId;

/*!
 @property image
 @abstract Set the image to be displayed by the button to the given image data.
 @discussion Assigning nil to this property clears the image from the button.
 Please note that the behavior for setting images in the HMI depends on the definition of the model which is
 associated to this button. This property is meant to write a image data to the model and will only work if the
 corresponding model was declared as a data model (i.e. 'model img').
 */
@property (nonatomic, retain) IDImageData *image;

/*!
 @property imageId
 @abstract Set the image of a label to an image resource.
 @discussion  Please note that the behavior for setting images in the HMI depends on the definition of the model which is
 associated to this button. This property is meant to write the ID of an image resource to the model and will only work if
 the corresponding model was declared as an image id model (i.e. 'id model img').
 (not KVO compliant)
 */
@property (nonatomic, assign) NSInteger imageId;

/*!
 @property targetView
 @abstract Set the target view of a button.
 @discussion
    Changing the target view of a button works only if the 'onSelect' action was specified (directly or indirectly 
    via a combined action) as an open action which in turn must be associated with an integer model (e.g.
    'onSelect open [someIntModel]')
    This property is not KVO compliant.
 */
@property (nonatomic, assign) IDView *targetView;

@end
