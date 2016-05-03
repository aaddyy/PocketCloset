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

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

/** <fakeout>AdobeLabsMagicSelectionBrushMode</fakeout> defines how strokes will modify the magic selection.
 
 Change the brushMode property of AdobeLabsUXMagicSelectionView instances using this enum type to modify the brush mode.
 
 */
typedef NS_ENUM(NSUInteger, AdobeLabsMagicSelectionBrushMode)
{
    /** Strokes made will mark the foreground region. */
    AdobeLabsMagicSelectionBrushModeForeground = 255,
    
    /** Strokes made will mark the background region. */
    AdobeLabsMagicSelectionBrushModeBackground = 0,
    
    /** Strokes made will mark a region consisting of a mix of foreground and background.  Useful for fine adjustments such as selecting hair.  */
    AdobeLabsMagicSelectionBrushModeMixed    = 128
};

/** `AdobeLabsUXMagicSelectionView` is a subclass of UIView that provides interactive stroke-based selection of an <fakeout>image</fakeout> region that magically selects foreground objects from the <fakeout>image</fakeout>, including fine details such as hair.
 
 The magically selected region is referred to as the <b><i>matte</i></b>.
 
 The view also provides functionality similar to UIScrollView, enabling users
 to pan and zoom on the <fakeout>image</fakeout>. Zooming is performed with a pinch gesture, but
 unlike UIScrollView, panning requires a two-finger touch, as the single-touch
 gesture is reserved for magic selection.
 
 An `AdobeLabsUXMagicSelectionView` instance may be added to the view hierarchy
 programatically, or via Interface Builder by setting the custom class for a view.
 
 The following code illustrates how to programatically create a magic selection view and add it to your view controller:
 
    // load a UIImage to use from the app resource bundle
    UIImage * image = [UIImage imageNamed:@"myImage.jpg"];

    // create the magic selection view, set the image, and add the magic selection view as a subview to the view controller
    _magicSelectionView = [[AdobeLabsUXMagicSelectionView alloc] initWithFrame:
        CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [_magicSelectionView setImage: image withCompletionBlock: myCompletionBlock];
    [self.view addSubview: _magicSelectionView];
 
 <b>Note:</b> <fakeout>setImage</fakeout> is asynchronous and requires the use of a completion block for robust operation.  See setImage:withCompletionBlock: for more information.
 
 Once the user performs a selection, the raw foreground and matte data can be obtained via the readForegroundAndMatteIntoBuffer: method:
 
    size_t w = _magicSelectionView.image.size.width;
    size_t h = _magicSelectionView.image.size.height;
    uint8_t *data = (uint8_t *)malloc(4*w*h*sizeof(uint8_t));
    [_magicSelectionView readForegroundAndMatteIntoBuffer:data];
 
 The data that is read into the buffer by readForegroundAndMatteIntoBuffer consists of RGBA pixels where the RGB portion contains the foreground color corrected <fakeout>image</fakeout> and the A portion contains the matte, where 0xFF means the pixel is part of the foreground, 0x00 means the pixel is part of the background and values in the range of 0xFE and 0x01 represent pixels that are a mix of foreground and background where the value is the 'weight' of the mix with higher numbers representing a greater ratio of foreground to background.   Since the RGB portion of the <fakeout>image</fakeout> contains color corrected foreground color components, if the pixel values are scaled by the matte values, the foreground selection can be exposed.
 
 In the following example, the matte data is used to do this:
 
    for (int i = 0; i < 4*w*h; i += 4)
    {
        float alpha = (float)data[i + 3] / 255; // extract the matte value as a scale factor
        data[i]     *= alpha;
        data[i + 1] *= alpha;
        data[i + 2] *= alpha;
    }
 
    // now that the foreground selection is exposed, create a UIImage from the data
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(data, w, h, 8, 4*w, colorSpace, (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage * foregroundImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(data);
 
    // The extracted foreground selection is now in the UIImage foregroundImage.
 
 <b>Note:</b> For more information on the returned <fakeout>image</fakeout> format, see readForegroundAndMatteIntoBuffer:
 
 Alternatively, if you don't need to process the underlying bitmap directly, and intend to use the results as inputs to CoreGraphics or CoreImage, you can call:
 
    UIImage *foreground;
    UIImage *matte;
    [_magicSelectionView getForeground:&foreground andMatte:&matte];
 
 The `AdobeLabsUXMagicSelectionView` also provides facilities for manually adding and processing strokes. In the following example, a tap gesture is used as an eraser, by drawing background strokes in response to a `UITapGestureRecognizer` that has been added to the `AdobeLabsUXMagicSelectionView`.
 
 - (void)didTap:(UITapGestureRecognizer *)tapGesture
 {
     // Remember the previous brush mode to restore later and set the brush to background mode
     AdobeLabsMagicSelectionBrushMode prevBrushMode = self.mattingView.brushMode;
     _magicSelectionView.brushMode = AdobeLabsMagicSelectionBrushModeBackground;
 
     // Draw a point into the background stroke map at the tap location.
     [_magicSelectionView strokeMoveToPoint:[tapGesture locationInView:_magicSelectionView]];
     [_magicSelectionView strokeAddLineToPoint:[tapGesture locationInView:_magicSelectionView]];
 
     // Start selection computation.
     [_magicSelectionView startProcessingSelectionInBackground:^{
         // Restore the brush mode on completion
         _magicSelectionView.brushMode = prevBrushMode;
     }];
 }
 
 */
