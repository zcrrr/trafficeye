/*  
 *  IDGauge.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import "IDWidget.h"


@class IDModel;

/*!
 @class IDGauge
 */
@interface IDGauge : IDWidget

/*!
 @method initWithWidgetId:model:textModel:actionId:changeActionId:
 @discussion
    This is the designated initializer.
 */
- (id)initWithWidgetId:(NSInteger)widgetId
                 model:(IDModel *)model
             textModel:(IDModel *)textModel
              actionId:(NSInteger)actionId
        changeActionId:(NSInteger)changeActionId;

/*!
 @method initWithWidgetId:modelId:actionId:changeActionId:
 @discussion
    This initializer is deprecated. It is only provided for compatibility reasons. Don't use it in new projects.
 */
- (id)initWithWidgetId:(NSInteger)widgetId
               modelId:(NSInteger)modelId
              actionId:(NSInteger)actionId
        changeActionId:(NSInteger)changeActionId __attribute__((deprecated));

/*!
 @property width
    Use this property to set the width of a gauge
 @discussion
    Adjusting the width works only for gauges whose model type is "Progress". This property is not KVO compliant.
 */
@property (assign, nonatomic) NSInteger width;

/*!
 @property position
    Use this property to adjust the position of a gauge's top left corner.
 @discussion
    This property is not KVO compliant.
 */
@property (assign, nonatomic) CGPoint position;

@end
