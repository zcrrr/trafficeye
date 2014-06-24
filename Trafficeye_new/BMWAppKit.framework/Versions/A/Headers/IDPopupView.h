/*  
 *  IDPopupView.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import "IDView.h"

/*!
 @class IDPopupView
 @abstract Extends IDView for popup specific behavior
 @discussion This class is a subclass of IDView and extends its superclass with popup specific behavior like showing or dismissing the popup
 @update 2012-04-03
 */
@interface IDPopupView : IDView

/*!
 @method initWithHmiState:titleModel:focusEvent:popupEvent:
 @abstract The designated initializer.
 @param hmiState The ID of the HMI state from the HMI description.
 @param titleModel A model holding the title of the hmi state.
 @param focusEvent ID of a focus event.
 @param popupEvent ID of a popup event.
 @return Returns a fully initialized object.
 */
- (id)initWithHmiState:(NSInteger)hmiState
            titleModel:(IDModel *)titleModel
            focusEvent:(NSInteger)focusEvent
            popupEvent:(NSInteger)popupEvent;

/*!
 @method initWithHmiState:titleModelId:focusEvent:popupEvent:
 @abstract Legacy initializer for compatibility reasons.
 @param hmiState The ID of the HMI state from the HMI description.
 @param titleModelId ID of a model holding the title of the hmi state.
 @param focusEvent ID of a focus event.
 @param popupEvent ID of a popup event.
 @return Returns a fully initialized object.
 */
- (id)initWithHmiState:(NSInteger)hmiState
          titleModelId:(NSInteger)titleModelId
            focusEvent:(NSInteger)focusEvent
            popupEvent:(NSInteger)popupEvent __attribute__((deprecated));

/*!
 @method show
 @abstract Show the popup.
 */
- (void)show;

/*!
 @method dismiss
 @abstract Dismiss the popup.
 */
- (void)dismiss;

@end
