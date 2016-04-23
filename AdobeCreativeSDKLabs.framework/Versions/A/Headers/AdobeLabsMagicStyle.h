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

/** The `AdobeLabsMagicStyle` class provides an automatic way of transferring the photographic style -- more specifically the color palette, contrast, and tone -- of an image to another image. It extracts the style of a reference photograph and applies that style to any other photograph of their choice. Use it to quickly stylize your images by using your favorite photographs as inspiration, or use it to make an entire collection of images match a common color theme.
 **/

@interface AdobeLabsMagicStyle : NSObject


/** Specify the input image to be stylized
 * @param completionBlock: the block to call when the processing of the `image` is complete (or fails)
 * @param inputImage: input image
 * @note
 **/
- (void) setInputImage: (UIImage *)inputImage withCompletionBlock:(void(^)(NSError *error))completionBlock;

/** Stylize the input image using the style of the reference image
 * @param referenceImage: reference image to be used as style guide
 * @return stylized input image
 **/
- (UIImage *) applyStyleFrom: (UIImage *)referenceImage;

/** Clear the currently specified style
 * @return unedited input image
 **/
- (UIImage *) clearStyle;


@end