@interface AdobeLabsUXMagicSelectionView : UIView<GLKViewDelegate, UIGestureRecognizerDelegate>

/** @name Properties */

/** Determines whether user strokes will affect the foreground, background, or mixed channel.
 */
@property (nonatomic) AdobeLabsMagicSelectionBrushMode brushMode;

/** Radius of the brush applied when the user strokes the <fakeout>image</fakeout>, in Points.
 */
@property (nonatomic) NSUInteger brushSize;

/** The softness of the brush.
 *
 * <fakeout>brushSoftness</fakeout> is used to compensate for the fat finger issue. Higher softness
 * make the brush more sensitive to the content of the image and will give less weight to portions of the
 * stroke that appear to be unintended. Lower softness means the brush is less sensitive to the image
 * content and all regions of the stroke will be weighted equally. Valid values are between 0.0 and 1.0.
 * The default value is 0.5.
 */
@property (nonatomic) CGFloat brushSoftness;

/** The current pan origin of the content displayed in the view.
 *
 */
@property CGPoint contentOffset;

/** Read-only access to the UIImage that the on which selection is currently being performed.
 */
@property (strong, readonly) UIImage *image;

/** Returns whether or not the <fakeout>image</fakeout> was resized.
 *
 * The <fakeout>image</fakeout> passed into setImage:withCompletionBlock may require downsizing if its size exceeds
 * the device capabilities. In this case, the results returned via the <fakeout>image</fakeout> property, as well as
 * readForegroundAndMatteIntoBuffer will be smaller than the original input <fakeout>image</fakeout>. This property
 * indicates that such a resize has taken place.
 */
@property (nonatomic, readonly) BOOL imageWasResized;

/** A floating-point value that specifies the maximum scale factor that can be applied to the <fakeout>image</fakeout>.
 *
 * This value determines how large the content can be scaled when the user uses the pinch gesture to zoom in. It must be greater than the
 * minimmum zoom scale for zooming to be enabled. The default value is 1.0.
 */
@property CGFloat maximumZoomScale;

/** A floating-point value that specifies the minimum scale factor that can be applied to the <fakeout>image</fakeout>.
 *
 * This value determines how small the <fakeout>image</fakeout> can be scaled when the user uses the pinch gesture to
 * zoom out. The default value is 1.0.
 */
@property CGFloat minimumZoomScale;

/** A floating-point value that specifies the current scale factor applied to the <fakeout>image</fakeout>.
 *
 * This value determines how much the <fakeout>image</fakeout> is currently scaled. The default value is 1.0.
 *
 */
@property CGFloat zoomScale;

/** @name Instance Methods */

/** Manually <fakeout>clear</fakeout> all strokes in the stroke map
 *
 * The strokes will be cleared and the <fakeout>display</fakeout> will be updated asynchronously
 *
 */
- (void)clearStrokes;

/** Manually <fakeout>clear</fakeout> all strokes in the stroke map with completion callback
 *
 * The strokes will be cleared and the <fakeout>display</fakeout> will be updated asynchronously.  The completionBlock
 * will be called when the <fakeout>display</fakeout> update is complete.
 *
 * @param completionBlock the block to call when the <fakeout>display</fakeout> update is complete
 *
 */
- (void)clearStrokes:(void(^)(void))completionBlock;

