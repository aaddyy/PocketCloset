/*************************************************************************
 *
 * ADOBE CONFIDENTIAL
 * ___________________
 *
 *  Copyright 2015 Adobe Systems Incorporated
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 *
 **************************************************************************/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

/** <fakeout>AdobeLabsMagicBrushType</fakeout> contains four constants that define each of the four supported natural media types.
 
 The property `brushType` in class `AdobeLabsMagicBrush` can be set to one of the four constants.
 */
typedef NS_ENUM(NSUInteger, AdobeLabsMagicBrushType)
{
    /** Use watercolor for painting. */
    AdobeLabsMagicBrushWatercolor   = 0,
    /** Use oil for painting. */
    AdobeLabsMagicBrushOil          = 1,
    /** Use pastel for painting. */
    AdobeLabsMagicBrushPastel       = 2,
    /** Use playdoh for painting. */
    AdobeLabsMagicBrushPlaydoh      = 3,
};

/** The `AdobeLabsMagicBrush` class provides four natural media brushes, watercolor, oil, pastel and playdoh for the user to paint with. Given an input path, `AdobeLabsMagicBrush` generates a textured stroke that resembles the appearance of one of the four natural media. In order to use `AdobeLabsMagicBrush`, `GLKit.framework` needs to be properly linked to your xcode project (Build Phases->Link Binary With Libraries).
 **/
@interface AdobeLabsMagicBrush : NSObject

/** @name Properties */

/** select the type of brush to paint with (watercolor, oil, pastel or playdoh)
 */
@property (nonatomic, readwrite) AdobeLabsMagicBrushType brushType;

/** set the size of the underlying canvas (# pixels)
 */
@property (nonatomic, readwrite) CGSize canvasSize;

/** set the thickness of the stroke (# pixels)
 */
@property (nonatomic, readwrite) CGFloat brushThickness;

/** set the RGB color (first three channels of `brushColor`) of the current stroke. All channels range from 0 to 1.
 * @note the RGB values are only used to determine the a, b channels of the current stroke in CIELAB color space. The lightness channel L is determined solely by exemplar natural media textures. The fourth channel of `brushColor` is not used.
 */
@property (nonatomic, readwrite) UIColor * brushColor;

/** gives the current canvas that contains all rendered strokes drawn so far. The size of the UIImage is the same as canvasSize
 */
@property (nonatomic, readonly) UIImage * canvas;

/** gives the current stroke that is drawn so far. The UIImage contains a subregion of the canvas bounding the current stroke. Note that the origin and size of the subregion change continuously as the user draws */
@property (nonatomic, readonly) UIImage * currentStroke;

/** gives the origin of the subregion bounding the current stroke (in pixels) */
@property (nonatomic, readonly) CGPoint currentStrokeLocation;

/** @name Instance Methods */

/** initialize the magicbrush with a desirable canvas size
 */
- (id)initWithCanvasSize:(CGSize)size;

/** empty all contents in the canvas
 */
- (void)clearCanvas;

/** begin a new stroke by providing the current touch position
 *
 * @param position the position where the touch is started
 *
 */
- (void)beginStroke: (CGPoint)position;

/** continue the current stroke by providing the subsequent touch positions
 *
 * @param position the current touch position
 *
 */
- (void)moveStroke: (CGPoint)position;

/** finish the current stroke by providing the last touch position
 *
 * @param position the position where the touch is released
 *
 */
- (void)endStroke: (CGPoint)position;

/** gives the name of one of the four brush types
 *
 * @param index the type of brush `AdobeLabsMagicBrushType` selected by the user
 * @return the name of the selected brush type
 *
 */
- (NSString*)brushTypeName: (AdobeLabsMagicBrushType) index;

/**
 *
 * @return the total number of brush types supported in AdobeLabsMagicBrush
 *
 */
- (int)numBrushTypes;

@end



