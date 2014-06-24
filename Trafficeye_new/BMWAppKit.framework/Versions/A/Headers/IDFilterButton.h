/*  
 *  IDFilterButton.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "IDButton.h"


@class IDModel;

/*!
 @class IDFilterButton
 @abstract Represents a remote HMI filter button
 @discussion
   Represents a filter button. I.e. a button which can be used to request some input from the user. When focussed in the HMI the text of this button is updated to display the tooltip text followed by a '?' sign and the currently set value of the text property.
   So by updating the tooltipText property you can change the text used as a propmt when the button gets focussed. And by updating the text property you can modify the text which is used to display the currently selected value.
 */
@interface IDFilterButton : IDButton

/*!
 @method initWithWidgetId:model:tooltipModel:imageModel:targetModel:actionId:focusId:
 @discussion
 This is the designated initializer.
 */
- (id)initWithWidgetId:(NSInteger)widgetId
                 model:(IDModel *)model
          tooltipModel:(IDModel *)tooltipModel
            imageModel:(IDModel *)imageModel
           targetModel:(IDModel *)targetModel
              actionId:(NSInteger)actionId
               focusId:(NSInteger)focusId;

/*!
 @property tooltipText
 Set the tooltip text of a filter button.
 @discussion
 Assigning nil to this property clears the string from the button. This property is not KVO compliant.
 */
@property (nonatomic, retain) NSString *tooltipText;

/*!
 @property tooltipTextId
 Set the text ID for a filter button's tooltip text.
 @discussion
 This property is not KVO compliant.
 */
@property (nonatomic, assign) NSInteger tooltipTextId;

@end
