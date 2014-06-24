/*  
 *  IDCheckbox.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import "IDWidget.h"

/*!
 @enum IDCheckboxStyle
 @abstract The different available checkbox styles.
 @constant IDCheckboxStyleDefault Represents a default checkbox.
 @constant IDCheckboxStyleRadioButton Represents a radio button.
 */
typedef enum IDCheckboxStyle {
    IDCheckboxStyleDefault,
    IDCheckboxStyleRadioButton
} IDCheckboxStyle;


@class IDApplication;
@class IDCheckbox;
@class IDModel;

/*!
 @protocol IDCheckboxDelegate
 @abstract Protocol definition for IDCheckbox delegates.
 @discussion To receive staus updates for checkboxes or radiobuttons from the HMI a delegate needs to
    adapt the IDCheckboxDelegate protocol and set itself as a delegate for the respective IDCheckbox instance.
 */
@protocol IDCheckboxDelegate <NSObject>

@optional

/*!
 @method checkboxShouldToggle:
 @discussion Called when the user clicks on the checkbox. Not called when checkbox state is programmatically set via [IDCheckbox setChecked:]. If the method is not implemented in the Delegate, YES is assumed so the checkbox will toggle its value.
 @param checkbox Checkbox which should toggle.
 @return
    Return YES to allow the toggle to take place. Return NO to leave the checkbox state unchanged.
 */
- (BOOL)checkboxShouldToggle:(IDCheckbox *)checkbox;

/*!
 @method checkbox:didChangeCheckedValue:
 @abstract Called when the state of the checkbox has changed. Not called when checkbox state is programmatically set via [IDCheckbox setChecked:]
 @param checkbox Checkbox which changed its value.
 @param checkedValue New checkbox value.
 @return
    BOOL checkedValue is the new value the checkbox has.
 */
- (void)checkbox:(IDCheckbox *)checkbox didChangeCheckedValue:(BOOL)checkedValue;

@end

#pragma mark -

/*!
 @class IDCheckbox
 @abstract This class implements the behavior of HMI checkboxes in the Widget API.
 @discussion The class can represent either checkboxes or radiobuttons in the HMI. These two components do not differ in their behavior. The only difference is their appearance in the HMI and the value returned by the style property.
 @updated 2012-07-24
 */
@interface IDCheckbox : IDWidget

/*!
 @method initWithWidgetId:model:textModel:actionId:style:
 @abstract This is the designated initializer.
 @param widgetId Id with which the widget will be initialized.
 @param model Model representing the current value of the checkbox.
 @param textModel Text model for initialization.
 @param actionId ID of the remote action associated with the checkbox.
 @param style Style value for initialization.
 @return The checkbox itself.
 */
- (id)initWithWidgetId:(NSInteger)widgetId
                 model:(IDModel *)model
             textModel:(IDModel *)textModel
              actionId:(NSInteger)actionId
                 style:(IDCheckboxStyle)style;

/*!
 @method initWithWidgetId:modelId:textModelId:actionId:style:
 @abstract This initializer is deprecated. It is only provided for compatibility reasons. Don't use it in new projects.
 */
- (id)initWithWidgetId:(NSInteger)widgetId
               modelId:(NSInteger)modelId
           textModelId:(NSInteger)textModelId
              actionId:(NSInteger)actionId
                 style:(IDCheckboxStyle)style __attribute__((deprecated));

/*!
 @method setChecked:
 @abstract
    Programmatically set the toggle widget's state.
 @param checked YES if the checkbox should be checked. NO if not.
 */
- (void)setChecked:(BOOL)checked;

/*!
 @property text
 @abstract Set the Text of a checkbox to a string value.
 @discussion Assigning nil to this property clears the string from the checkbox.
 Please note that the behavior for setting texts in the HMI depends on the definition of the model which is
 associated to this checkbox. This property is meant to write a text string to the model and will only work if the
 corresponding model was declared as a data model (i.e. 'model string').
 (not KVO compliant)
 */
@property (nonatomic, copy) NSString *text;

/*!
 @property textId
 @abstract Set the Text of a checkbox to a text resource.
 @discussion  Please note that the behavior for setting texts in the HMI depends on the definition of the model which is
 associated to this checkbox. This property is meant to write the ID of a text resource to the model and will only work if
 the corresponding model was declared as a text id model (i.e. 'id model string').
 (not KVO compliant)
 */
@property (nonatomic, assign) NSInteger textId;

/*!
 @property style
 @abstract
    Returns the style of the IDCheckbox component.
 @discussion
    returns @link IDCheckboxStyleDefault @/link for checkbox HMI components and @link IDCheckboxStyleRadioButton @/link for radioButton HMI components.
 */
@property (readonly) IDCheckboxStyle style;

/*!
 @property delegate
 @abstract
    Delegate implementing the @link IDCheckboxDelegate @/link protocol to process checkbox toggle events.
 */
@property (assign, nonatomic) id<IDCheckboxDelegate> delegate;

@end
