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

/**
 `AdobeLabsMagicCutoutMaker` automatically computes the salient part of an image
and generates a grayscale visual saliency map and a bi-level mask of the salient part.
 
    // load an image and generate a saliency map
    UIImage * sourceImage = [UIImage imageNamed: @"sourceImage.jpg"];
    AdobeLabsMagicCutoutMaker * magicCutoutMaker = [[AdobeLabsMagicCutoutMaker alloc] init];
    [magicCutoutMaker estimateSaliency: sourceImage withCompletionBlock: ^(NSError * error) {
    if (error == nil) {
        UIImage * grayscaleSaliencyMap = [magicCutoutMaker getOutput];
        }
    }];
 
 **/
@interface AdobeLabsMagicCutoutMaker : NSObject

/** @name Properties */

/**
 * Estimate a saliency map from the input image. This asynchronous call must include a callback that
 * will be called when the processing completes (or fails). Note that sending a `nil` image will
 * not result an error, but calling `estimateSaliency` again before a previous call has completed will
 * trigger an error in all but the most recent callback.
 *
 * @param image input image
 * @param completionBlock the block to call when the processing of the `image` is complete
 **/
-(void) estimateSaliency:(UIImage*)image withCompletionBlock:(void(^)(NSError *error))completionBlock;

/**
 * Estimate a bi-level foreground mask for the input image. This asynchronous call must include a callback that
 * will be called when the processing completes (or fails). Note that sending a `nil` image will
 * not result an error, but calling `estimateCutout` again before a previous call has completed will
 * trigger an error in all but the most recent callback.
 *
 * @param image input image
 * @param completionBlock the block to call when the processing of the `image` is complete
 **/
-(void) estimateCutout:(UIImage*)image withCompletionBlock:(void(^)(NSError *error))completionBlock;

/** Return estimated depth map. This method will return the estimated depth map in the format of a UIImage.
 *
 * @return the grayscale saliency map or the bi-level cutout mask, whichever was requested
 **/
- (UIImage *) getOutput;


@end