/*  
 *  IDTable.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "IDWidget.h"

// TODO: header documentation

@class IDTable;
@class IDTableCell;
@class IDTableLocation;
@class IDVariantMap;
@class IDVariantData;
@class IDView;

/*!
 @enum IDTableCutType
 @constant IDTableCutTypeDots,
 @constant IDTableCutTypeNoCut,
 @constant IDTableCutTypeWordsDots,
 @constant IDTableCutTypeBackwardsDots,
 @constant IDTableCutTypeWordsAutoStaticText,
 @constant IDTableCutTypeWordsAutoDynamicText
 @constant IDTableCutTypeUndefined
 */
typedef enum IDTableCutType {
    IDTableCutTypeDots,
    IDTableCutTypeNoCut,
    IDTableCutTypeWordsDots,
    IDTableCutTypeBackwardsDots,
    IDTableCutTypeWordsAutoStaticText,
    IDTableCutTypeWordsAutoDynamicText,
    IDTableCutTypeUndefined = 255
} IDTableCutType;

/*!
 @protocol IDTableDelegate
 @abstract <#This is an introductory explanation about the protocol.#>
 @discussion <#This is a more detailed description of the protocol.#>
 */
@protocol IDTableDelegate <NSObject>

@optional

/*!
 @method table:didSelectItemAtIndex:
 @abstract Called if a item at specified index was selected.
 @discussion <#This is a more detailed description of the method.#>
 @param table The regarding table.
 @param index Index of the item selected.
 */
- (void)table:(IDTable *)table didSelectItemAtIndex:(NSInteger)index;


/*!
 @method table:didFocusItemAtIndex:
 @abstract Called if a item at specified index was focused.
 @discussion <#This is a more detailed description of the method.#>
 @param table The regarding table.
 @param index Index of the item focused.
 */
- (void)table:(IDTable *)table didFocusItemAtIndex:(NSInteger)index;


@end

#pragma mark -

/*!
 @class IDTable
 @abstract IDTable represents a "list" compoment from the HMI description.
 @discussion <#This is a more detailed description of the class.#>
 @updated 2012-07-17
 */
@interface IDTable : IDWidget

/*!
 @method initWithWidgetId:model:targetModel:actionId:
 @abstract The designated initializer.
 @param widgetId ID of the HMI component this widget represents
 @param model IDModel representation of the table's data model
 @param targetModel IDModel representation of an HMI action's target model
 @param actionId ID of the action associated with this table
 @param focusId ID of the focused action associated with this table
 */
- (id)initWithWidgetId:(NSInteger)widgetId
                 model:(IDModel *)model
           targetModel:(IDModel *)targetModel
              actionId:(NSInteger)actionId
               focusId:(NSInteger)focusId;

/*!
 @method initWithWidgetId:model:targetModel:actionId:
 @abstract The designated initializer.
 @param widgetId ID of the HMI component this widget represents
 @param model IDModel representation of the table's data model
 @param targetModel IDModel representation of an HMI action's target model
 @param actionId ID of the action associated with this table
 */
- (id)initWithWidgetId:(NSInteger)widgetId
                 model:(IDModel *)model
           targetModel:(IDModel *)targetModel
              actionId:(NSInteger)actionId __attribute__((deprecated));

/*!
 @method initWithWidgetId:modelId:actionId:targetModelId:
 @abstract Legacy initializer for compatibility reasons.
 @param widgetId ID of the HMI component this widget represents
 @param modelId ID of the table's data model
 @param actionId ID of the action associated with this table
 @param targetModelId ID an HMI action's target model
 */
- (id)initWithWidgetId:(NSInteger)widgetId
               modelId:(NSInteger)modelId
              actionId:(NSInteger)actionId
         targetModelId:(NSInteger)targetModelId __attribute__((deprecated));

/*!
 @method removeAllCells
 @abstract Clear the table.
 */
- (void)removeAllCells;

/*!
 @method setRowCount:columnCount:
 @abstract Set the table's dimensions.
 @discussion If the dimensions are different truly new, this implicitly calls -clear as well.
 @param rows Number of rows to be displayed in the table
 @param columns Number of columns to be displayed in the table
 */
- (void)setRowCount:(NSInteger)rows columnCount:(NSInteger)columns;

/*!
 @method setCell:atRow:column:
 @abstract Set an individual cell.
 @param cell IDTableCell instance
 @param row Defines the row of cell to be set
 @param column Defines the column of the cell to be set
 */
- (void)setCell:(IDTableCell *)cell atRow:(NSInteger)row column:(NSInteger)column;

/*!
 @method setColumnWidths:
 @abstract Set the columns widths.
 @discussion Format is an NSArray of NSNumbers. Each NSNumber represents the width of one column.
 @param widths NSArray of NSNumber objects. The value of each NSNumber object represents the width of the according column
 */
- (void)setColumnWidths:(NSArray *)widths;

/*!
@method setCutType:
@abstract Set the type for cutting of words in table cells
@discussion See IDTableCutType description for different cut types
@param cutType Cut Type of IDTableCutType.
*/
- (void)setCutType:(IDTableCutType)cutType;

/*!
 @method focusRow:
 @abstract Select a row programatically.
 @param row Row to focus
 */
- (void)focusRow:(int)row;

/*!
 @property delegate
 @abstract Delegate that should receive the callbacks.
 @discussion The delegate must implement the IDTableDelegate protocol
 */
@property (assign) id<IDTableDelegate> delegate;

/*!
 @property targetView
 @abstract The target view. When an element from the table is selected, this view is presented automtically.
 @discussion not KVO compliant
 */
@property (nonatomic, assign) IDView *targetView;

@end
