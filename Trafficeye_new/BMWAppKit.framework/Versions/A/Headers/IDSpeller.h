/*  
 *  IDSpeller.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import "IDWidget.h"

@class IDView;
@class IDModel;
@class IDSpeller;

/*!
 @enum IDSpellerType
 @abstract Used to represent the different available speller types.
 @constant IDSpellerTypeUnknown       Unknown speller type
 @constant IDSpellerTypeLatinSpeller  Used in non-asian vehicles
 @constant IDSpellerTypeChinaSpeller  Used in china, hong kong and taiwan
 @constant IDSpellerTypeMatrixSpeller Used in japan and korea
*/
typedef enum {
    IDSpellerTypeUnknown = 0,
    IDSpellerTypeLatinSpeller,
    IDSpellerTypeChinaSpeller,
    IDSpellerTypeMatrixSpeller
} IDSpellerType;

/*!
 @protocol IDSpellerDelegate
 @abstract Delegate protocol used to inform a delegate about changes in the speller component.
 */
@protocol IDSpellerDelegate <NSObject>
/*!
 @method speller:didChangeText:
 @abstract This method is called on every change to the string. It always delivers the entire string.
 @param speller The speller instance.
 @param string A string representing the entire string that was entered up to now.
 */
- (void)speller:(IDSpeller *)speller didChangeText:(NSString *)string;

/*!
 @method speller:didSelectResultAtIndex:
 @abstract This method is called every time a result has been selected from the result list.
 @param speller The speller instance.
 @param index An integer representing the index of the selected entry
 */
- (void)speller:(IDSpeller *)speller didSelectResultAtIndex:(NSInteger)index;

/*!
 @method spellerDidSelectOK:
 @abstract This method is called when 'OK' is selected in the speller.
 @param speller The speller instance.
 */
- (void)spellerDidSelectOK:(IDSpeller *)speller;

@end

#pragma mark -

/*!
 @class IDSpeller
 @abstract Instances of this class are used to represent RHMI spellers.
 @discussion A speller (aka input component) is a UI component used by BMW's HMIs to enter text.
 @updated 2012-11-20
 */
@interface IDSpeller : IDWidget

/*!
 @method initWithActionId:resultActionId:resultModel:suggestActionId:suggestModel:targetModel:
 @abstract The designated initializer.
 @param actionId Integer representing the speller's 'OK' action.
 @param resultActionId Identifier representing the speller's result action.
 @param resultModel An instance of IDModel representing the model which can be used to set the input string in the HMI
 @param suggestActionId Identifier representing the speller's suggest action.
 @param suggestModel An instance of IDModel representing the suggestions displayed by the speller.
 @param targetModel An instance of IDModel representing the model for specifying dynamic target views.
 @return An instance of IDSpeller
 */
- (id)initWithActionId:(NSInteger)actionId
        resultActionId:(NSInteger)resultActionId
           resultModel:(IDModel *)resultModel
       suggestActionId:(NSInteger)suggestActionId
          suggestModel:(IDModel *)suggestModel
           targetModel:(IDModel *)targetModel;

/*!
 @method initWithActionId:resultActionId:resultModelId:suggestActionId:suggestModelId:targetModelId:
 @abstract Legacy initializer for compatibility reasons.
 @param actionId Integer representing the speller's 'OK' action.
 @param resultActionId Identifier representing the speller's result action.
 @param resultModelId Model identifier representing the model which can be used to set the input string in the HMI
 @param suggestActionId Identifier representing the speller's suggest action.
 @param suggestModelId Model identifier representing the suggestions displayed by the speller.
 @param targetModelId Model identifier representing the model for specifying dynamic target views.
 @return An instance of IDSpeller
 */
- (id)initWithActionId:(NSInteger)actionId
        resultActionId:(NSInteger)resultActionId
         resultModelId:(NSInteger)resultModelId
       suggestActionId:(NSInteger)suggestActionId
        suggestModelId:(NSInteger)suggestModelId
         targetModelId:(NSInteger)targetModelId __attribute__((deprecated));

/*!
 @method clear
 @abstract Clears the speller's string and result list.
 @discussion Use this method to reset the speller to it's initial state.
 */
- (void)clear;

/*!
 @property text
 @abstract The current input string typed by the user.
 @discussion This property is not KVO compliant.
 */
@property (readonly) NSString *text;

/*!
 @property delegate
 @abstract Delegate implementing the @link IDSpellerDelegate @/link protocoll to receive speller events.
 @discussion This property is not KVO compliant.
 */
@property (nonatomic, assign) id<IDSpellerDelegate> delegate;

/*!
 @property results
 @abstract The results (i.e. suggestions) displayed by the speller.
 @discussion Assign an array of strings to this property to change the suggestions displayed by the speller. No special formatting is allowed in this list. (In contrast to a standard IDTable). This property is not KVO compliant.
 */
@property (nonatomic, retain) NSArray *results;

/*!
 @property targetView
 @abstract Set the target view of a speller.
 @discussion This property is not KVO compliant.
 */
@property (nonatomic, assign) IDView *targetView;

/*!
@property type
@abstract Returns the type of speller available in the vehicle.
@discussion The type is returned as a value of the IDSpellerType enum.
 (not KVO compliant)
*/
@property (readonly) IDSpellerType type;
@end
