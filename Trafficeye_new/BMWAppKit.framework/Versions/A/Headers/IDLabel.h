/*  
 *  IDLabel.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "IDWidget.h"

/*!
 @class IDLabel
 @abstract This class implements the behavior of HMI labels in the Widget API.
 @updated 2012-04-26
 */
@interface IDLabel : IDWidget

#pragma mark - public properties

/*!
 @property text
 @abstract Set the Text of a label to a string value.
 @discussion Assigning nil to this property clears the string from the label.
    Please note that the behavior for setting texts in the HMI depends on the definition of the model which is
    associated to this label. This property is meant to write a text string to the model and will only work if the
    corresponding model was declared as a data model (i.e. 'model string').
    (not KVO compliant)
 */
@property (nonatomic, copy) NSString *text;

/*!
 @property textId
 @abstract Set the Text of a label to a text resource.
 @discussion  Please note that the behavior for setting texts in the HMI depends on the definition of the model which is
 associated to this label. This property is meant to write the ID of a text resource to the model and will only work if
 the corresponding model was declared as a text id model (i.e. 'id model string').
 (not KVO compliant)
 */
@property (nonatomic, assign) NSInteger textId;

/*!
 @property position
 @abstract Sets the Position of a label.
 @discussion As a sideeffect of setting a label's position the label won't be selectable anymore and the label will stay
 in the specified position even if the HMI screen is being scrolled. These sideeffects of positioning a label at runtime
 cannot be undone during a lifecycle.
 (not KVO compliant)
 */
@property (nonatomic, assign) CGPoint position;

/*!
 @property waitingAnimation
 @abstract Sets the waitingAnimation property of a label.
 @discussion Setting this property to YES adds a spinner to the label for indicating updates, server requests etc.
    Setting this property to NO will remove the spinner.
    (not KVO compliant)
 */
@property (nonatomic, assign) BOOL waitingAnimation;

@end
