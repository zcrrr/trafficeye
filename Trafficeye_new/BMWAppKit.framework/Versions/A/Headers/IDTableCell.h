/*  
 *  IDTableCell.h
 *  BMW Group App Integration Framework
 *  
 *  Copyright (C) 2013 Bayerische Motoren Werke Aktiengesellschaft (BMW AG). All rights reserved.
 */

#import <UIKit/UIKit.h>

@class IDImageData;

/*!
 @class IDTableCell
 @abstract Class representing a single cell within an IDTable.
 @discussion The position of a cell within the table is defined by the row and the column. (@see IDTable for adding and positioning table cells)
 */
@interface IDTableCell : NSObject

/*!
 @method tableCellWithString:
 @abstract Create a table cell that contains a piece of text.
 @param string The text that should be displayed in the cell.
 @return An instance of IDTableCell or nil if table cell could not be created.
 */
+(IDTableCell*)tableCellWithString:(NSString*)string;

/*!
 * @method tableCellWithTextId:
 * @abstract Create a table cell that displays a text a in the remote hmi text resources.
 * @discussion If the textId provided does not exist in any remote hmi text resource no text will be displayed at runtime. Cells with unknown text ids will not clear out cells with valid text ids previously displayed in the hmi!
 * @param textId The identifier of the text resource that should get displayed in the cell.
 * @result A table cell that displays the text from the text resources associated with textId or nil if the cell could not be created.
 */
+ (IDTableCell*)tableCellWithTextId:(NSInteger)textId;

/*!
 * @method tableCellWithImageId:
 * @abstract Create a table cell that displays an from an remote hmi image resource.
 * @discussion If the imageId provided does not exist in any remote hmi image resource no image will be displayed at runtime. Cells with unknown image ids will not clear out cells with valid image ids previously displayed in the hmi!
 * @param imageId The identifier of the image resource that should be displayed in the cell.
 * @return A table cell that displays the image from the image resource associated with the imageId or nil if the cell could not be ceated.
 */
+(IDTableCell*)tableCellWithImageId:(NSInteger)imageId;

/*!
 * @method tableCellWithImageData:
 * @abstract Create a table cell that displays an image.
 * @discussion Images are represented by image data objects (@see IDImageData).
 * @param imageData The image data for the image that should be displayed in the cell.
 * @return A table cell that displays the image represented by the image data or nil if the cell could not be ceated.
 */
+(IDTableCell*)tableCellWithImageData:(IDImageData *)imageData;

/*!
 * @method tableCellWithImageData:placeholderImageId:
 * @abstract Create a table cell that displays an image.
 * @discussion Images are represented by image data objects (@see IDImageData). The placeholder allows the cell to display a temporary image while the image data is transfered to the hmi. The placeholder image is located in an remote hmi image resource. If the imageId provided does not exist in any remote hmi image resource no image will be displayed as placeholder at runtime.
 * @param imageData The image data for the image that should be displayed in the cell.
 * @param imageId The identifier of the placeholder image resource that should be displayed while the image data is transfered to the hmi.
 * @return A table cell that displays the image represented by the image data or nil if the cell could not be ceated.
 */
+(IDTableCell*)tableCellWithImageData:(IDImageData *)imageData placeholderImageId:(NSInteger)imageId;

@end
