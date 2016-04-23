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
 `AdobeLabsMagicDepthMapper` automatically computes the depth map of an image
 and returns it as a grayscale visual depth map.
 
    // load an image and generate a depth map
    UIImage * sourceImage = [UIImage imageNamed: @"sourceImage.jpg"];
    AdobeLabsMagicDepthMapper * magicDepthMapper = [[AdobeLabsMagicDepthMapper alloc] init];
    [magicDepthMapper estimateDepthMap: sourceImage withCompletionBlock: ^(NSError * error) {
    if (error == nil) {
        UIImage * grayscaleDepthMap = [magicDepthMapper getDepthMap];
        }
    }];
 
 **/
@interface AdobeLabsMagicDepthMapper : NSObject

/** @name Instance Methods */

/**
 * Estimate a depth map from the input image. This asynchronous call must include a callback that
 * will be called when the processing completes (or fails). Note that sending a `nil` image will
 * not result an error, but calling `estimateDepthMap` again before a previous call has completed will
 * trigger an error in all but the most recent callback.
 *
 * @param image input image
 * @param completionBlock the block to call when the processing of the `image` is complete
 **/
-(void) estimateDepthMap:(UIImage*)image withCompletionBlock:(void(^)(NSError *error))completionBlock;

/**
 * Return estimated depth map. This method will return the estimated depth map in the format of a UIImage.
 *
 * @return the grayscale depth map
 **/
- (UIImage *) getDepthMap;


@end