/** Force the view to redraw with the latest matte texture data
 */
- (void)display;

/** Retrieves the foreground and matte data as UIImage objects.
 *
 * @param foregroundImage UIImage output representing the corrected foreground.
 * @param matteImage UIImage output representing the grayscale matte.
 *
 * @note the RGB data is the foreground <fakeout>image</fakeout> is corrected, and the matte <fakeout>image</fakeout> is a grayscale <fakeout>image</fakeout> representing the strength of the colors in the foreground <fakeout>image</fakeout>.
 *
 * @see readForegroundAndMatteIntoBuffer for more details
 */
- (void)getForeground:(UIImage **)foregroundImage andMatte:(UIImage **)matteImage;

/** Initialize the magic selection view with a coder.
 */
- (id)initWithCoder:(NSCoder *)aDecoder;

/** Initialize the magic selection view with a frame.
 */
- (id)initWithFrame:(CGRect)frame;

/** Retreive current matte and corrected foreground pixels.
 *
 * This assumes foregroundMattePixels has been initialized to the proper size for the current <fakeout>image</fakeout>.
 *
 * @param foregroundMattePixels allocated buffer to receive the foreground and matte pixel data.
 *
 * @note The RGB pixel values in the foreground portion are corrected by having the color components of the background at those
 *       locations removed.  For example, if a pixel in the source <fakeout>image</fakeout> is purple (0xFF00FF) and is determined to consist of 50%
 *       foreground (red) and 50% background (blue), then the corrected and returned RGB data at that pixel will be red (0xFF0000)
 *       and the alpha value will be 50% (0x80), representing the strength of red in the foreground.
 */
- (void)readForegroundAndMatteIntoBuffer:(uint8_t *)foregroundMattePixels;

/** Manually pan the <fakeout>image</fakeout> in the view
 *
 * @param contentOffset the offset origin to pan to
 * @param animated whether or not the panning should be animated
 *
 */
- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;

/** Asynchronously set the <fakeout>image</fakeout>, calling completion block when done.
 *
 * If the <fakeout>image</fakeout> size exceeds the device capabilities, <fakeout>image</fakeout> will be resized internally.
 * This resized <fakeout>image</fakeout> is returned by the <fakeout>image</fakeout> getter property, and results returned from
 * readForegroundAndMatteIntoBuffer will also reflect the smaller resized <fakeout>image</fakeout>. The imageWasResized property
 * may be used to query whether the <fakeout>image</fakeout> was resized.
 *
 * @note setImage will prompt the user to sign-in or sign-up to the Creative Cloud if the user
 * is on the network and not already logged in.  As a result it is important to provide a completion block so you know
 * if the the setImage was successful or not.  If setImage is successful the error passed into the
 * completion block will be nil.    If the user is prompted for login and the login is not successful,
 * the error returned in the completionBlock will be of error domain `AdobeAuthErrorDomain`.
 *
 * @param image <fakeout>Image</fakeout> on which to perform selection.
 * @param completionBlock Called when setting of <fakeout>image</fakeout> is complete.
 */
- (void)setImage:(UIImage *)image withCompletionBlock:(void(^)(NSError * error))completionBlock;

/** Manually set the zoom scale of the view
 *
 * @param zoomScale the <fakeout>zoomScale</fakeout> to set for the view
 * @param animated whether or not the zooming should be animated
 *
 */
- (void)setZoomScale:(CGFloat)zoomScale animated:(BOOL)animated;

/** Start the processing of touch events.
 *
 * There must exist at least one new touch point to be processed. Additional touch points may
 * be added to the buffer during processing, as processing takes place asynchronously on a
 * background thread. When there are no more touch points to be processed, the optional
 * completionBlock is called (always on the main thread).
 *
 * @param completionBlock called when there are no more touch points to be processed. May be nil.
 */
- (void)startProcessingSelectionInBackground:(void(^)(void))completionBlock;

/** Manually update the stroke map by adding a line to the point
 *
 * @param point the point to add a line to for the current stroke in the stroke map
 * @see strokeMoveToPoint
 *
 */
- (void)strokeAddLineToPoint:(CGPoint)point;

/** Manually update the stroke map by moving the start of a stroke to the point
 *
 * @param point the point to move the start of a new stroke in the stroke map to
 *
 * @see strokeAddLineToPoint
 */
- (void)strokeMoveToPoint:(CGPoint)point;

@end
