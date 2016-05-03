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

/**
 `AdobeLabsMagicVectorizer` is a single channel vectorizer.
  It turns an image into a cubic bezier path of outlines.
 
    // load a UIImage, make a Magic Vectorizer, and tell it to vectorize the image
    UIBezierPath * vectorizedPath =
        [[[AdobeLabsMagicVectorizer alloc] init] vectorize: [UIImage imageNamed:@"myImage.jpg"]];
 
 Note: you wouldn't normally alloc and init the vectorizer and tell it to vectorize all at once,
 but I wanted to illustrate usage in one line of code!  :)
 
  You would probably do something more like this:
 
    UIImage * sourceImage = [UIImage imageNamed: @"myImage.jpg"];
    AdobeLabsMagicVectorizer * magicVectorizer = [[AdobeLabsMagicVectorizer alloc] init];
 
    magicVectorizer.smoothing = 3.0;           // 0.0 - 4.0, default 1.0
    magicVectorizer.downsampling = 2;          // 0 - 4, default 1
    magicVectorizer.makeBezierCurves = YES;    // default YES, NO means create line segments
    magicVectorizer.iso = 228;                 // 1 - 254, default 127, see below for meaning
 
    UIBezierPath * vectorizedPath = [magicVectorizer vectorize: sourceImage];
 */
@interface AdobeLabsMagicVectorizer : NSObject

/** How much smoothing to apply for vectorization.
 *
 * Smoothing may be specified in the range of [0.0 .. 4.0].  The default is 1.
 * The value is the sigma value input to a Gaussian Blur which is performed before
 * vectorization.  The higher the sigma value, the more blur.  Blur can help get rid
 * of speckles that interfere with the vectorization algorithm.
 */
@property CGFloat smoothing;

/** How much downsampling to apply before vectorization.
 *
 * Downsampling may be specified in the range of [0 .. 4].  The default is 1.
 * This value is a power of 2, and determines how the image will be downsampled
 * before vectorization is performed.  The image will be downsampled into blocks of 2^downsampling pixels.
 * Downsampling trades quality for speed.  A higher value will make the algorithm run faster at the
 * expense of quality.
 */
@property NSUInteger downsampling;

/** Whether to create Bezier Curves or Line Segments
 *
 * This value defaults to YES which causes the algorithm to make bezier curves.  Setting it to NO will
 * cause line segments to be produced instead of bezier curves.
 */
@property BOOL makeBezierCurves;

/** The iso value for the grayscale threshold.
 *
 * This iso value can be specified in the range of [1 .. 254].  The default is 127.
 * Internally the vectorizer operates on 8-bit grayscale images.  (Color images will
 * be converted to grayscale internally before the algorithm is applied).  The iso value determines
 * at what threshhold of depth (grayscale value) the Vectorizer will operate.
 */
@property NSUInteger iso;

/**
 * Vectorizes a UIImage into a UIBezierPath
 *
 * @param image the UIImage to vectorize
 * @return the UIBezier path of the vectorized image
 *
 * @note This function executes on the current thread.  Also, if the user is on the network
 * and not logged into Creative Cloud, vectorize will not operate and will return nil.
 * It is the responsibility of the caller to ensure, if the user is on the network, that the
 * user is authenticated with Creative Cloud prior to calling this function.
 **/
- (UIBezierPath *)vectorize: (UIImage *)image;

@end

