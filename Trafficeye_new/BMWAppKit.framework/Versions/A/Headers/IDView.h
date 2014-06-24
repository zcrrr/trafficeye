/*  
 *  IDView.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "IDFlushProtocol.h"

// TODO: header documentation

@class IDApplication;
@class IDWidget;
@class IDModel;
@class IDView;

/*!
 @protocol IDViewDelegate
 @abstract <#This is an introductory explanation about the protocol.#>
 @discussion <#This is a more detailed description of the protocol.#>
 @update 2012-07-24
 */
@protocol IDViewDelegate <NSObject>

@optional

/*!
 @method viewDidBecomeFocused:
    Called when the HMI state receives the focus, i.e. it becomes visible or another hmi state that covered the state given as argument was dismissed.
 @param view
    The view object that received the focus.
 */
- (void)viewDidBecomeFocused:(IDView *)view;

/*!
 @method viewDidLoseFocus:
    Called when the HMI state loses the focus, i.e. the hmi state was dismissed or another hmi state is displayed on top.
 @param view
    The view object that lost the focus.
 */
- (void)viewDidLoseFocus:(IDView *)view;

/*!
 @method viewDidAppear:
    Called when the HMI state is pushed onto the hmi view stack.
 @param view
    The view that has been opened.
 */
- (void)viewDidAppear:(IDView *)view;

/*!
 @method viewDidDisappear:
    Called when the HMI state gets popped from the hmi view stack (i.e. the user exits the screen with ZBE left shift).
 @param view
    The view that has become visible.
 */
- (void)viewDidDisappear:(IDView *)view;

@end

#pragma mark -

/*!
 @class IDView
 @abstract <#This is a introductory explanation about the class.#>
 @discussion <#This is a more detailed description of the class.#>
 @throws <#Documentation of exceptions thrown by this class.#>
 @updated <#last updated#>
 */
@interface IDView : NSObject <IDFlushProtocol>

/*!
 @method initWithHmiState:titleModel:focusEvent:
 @abstract This is the designated initializer.
 @discussion <#This is a more detailed description of the method.#>
 @param hmiState <#param documentation#>
 @param titleModel <#param documentation#>
 @param focusEvent <#param documentation#>
 @return <#return value documentation#>
 */
- (id)initWithHmiState:(NSInteger)hmiState
            titleModel:(IDModel *)titleModel
            focusEvent:(NSInteger)focusEvent;

/*!
 @method initWithHmiState:titleModelId:focusEvent:
 @abstract This initializer is deprecated. It is only provided for compatibility reasons. Don't use it in new projects.
 @discussion <#This is a more detailed description of the method.#>
 @param hmiState <#param documentation#>
 @param titleModelId <#param documentation#>
 @param focusEvent <#param documentation#>
 @return <#return value documentation#>
 */
- (id)initWithHmiState:(NSInteger)hmiState
          titleModelId:(NSInteger)titleModelId
            focusEvent:(NSInteger)focusEvent __attribute__((deprecated));

/*!
 @method addWidget:
 @abstract Adds a widget to this view.
 @discussion <#This is a more detailed description of the method.#>
 @param widget <#param documentation#>
 */
- (void)addWidget:(IDWidget *)widget;

/*!
 @method removeWidget:
 @abstract Removes a widget from this view.
 @discussion <#This is a more detailed description of the method.#>
 @param widget <#param documentation#>
 */
- (void)removeWidget:(IDWidget *)widget;

/*!
 @property title
 @abstract The string displayed in the hmi state's title bar
 @discussion This property is not KVO compliant
 */
@property (nonatomic, retain) NSString *title;

/*!
 @property titleId
 @abstract The text id displayed in the hmi state's title bar
 @discussion This property is not KVO compliant
 */
@property (nonatomic, assign) NSInteger titleId;

/*!
 @property application
 @abstract The application the view was added to
 @discussion <#This is a more detailed description of the property.#>
 */
@property (nonatomic, readonly) IDApplication *application;

/*!
 @property delegate
 @abstract <#This is an introductory explanation about the property.#>
 @discussion <#This is a more detailed description of the property.#>
 */
@property (nonatomic, assign) id<IDViewDelegate> delegate;

/*!
 @property focused
 @abstract <#This is an introductory explanation about the property.#>
 @discussion <#This is a more detailed description of the property.#>
 */
@property (readonly, getter=isFocused) BOOL focused;

/*!
 @property visible
 @abstract <#This is an introductory explanation about the property.#>
 @discussion <#This is a more detailed description of the property.#>
 */
@property (readonly, getter=isVisible) BOOL visible;

@end
