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


/**
 * Defines how the underlying `image` should have its perspective corrected.
 * Change the `mode` property of the view instance using this enum type to modify the correction
 * type. Note that some modes may look identical if the underlying image does not provide enough
 * data to fully extract the scene's perspective.
 **/
typedef NS_ENUM(NSUInteger, AdobeLabsMagicPerspectiveMode)
{
    /** Do nothing, image is unchanged  */
    AdobeLabsMagicPerspectiveModeNone = 5,
    /** Provides a balanced adjustment of the image */
    AdobeLabsMagicPerspectiveModeAutomatic = 0,
    /** Combines horizontal and vertical mode to fully straighten image */
    AdobeLabsMagicPerspectiveModeRectify = 4,
    /** Attempts to make world horizontal lines exactly left to right */
    AdobeLabsMagicPerspectiveModeHorizontal = 1,
    /** Attempts to make world vertical lines exactly up and down */
    AdobeLabsMagicPerspectiveModeVertical = 2,
    /** Makes the image level by looking for a horizon */
    AdobeLabsMagicPerspectiveModeLevel = 3
};

/**
 `AdobeLabsUXMagicPerspectiveView` is a subclass of UIView that provides several ways to correct a
 crooked urban <fakeout>image</fakeout>. It does so by reimagining what the scene will look like if 
 the camera were moved to a different location.
 
 The underlying algorithm relies on the straight lines found in man-made scenes. It will therefore
 work best in urban, or other man-made environments (indoor or outdoor). If there are not 
 sufficient clues about the perspective of the scene, the algorithm will attempt to find the scene's
 horizon.
 
 Each of the different ways to deform the image are referred to as the `mode`.
 
 The view also provides functionality to the UIScrollView, enabling users to pan and zoom on the 
 image.
 
 In the typical workflow the user's panning and zooming is combined with the `mode` to deform the
 image, which can then be extracted and saved, or used in a subsequent part of an application.
 
 An `AdobeLabsUXMagicPerspectiveView` instance can be added to the view hierarchy programmatically,
 or via Interface Builder by setting the custom class for a view.
 
 The following code illustrates how to programmatically create a Magic Perspective View and add it 
 to your view controller:
 
     // load a UIImage to use from the app resource bundle
     UIImage * image = [UIImage imageNamed:@"myCrookedImage.jpg"];
 
     // create the Magic Perspective View, set the image, and add the View as a subview to the
     // view controller
     _magicPerspectiveView = [[AdobeLabsUXMagicPerspectiveView alloc] initWithFrame:self.bounds]];
     [_magicPerspectiveView setImage: image withCompletionBlock: myCompletionBlock];
     [self.view addSubview: _magicSelectionView];
 
 <b>Note:</b> setImage is asynchronous and requires the use of a completion block for robust
 operation. See setImage:withCompletionBlock: for more information. Also note that `setImage` will
 prompt the user to sign-in or sign-up to the Creative Cloud if the user is not already logged in. 
 See setImage for more detail.
 
 Once the processing is complete, the `mode` property can be changed.
 
     [_magicPerspectiveView setMode :AdobeLabsMagicPerspectiveModeAutomatic];
 
 This can be done fully programmatically, or you can connect such manipulations to your own UI.
 
 Once the user is done fine-tuning the resulted image (by utilizing zooming and panning), the 
 modified image can be accessed.
 
     UIIimage * result = [_magicPerspectiveView :image];
 
 Note that this <fakeout>image</fakeout> will have exactly the same size as the original 
 <fakeout>image</fakeout>. You can now either save the <fakeout>image</fakeout>, or use it in the 
 next part of your application.
 
 */
@interface AdobeLabsUXMagicPerspectiveView : UIView <UIScrollViewDelegate>

/** @name Properties */

/**
 * Underlying image (including the user and mode transformations applied to it). 
 * In order to modify the image a special `setImage` is provided that includes a completion block.
 * This property will always have the same dimensions.
 * @note The property is marked as `readonly` because a special (asynchronous) setter is provided.
 * @see getImage
 **/
@property (readonly, nonatomic) UIImage* image;


/**
 * A floating-point value that specifies the current scale factor applied to the view’s content.
 * This property is reset to `1.0` whenever the `mode` is changed.
 **/
@property CGFloat zoomScale;

/**
 * The point at which the origin of the content view is offset from the origin of the scroll view.
 * This property is automatically reset whenever the `mode` is changed in order to center the
 * image content as best as possible.
 **/
@property CGPoint contentOffset;

/**
 * A floating-point value that specifies the minimum scale factor that can be applied to the view’s
 * content. This value is determined programmatically based off of the `mode`, and cannot be 
 * changed.
 **/
@property (readonly) CGFloat minimumZoomScale;

/**
 * A floating-point value that specifies the maximum scale factor that can be applied to the view’s
 * content. By default the value is `3.0`.
 **/
@property CGFloat maximumZoomScale;

/**
 * The apparent size of the `image`. If no `mode` is set (or `AdobeLabsMagicPerspectiveModeNone`)
 * then this value will be the aspect-scalled-to-fit size of the `image`. Transform `mode`s will
 * change the content size as the image is deformed by the corresponding transform.
 **/
@property (readonly) CGSize contentSize;

/**
 * The frame rectangle of the sub-view that is showing the `image`. This rectangle describes the
 * location and size of the sub-view showing the `image`. Since the `image` may not fill the entire
 * space given to this (Magic Perspective View) view, a sub-view is created to tightly wrap the
 * `image`. This readonly property gives access to its frame.
 **/
@property (readonly) CGRect activeFrame;

/**
 * Whether or not the processing is complete. This value will be `YES` if `setImage` has been called
 * and completed. Otherwise it will return `NO`.
 **/
@property (nonatomic, readonly, getter=isComplete) BOOL complete;

/**
 * The current perspective correction mode. Changing the mode will deform the image using a
 * calculated transformation to correct the image perspective in the corresponding way. It will
 * also reset the `contentOffset` and `zoomScale` to center the newly transformed image as best as
 * possible (overwriting any past changes to these values).
 * In order to undo any user interaction you can simply get the mode, and then re-set it.
 * @see AdobeLabsMagicPerspectiveMode
 */
@property (nonatomic) AdobeLabsMagicPerspectiveMode mode;

/** @name Instance Methods */

/**
 * Special setter for the underlying `image`. This asynchronous call must include a callback that
 * will be called when the processing completes (or fails). Note that sending a `nil` image will
 * not result an error, but calling `setImage` again before a previous call has completed will
 * trigger an error in all but the most recent callback. This method will reset the mode to 
 * the default (`None`) and subsequently the zoomScale, contentOffset, etc.
 * 
 * @param completionBlock the block to call when the processing of the `image` is complete (or 
 *        fails)
 * @param image the UIImage to display, analyze, and operate one
 * 
 * @note setImage will prompt the user to sign-in or sign-up to the Creative Cloud if the user
 * is on the network and not already logged in.  As a result it is important to provide a completion block so you know
 * if the the setImage was successful or not.  If setImage is successful the error passed into the
 * completion block will be `nil`.  If the user was prompted for login and the login is not successful,
 * the error returned in the completionBlock will be of error domain `AdobeAuthErrorDomain`.
 **/
-(void) setImage:(UIImage*)image withCompletionBlock:(void(^)(NSError *error))completionBlock;



@end
