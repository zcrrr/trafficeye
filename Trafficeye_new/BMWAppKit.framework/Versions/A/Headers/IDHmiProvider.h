/*  
 *  IDHmiProvider.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>


@class IDView;
@class IDModel;
@class IDMultimediaInfo;
@class IDStatusBar;

@protocol IDHmiProvider <NSObject>

/*!
 @method modelForId:
 @abstract A factory which provides the model instance corresponding to a model identifier from the HMI description.
 @param identifier The identifier for the model.
 @return An initialized instance of IDModel.
 */
- (IDModel *)modelForId:(NSInteger)identifier;

/*!
 @method allModels
 @abstract The collection of all models defined in the HMI description.
 @return A set of all models managed by the HMI provider.
 */
- (NSSet *)allModels;

/*!
 @method viewForId:
 @abstract A factory which provides the view instance corresponding to a state identifier from the HMI description.
 @param identifier The identifier for the state represented by the view.
 @return An initialized instance of a subclass of IDView.
 */
- (IDView *)viewForId:(NSInteger)identifier;

/*!
 @method allViews
 @abstract The collection of all views representing a state defined in the HMI description.
 @return A set of all views managed by the HMI provider.
 */
- (NSSet *)allViews;


/*!
 @method multimediaInfo
 @abstract Can be used to retrive a ready to use IDMultimediaInfo object
 @return An initialized instance of a subclass of IDMultimediaInfo
 */
- (IDMultimediaInfo *)multimediaInfo;

/*!
 @method statusBar
 @abstract Can be used to retrive a ready to use IDStatusBar object
 @return An initialized instance of a subclass of IDStatusBar
 */
- (IDStatusBar *)statusBar;

@end
